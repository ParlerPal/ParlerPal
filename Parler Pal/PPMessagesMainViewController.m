//
//  PPMessagesMainViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesMainViewController.h"
#import "SWRevealViewController.h"
#import "PPMessageTableViewCell.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"

@implementation PPMessagesMainViewController
@synthesize sidebarButton, table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessages:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
    }];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Message";
    
    PPMessageTableViewCell *cell = (PPMessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPMessageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"from"];
                cell.messageLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"subject"];
                cell.dateLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"created"];
                break;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageID = [[messages objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:[messageID intValue] andFinish:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        messageContentView.fromLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"from"];
        messageContentView.toLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"to"];
        messageContentView.subjectLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"subject"];
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:[messageID intValue] finish:^(BOOL success) {}];

    }];
    
    [self.view addSubview:messageContentView];
    [messageContentView show];
}

@end
