//
//  PPFindPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPFindPalsViewController.h"
#import "PPDatabaseManager.h"
#import "PPPal.h"
#import "PPLanguage.h"
#import "JMImageCache.h"

@implementation PPFindPalsViewController
@synthesize table, filteredPalsArray, searchBar;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PPDatabaseManager sharedDatabaseManager]getBatchOfPalsCompletionHandler:^(NSMutableArray *results) {
        foundPals = results;
        [self.table reloadData];
        self.filteredPalsArray = [NSMutableArray arrayWithCapacity:[foundPals count]];
    }];
    
    profilePopup = [[PPProfilePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];

}

#pragma mark - refresh methods

-(void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];

    [[PPDatabaseManager sharedDatabaseManager]getBatchOfPalsCompletionHandler:^(NSMutableArray *results) {
        foundPals = results;
        [self.table reloadData];
        self.filteredPalsArray = [NSMutableArray arrayWithCapacity:[foundPals count]];
    }];
}

#pragma mark - Friendship Management delegate methods

-(void)shouldRequestFriend:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]requestFriendshipWith:cell.username.text completionHandler:^(bool success) {
        PPPal *userToRemove = NULL;
        
        for(PPPal *user in foundPals)
        {
            if([user.username isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        [foundPals removeObject:userToRemove];
        [self.table reloadData];
    }];
}

#pragma mark - table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredPalsArray count];
    } else {
        return [foundPals count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pal";
    
    PPPalTableViewCell *cell = (PPPalTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPPalTableViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PPPalTableViewCell *)currentObject;
                cell.delegate = self;
                cell.type = kFoundType;
                break;
            }
        }
    }
    
    PPPal *pal;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        pal = [filteredPalsArray objectAtIndex:indexPath.row];
    } else {
        pal = [foundPals objectAtIndex:indexPath.row];
    }
    
    cell.username.text = pal.username;
    
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, pal.username]] key:nil
                        placeholder:nil
                    completionBlock:nil
                       failureBlock:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self view] endEditing: YES];
    
    PPPal *foundPal = [foundPals objectAtIndex:indexPath.row];
    NSString *username = foundPal.username;
    
    [[PPDatabaseManager sharedDatabaseManager]getSharedUserProfileForUsername:username WithFinish:^(PPPal *results) {
        [self.view addSubview:profilePopup];
        profilePopup.username.text = username;
        profilePopup.profile.text = results.profile;
        profilePopup.gender.text = results.gender == PPPalGenderMale ? @"Male" : results.gender == PPPalGenderFemale ? @"Female" : @"N/S";
        profilePopup.country.text = results.country;
        profilePopup.age.text = [NSString stringWithFormat:@"%i",results.age];
        profilePopup.email.text = results.sharedEmail;
        profilePopup.skype.text = results.skypeID;
        [profilePopup.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, username]] key:nil
                                placeholder:nil
                            completionBlock:nil
                               failureBlock:nil];
        
        NSMutableString *fullLanguageString = [NSMutableString string];
        NSMutableString *learning = [NSMutableString stringWithString:@"I'm Learning:\n"];
        NSMutableString *know = [NSMutableString stringWithString:@"I'm Know:\n"];
        
        for(PPLanguage *language in results.languages)
        {
            if(language.languageStatus != PPLanguageStatusNeither)
            {
                NSString *languageName = language.name;
                NSString *languageLevel = language.languageLevel == PPLanguageLevelBeginner ? @"Beginner" : language.languageLevel == PPLanguageLevelIntermediate ? @"Intermediate" : @"Fluent" ;
                
                if(language.languageStatus == PPLanguageStatusKnown)
                {
                    [know appendString:[NSString stringWithFormat:@"%@ - %@", languageName,languageLevel]];
                }
                
                else
                {
                    [learning appendString:[NSString stringWithFormat:@"%@ - %@", languageName,languageLevel]];
                }
            }
        }
        
        [fullLanguageString appendString:[NSString stringWithFormat:@"%@\n\n%@",know, learning]];
        profilePopup.languages.text = fullLanguageString;
        
        [profilePopup show];
    }];
    
}

#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredPalsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@",searchText];
    filteredPalsArray = [NSMutableArray arrayWithArray:[foundPals filteredArrayUsingPredicate:predicate]];
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
