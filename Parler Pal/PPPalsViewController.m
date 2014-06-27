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
    
    popup = [[PPLanguagesPopupView alloc]initWithFrame:CGRectMake(60, 200, 208, 159)];
}

#pragma mark -
#pragma mark PPPalTableViewCellDelegate Methods
-(void)shouldAcceptRequest:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    
    [[PPDatabaseManager sharedDatabaseManager]confirmFriendshipWith:cell.username.text finish:^(bool success) {
        
        NSMutableDictionary *userToSwap = NULL;
        
        for(NSMutableDictionary *user in requests)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
            {
                userToSwap = user;
            }
        }
        
        [requests removeObject:userToSwap];
        [friendships addObject:userToSwap];
        [self.table reloadData];
        
    }];
}

-(void)shouldDenyRequest:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text finish:^(bool success) {
        NSMutableDictionary *userToRemove = NULL;
        
        for(NSMutableDictionary *user in requests)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        [requests removeObject:userToRemove];
        [self.table reloadData];
    }];
}

-(void)shouldDeleteFriend:(id)sender
{
    PPPalTableViewCell *cell = (PPPalTableViewCell *)sender;
    [[PPDatabaseManager sharedDatabaseManager]deleteFriendshipWith:cell.username.text finish:^(bool success) {
        NSMutableDictionary *userToRemove = NULL;
        
        for(NSMutableDictionary *user in friendships)
        {
            if([[user objectForKey:@"username"]isEqualToString:cell.username.text])
            {
                userToRemove = user;
            }
        }
        
        [friendships removeObject:userToRemove];
        [self.table reloadData];
    }];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
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

#pragma mark -
#pragma mark PPPalTableViewCell delegate methods

-(void)shouldShowDetails:(NSString *)user
{
    /*
    [self.view addSubview:popup];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
    [query whereKey:@"username" equalTo:user];
    NSArray *allUserLanguages = [query findObjects];
    
    NSMutableString *learningString = [NSMutableString stringWithString:@"I'm Learning:\n"];
    NSMutableString *knowItString = [NSMutableString stringWithString:@"\nI Know:\n"];
    
    for(PFObject *object in allUserLanguages)
    {
        int languageStatusIndex = [[object objectForKey:@"languageStatus"]intValue];
        int languageLevelIndex = [[object objectForKey:@"languageLevel"]intValue];
        
        if(languageStatusIndex == 1)
        {
            [learningString appendString:[NSString stringWithFormat:@"%@: %@ \n",[object objectForKey:@"name"], languageLevelIndex == 0 ? @"Beginner" : languageLevelIndex == 1 ? @"Intermediate" : @"Fluent" ]];
        }
        
        else if(languageStatusIndex == 0)
        {
            [knowItString appendString:[NSString stringWithFormat:@"%@: %@ \n",[object objectForKey:@"name"], languageLevelIndex == 0 ? @"Beginner" : languageLevelIndex == 1 ? @"Intermediate" : @"Fluent" ]];
        }
    }
    popup.textView.text = [NSString stringWithFormat:@"%@%@",learningString,knowItString];
    [popup show];*/
}

@end
