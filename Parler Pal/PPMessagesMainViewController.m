//
//  PPMessagesMainViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesMainViewController.h"
#import "SWRevealViewController.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"

@implementation PPMessagesMainViewController
@synthesize sidebarButton, table, toolbarTitle, displayType;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.displayType == PPMessagesDisplayTypeUnread)
    {
        self.toolbarTitle.title = @"Unread Messages";
        
        [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeSent)
    {
        self.toolbarTitle.title = @"Sent Messages";
        
        [[PPDatabaseManager sharedDatabaseManager]getAllSentMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeAll)
    {
        self.toolbarTitle.title = @"All Messages";
        
        [[PPDatabaseManager sharedDatabaseManager]getAllReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }

    self.table.allowsMultipleSelectionDuringEditing = NO;

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
    
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    messageContentView.delegate = self;
    
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
    
    if(self.displayType == PPMessagesDisplayTypeUnread)
    {
        [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeSent)
    {
        [[PPDatabaseManager sharedDatabaseManager]getAllSentMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeAll)
    {
        [[PPDatabaseManager sharedDatabaseManager]getAllReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
        }];
    }
}

#pragma mark - Messages Popup View delegate methods

-(void)shouldDeleteMessageWithID:(int)theID
{
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:theID completionHandler:^(bool success) {
        
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
    return [messages count];
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

-(void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageID = [[messages objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:[messageID intValue] completionHandler:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        messageContentView.fromLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"from"];
        messageContentView.toLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"to"];
        messageContentView.subjectLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"subject"];
        messageContentView.messageID = [messageID intValue];
        messageContentView.shouldShowReply = displayType == PPMessagesDisplayTypeSent ? NO : YES;
        messageContentView.memoAttached = [[[messages objectAtIndex:indexPath.row] objectForKey:@"memoAttached"]boolValue];
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:[messageID intValue]completionHandler:^(bool success) {
            if(displayType == PPMessagesDisplayTypeUnread)[messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
        }];

    }];
    
    [self.view addSubview:messageContentView];
    [messageContentView show];
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
        [[PPDatabaseManager sharedDatabaseManager]deleteMessage:[[[messages objectAtIndex:indexPath.row]objectForKey:@"id"]intValue]completionHandler:^(bool success) {
            [messages removeObjectAtIndex:indexPath.row];
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
