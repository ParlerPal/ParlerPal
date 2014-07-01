//
//  PPPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalsViewController.h"
#import "PPDatabaseManager.h"

@implementation PPPalsViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [[PPDatabaseManager sharedDatabaseManager]getAllPals:^(NSMutableArray *results) {
        friendships = results;
        [self.table reloadData];
    }];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllPalRequests:^(NSMutableArray *results) {
        requests = results;
        [self.table reloadData];
    }];

    [super viewDidLoad];
    
    profilePopup = [[PPProfilePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    profilePopup.delegate = self;
}

#pragma mark -
#pragma mark PPPalTableViewCellDelegate Methods
-(void)shouldAcceptRequest:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    
    [[PPDatabaseManager sharedDatabaseManager]confirmFriendshipWith:cell.username.text finish:^(bool success) {
        
        NSMutableDictionary *userToSwap = nil;
        
        for(NSMutableDictionary *user in requests)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
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
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text finish:^(bool success) {
        NSMutableDictionary *userToRemove = nil;
        
        for(NSMutableDictionary *user in requests)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
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
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text finish:^(bool success) {
        NSMutableDictionary *userToRemove = nil;
        
        for(NSMutableDictionary *user in friendships)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
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

#pragma mark -
#pragma mark table view delegate methods

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
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
                cell.type = (indexPath.section == 1 || requests.count == 0) ? kPalType : kRequestType;
                cell.username.text = cell.type == kPalType ? [[friendships objectAtIndex:indexPath.row]objectForKey:@"username"] : [[requests objectAtIndex:indexPath.row]objectForKey:@"username"];
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
        username = [[requests objectAtIndex:indexPath.row]objectForKey:@"username"];
    }
    
    else if (indexPath.section == 1 || requests.count == 0)
    {
        username = [[friendships objectAtIndex:indexPath.row]objectForKey:@"username"];
    }
    
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

#pragma mark -
#pragma mark segue

-(IBAction)unwindPalsViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
