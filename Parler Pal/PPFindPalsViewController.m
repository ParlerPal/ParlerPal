//
//  PPFindPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPFindPalsViewController.h"
#import "PPDatabaseManager.h"

@implementation PPFindPalsViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PPDatabaseManager sharedDatabaseManager]getBatchOfPals:^(NSMutableArray *results) {
        foundPals = results;
        [self.table reloadData];
    }];
    
    profilePopup = [[PPProfilePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    profilePopup.delegate = self;
}

#pragma mark -
#pragma mark Friendship Management delegate methods

-(void)shouldRequestFriend:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]requestFriendshipWith:cell.username.text finish:^(bool success) {
        NSMutableDictionary *userToRemove = NULL;
        
        for(NSMutableDictionary *user in foundPals)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        [foundPals removeObject:userToRemove];
        [self.table reloadData];
    }];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return foundPals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pal";
    
    PPPalTableViewCell *cell = (PPPalTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPPalTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PPPalTableViewCell *)currentObject;
                cell.delegate = self;
                cell.type = kFoundType;
                cell.username.text = [[foundPals objectAtIndex:indexPath.row]objectForKey:@"username"];
                break;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[foundPals objectAtIndex:indexPath.row]objectForKey:@"username"];
    
    [[PPDatabaseManager sharedDatabaseManager]getSharedUserProfileForUsername:username WithFinish:^(NSMutableDictionary *results) {
        [self.view addSubview:profilePopup];
        profilePopup.username.text = username;
        profilePopup.profile.text = [results objectForKey:@"profile"];
        profilePopup.gender.text = [[results objectForKey:@"gender"]intValue] == 0 ? @"Male" : [[results objectForKey:@"gender"]intValue] == 1 ? @"Female" : @"N/S";
        profilePopup.country.text = [results objectForKey:@"country"];
        profilePopup.age.text = [results objectForKey:@"age"];
        profilePopup.email.text = [results objectForKey:@"sharedEmail"];
        profilePopup.skype.text = [results objectForKey:@"skypeID"];
        
        NSMutableString *fullLanguageString = [NSMutableString string];
        NSMutableString *learning = [NSMutableString stringWithString:@"I'm Learning:\n"];
        NSMutableString *know = [NSMutableString stringWithString:@"I'm Know:\n"];
        
        for(NSDictionary *language in [results objectForKey:@"languages"])
        {
            if([[language objectForKey:@"languageStatus"]intValue] != 2)
            {
                NSString *languageName = [language objectForKey:@"name"];
                NSString *languageLevel = [[language objectForKey:@"languageLevel"]intValue] == 0 ? @"Beginner" : [[language objectForKey:@"languageLevel"]intValue] == 1 ? @"Intermediate" : @"Fluent" ;
                
                if([[language objectForKey:@"languageStatus"]intValue] == 0)
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

@end
