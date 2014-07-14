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
#import "PPSearchFilterPopupView.h"

@implementation PPFindPalsViewController
@synthesize table;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    profilePopup = [[PPProfilePopupView alloc]initWithFrame:screenSize];
    searchFilterView = [[PPSearchFilterPopupView alloc]initWithFrame:CGRectMake(0, 0, screenSize.size.width, 165)];
    searchFilterView.delegate = self;
    
    [[PPDatabaseManager sharedDatabaseManager]getBatchOfPalsWithUsername:searchFilterView.usernameField.text
                                                                  gender:(int)searchFilterView.genderSegment.selectedSegmentIndex
                                                                  minAge:searchFilterView.minStepper.value
                                                                  maxAge:searchFilterView.maxStepper.value
    completionHandler:^(NSMutableArray *results) {
        foundPals = results;
        [self.table reloadData];
    }];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];

}

#pragma mark - action methods

-(IBAction)filter
{
    [self.view addSubview:searchFilterView];
    [searchFilterView show];
}

#pragma mark - refresh methods

-(void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];

    [[PPDatabaseManager sharedDatabaseManager]getBatchOfPalsWithUsername:searchFilterView.usernameField.text
                                                                  gender:(int)searchFilterView.genderSegment.selectedSegmentIndex
                                                                  minAge:searchFilterView.minStepper.value
                                                                  maxAge:searchFilterView.maxStepper.value
    completionHandler:^(NSMutableArray *results) {
        foundPals = results;
        [self.table reloadData];
    }];
}

#pragma mark - PPSearchFilterViewPopupDelegate

-(void)didFinishFiltering
{
    [self refresh:nil];
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
    return [foundPals count];
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
    
    PPPal *pal = [foundPals objectAtIndex:indexPath.row];
    
    cell.username.text = pal.username;
    
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, pal.username]] key:nil
                        placeholder:[UIImage imageNamed:@"profile.png"]
                    completionBlock:nil
                       failureBlock:nil];
    cell.country.text = pal.country;
    cell.recommendationScore.text = [NSString stringWithFormat:@"%@%@",[pal.recommendationScore intValue] >= 0 ? @"+" : @"",pal.recommendationScore];
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
        profilePopup.score.text = results.recommendationScore;
        profilePopup.scoreControl.hidden = YES;
        [profilePopup.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, username]] key:nil
                                placeholder:[UIImage imageNamed:@"profile.png"]
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
                    [know appendString:[NSString stringWithFormat:@"%@ - %@\n", languageName,languageLevel]];
                }
                
                else
                {
                    [learning appendString:[NSString stringWithFormat:@"%@ - %@\n", languageName,languageLevel]];
                }
            }
        }
        
        [fullLanguageString appendString:[NSString stringWithFormat:@"%@\n%@",know, learning]];
        profilePopup.languages.text = fullLanguageString;
        
        [profilePopup show];
    }];
    
}

@end
