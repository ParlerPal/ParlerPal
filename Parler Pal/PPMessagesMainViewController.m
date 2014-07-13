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
@synthesize sidebarButton, table, toolbarTitle, displayType, filteredMessagesArray, searchBar;

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
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeSent)
    {
        self.toolbarTitle.title = @"Sent Messages";
        
        [[PPDatabaseManager sharedDatabaseManager]getAllSentMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeAll)
    {
        self.toolbarTitle.title = @"All Messages";
        
        [[PPDatabaseManager sharedDatabaseManager]getAllReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }

    self.table.allowsMultipleSelectionDuringEditing = NO;

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:screenSize];
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
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeSent)
    {
        [[PPDatabaseManager sharedDatabaseManager]getAllSentMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
    
    else if(self.displayType == PPMessagesDisplayTypeAll)
    {
        [[PPDatabaseManager sharedDatabaseManager]getAllReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
            messages = results;
            [self.table reloadData];
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
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
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredMessagesArray count];
    } else {
        return [messages count];
    }
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
                PPMessage *message;
                
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    message = [filteredMessagesArray objectAtIndex:indexPath.row];
                } else {
                    message = [messages objectAtIndex:indexPath.row];
                }
                
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = message.from;
                cell.messageLabel.text = message.subject;
                cell.toLabel.text = message.to;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, message.from]] key:nil
                                        placeholder:[UIImage imageNamed:@"profile.png"]
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
    
    messageContentView.fromLabel.text = message.from;
    messageContentView.toLabel.text = message.to;
    messageContentView.subjectLabel.text = message.subject;
    messageContentView.content.text = message.message;
    messageContentView.messageID = message.dbID;
    messageContentView.shouldShowReply = displayType == PPMessagesDisplayTypeSent ? NO : YES;
    messageContentView.memoAttached = message.memoAttached;
        
    if(self.displayType != PPMessagesDisplayTypeSent)
    {
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:message.dbID completionHandler:^(bool success) {
            if(displayType == PPMessagesDisplayTypeUnread)[messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
    
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
            self.filteredMessagesArray = [NSMutableArray arrayWithCapacity:[messages count]];
        }];
    }
}

#pragma mark - Gesture Recognizer Delegate methods

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredMessagesArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ OR SELF.from contains[c] %@ OR SELF.to contains[c] %@ OR SELF.message contains[c] %@", searchText, searchText, searchText, searchText];
    filteredMessagesArray = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    UIImage *patternImage = [UIImage imageNamed:@"paper.png"];
    [controller.searchResultsTableView setBackgroundColor:[UIColor colorWithPatternImage: patternImage]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
