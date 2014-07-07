//
//  PPPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalsViewController.h"
#import "PPDatabaseManager.h"
#import "PPPal.h"
#import "PPLanguage.h"
#import "JMImageCache.h"

@implementation PPPalsViewController
@synthesize table;

#pragma mark - view methods

-(void)viewDidLoad
{
    [[PPDatabaseManager sharedDatabaseManager]getAllPalsCompletionHandler:^(NSMutableArray *results) {
        friendships = results;
        [self.table reloadData];
    }];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllPalRequestsCompletionHandler:^(NSMutableArray *results) {
        requests = results;
        [self.table reloadData];
    }];

    [super viewDidLoad];
    
    profilePopup = [[PPProfilePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
}

#pragma mark - refresh methods

-(void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllPalsCompletionHandler:^(NSMutableArray *results) {
        friendships = results;
        [self.table reloadData];
    }];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllPalRequestsCompletionHandler:^(NSMutableArray *results) {
        requests = results;
        [self.table reloadData];
    }];
}

#pragma mark - PPPalTableViewCellDelegate Methods
-(void)shouldAcceptRequest:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    
    [[PPDatabaseManager sharedDatabaseManager]confirmFriendshipWith:cell.username.text completionHandler:^(bool success) {
        
        PPPal *userToSwap = nil;
        
        for(PPPal *user in requests)
        {
            if([user.username isEqualToString:cell.username.text])
            {
                userToSwap = user;
            }
        }
        
        if(userToSwap)
        {
            [requests removeObject:userToSwap];
            [friendships addObject:userToSwap];
            [self.table reloadData];
        }
        
    }];
}

-(void)shouldDenyRequest:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text completionHandler:^(bool success) {
        PPPal *userToRemove = nil;
        
        for(PPPal *user in requests)
        {
            if([user.username isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        if(userToRemove)
        {
            [requests removeObject:userToRemove];
            [self.table reloadData];
        }
    }];
}

-(void)shouldDeleteFriend:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text completionHandler:^(bool success) {
        PPPal *userToRemove = nil;
        
        for(PPPal *user in friendships)
        {
            if([user.username isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        if(userToRemove)
        {
            [friendships removeObject:userToRemove];
            [self.table reloadData];
        }
    }];
}

#pragma mark - table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return requests.count > 0 ? 2 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 && requests.count > 0)
    {
        return [requests count];
    }
    
    else if(section == 1 || requests.count == 0)
    {
        return [friendships count];
    }
    
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0 && requests.count > 0)
    {
        return @"Requests";
    }
    
    if (section == 1 || requests.count == 0)
    {
        return @"Friendships";
    }
    
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pal";
    
    PPPalTableViewCell *cell = (PPPalTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPPalTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PPPalTableViewCell *)currentObject;
                cell.delegate = self;
                cell.type = (indexPath.section == 1 || requests.count == 0) ? kPalType : kRequestType;

                PPPal *thePal;
                
                if(cell.type == kPalType) thePal = [friendships objectAtIndex:indexPath.row];
                else thePal = [requests objectAtIndex:indexPath.row];
                
                cell.username.text = thePal.username;
                
                [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, thePal.username]] key:nil
                                placeholder:nil
                                completionBlock:nil
                                failureBlock:nil];
                cell.country.text = thePal.country;
                
                break;
            }
        }
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = nil;
    
    if(indexPath.section == 0 && requests.count > 0)
    {
        PPPal *pal = [requests objectAtIndex:indexPath.row];
        username = pal.username;
    }
    
    else if (indexPath.section == 1 || requests.count == 0)
    {
        PPPal *pal = [friendships objectAtIndex:indexPath.row];
        username = pal.username;
    }
    
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

#pragma mark - segue methods

-(IBAction)unwindPalsViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
