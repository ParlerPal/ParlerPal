//
//  PPMessagesWorkInProgressViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesWorkInProgressViewController.h"
#import "SWRevealViewController.h"
#import "PPDatabaseManager.h"
#import "PPDraft.h"
#import "PPMessageTableViewCell.h"
#import "JMImageCache.h"
#import "PPMessagesComposeViewController.h"

@implementation PPMessagesWorkInProgressViewController
@synthesize table;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllDraftsCompletionHandler:^(NSMutableArray *results) {
        drafts = results;
        [self.table reloadData];
    }];
    
    self.table.allowsMultipleSelectionDuringEditing = NO;
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [table setEditing:NO];
}

#pragma mark - Action methods

-(void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllDraftsCompletionHandler:^(NSMutableArray *results) {
        drafts = results;
        [self.table reloadData];
    }];
}

#pragma mark - table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [drafts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Message";
    
    PPMessageTableViewCell *cell = (PPMessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPMessageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                PPDraft *draft = [drafts objectAtIndex:indexPath.row];
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = draft.from;
                cell.messageLabel.text = draft.subject;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, draft.from]] key:nil
                                    placeholder:nil
                                completionBlock:nil
                                   failureBlock:nil];
                
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                df.dateFormat = @"yyyy-MM-dd hh:mm a";
                df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                cell.dateLabel.text = [df stringFromDate: draft.created];
                
                cell.messageID = draft.dbID;
                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPDraft *draft = [drafts objectAtIndex:indexPath.row];
    
    [[PPDatabaseManager sharedDatabaseManager]getDraftByID:draft.dbID completionHandler:^(PPDraft *results) {
        NSLog(@"%@",results.from);
        
    }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PPDraft *draft = [drafts objectAtIndex:indexPath.row];
        
        [[PPDatabaseManager sharedDatabaseManager]deleteDraftByID:draft.dbID completionHandler:^(bool success) {
            [drafts removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
        }];
    }
}

#pragma mark - Gesture Recognizer Delegate methods

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
