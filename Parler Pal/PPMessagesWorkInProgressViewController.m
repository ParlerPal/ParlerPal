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
#import "PPDataShare.h"

@implementation PPMessagesWorkInProgressViewController
@synthesize table, searchBar, filteredDraftsArray;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllDraftsCompletionHandler:^(NSMutableArray *results) {
        drafts = results;
        [self.table reloadData];
        self.filteredDraftsArray = [NSMutableArray arrayWithCapacity:[drafts count]];
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
        self.filteredDraftsArray = [NSMutableArray arrayWithCapacity:[drafts count]];
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
        return [self.filteredDraftsArray count];
    } else {
        return [drafts count];
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
                PPDraft *draft = [drafts objectAtIndex:indexPath.row];
                
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    draft = [filteredDraftsArray objectAtIndex:indexPath.row];
                } else {
                    draft = [drafts objectAtIndex:indexPath.row];
                }
                
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = draft.from;
                cell.messageLabel.text = draft.subject;
                cell.toLabel.text = draft.to;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, draft.from]] key:nil
                                    placeholder:[UIImage imageNamed:@"profile.png"]
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
        
        [[PPDataShare sharedSingleton]setDraft:results];

        UIStoryboard *sb = self.storyboard;
        PPMessagesComposeViewController *composeViewController = [sb instantiateViewControllerWithIdentifier:@"composeView"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[composeViewController] animated: NO];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
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
            self.filteredDraftsArray = [NSMutableArray arrayWithCapacity:[drafts count]];
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
    [self.filteredDraftsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ OR SELF.from contains[c] %@ OR SELF.to contains[c] %@ OR SELF.message contains[c] %@", searchText, searchText, searchText, searchText];
    filteredDraftsArray = [NSMutableArray arrayWithArray:[drafts filteredArrayUsingPredicate:predicate]];
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
