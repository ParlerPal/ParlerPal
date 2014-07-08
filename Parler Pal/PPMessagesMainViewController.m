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
#import "PPMessage.h"
#import "JMImageCache.h"

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
        
        PPMessage *messageToDelete = nil;
        
        for(PPMessage *message in messages)
        {
            if(message.dbID == theID)
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
                PPMessage *message = [messages objectAtIndex:indexPath.row];
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = message.from;
                cell.messageLabel.text = message.subject;
                cell.toLabel.text = message.to;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, message.from]] key:nil
                                        placeholder:nil
                                    completionBlock:nil
                                       failureBlock:nil];
                
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                df.dateFormat = @"yyyy-MM-dd hh:mm a";
                df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                cell.dateLabel.text = [df stringFromDate: message.created];
                
                cell.messageID = message.dbID;
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
    PPMessage *message = [messages objectAtIndex:indexPath.row];
    
    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:message.dbID completionHandler:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        
        messageContentView.fromLabel.text = message.from;
        messageContentView.toLabel.text = message.to;
        messageContentView.subjectLabel.text = message.subject;
        messageContentView.messageID = message.dbID;
        messageContentView.shouldShowReply = displayType == PPMessagesDisplayTypeSent ? NO : YES;
        messageContentView.memoAttached = message.memoAttached;
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:message.dbID completionHandler:^(bool success) {
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
        PPMessage *message = [messages objectAtIndex:indexPath.row];
        
        [[PPDatabaseManager sharedDatabaseManager]deleteMessage:message.dbID completionHandler:^(bool success) {
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
