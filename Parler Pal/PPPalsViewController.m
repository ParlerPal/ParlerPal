//
//  PPPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalsViewController.h"
#import <Parse/Parse.h>
#import "PPFriendshipManagement.h"

@implementation PPPalsViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    fm = [[PPFriendshipManagement alloc]init];
    fm.delegate = self;
    [fm getFriendshipRequests];
    [fm getFriendships];
    
    [super viewDidLoad];
    
    popup = [[PPLanguagesPopupView alloc]initWithFrame:CGRectMake(60, 200, 208, 159)];
}

#pragma PPFriendshipManagement delegate methods;

-(void)didGetFriendshipRequests:(NSArray *)theRequests
{
    requests = theRequests;
    [self.table reloadData];
}

-(void)didGetFriendships:(NSArray *)theFriendships
{
    friendships = theFriendships;
    [self.table reloadData];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//requests.count > 0 ? 2 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [requests count];
    }
    
    else if(section == 1)
    {
        return [friendships count];
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0)
    {
        return @"Requests";
    }
    
    if (section == 1)
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
                PFObject *friendship = indexPath.section == 1 ? [friendships objectAtIndex:indexPath.row] : [requests objectAtIndex:indexPath.row];
                NSString *userA = friendship[@"userA"];
                NSString *userB = friendship[@"userB"];
                cell.username.text = [userA isEqualToString:[[PFUser currentUser]username]] ? userB : userA;
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
    [self.view addSubview:popup];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
    [query whereKey:@"user" equalTo:user];
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
    [popup show];
}

@end
