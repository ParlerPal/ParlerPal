//
//  PPMessagesSentViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/28/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPMessagesSentViewController.h"
#import "SWRevealViewController.h"

@implementation PPMessagesSentViewController
@synthesize sidebarButton, table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllSentMessages:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
    }];
    
    self.table.allowsMultipleSelectionDuringEditing = NO;

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
    
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    messageContentView.delegate = self;
}

#pragma mark -
#pragma mark Messages Popup View delegate methods

-(void)shouldDeleteMessageWithID:(int)theID
{
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:theID finish:^(bool success) {
        
        NSMutableDictionary *messageToDelete = nil;
        
        for(NSMutableDictionary *message in messages)
        {
            if([[message objectForKey:@"id"]intValue] == theID)
            {
                messageToDelete = message;
            }
        }
        
        if(messageToDelete)
        {
            [messages removeObject:messageToDelete];
            [self.table reloadData];
        }
        
    }];
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
                cell.messageID = [[[messages objectAtIndex:indexPath.row]objectForKey:@"id"]intValue];
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
        messageContentView.messageID = [messageID intValue];
        messageContentView.shouldShowReply = NO;
        
        if([[messages objectAtIndex:indexPath.row]objectForKey:@"opened"]==NO)
        {
            [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:[messageID intValue] finish:^(bool success) {
                
            }];
        }
    }];
    
    [self.view addSubview:messageContentView];
    [messageContentView show];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[PPDatabaseManager sharedDatabaseManager]deleteMessage:[[[messages objectAtIndex:indexPath.row]objectForKey:@"id"]intValue] finish:^(bool success) {
            [messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
        }];
    }
}

#pragma mark -
#pragma mark Gesture Recognizer Delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
