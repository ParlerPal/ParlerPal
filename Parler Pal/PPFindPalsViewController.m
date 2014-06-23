//
//  PPFindPalsViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPFindPalsViewController.h"
#import <Parse/Parse.h>

@implementation PPFindPalsViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    pf = [[PPPalFinder alloc]init];
    pf.delegate = self;
    [pf searchForABatchOfPossiblePals];
    
    [super viewDidLoad];
    
    popup = [[PPLanguagesPopupView alloc]initWithFrame:CGRectMake(60, 200, 208, 159)];
}

#pragma mark -
#pragma mark PPPalFinder delegate methods

-(void)didFindBatchOfPals:(NSArray *)pals
{
    foundPals = pals;
    [self.table reloadData];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
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
                PFUser *friendship = [foundPals objectAtIndex:indexPath.row];
                cell.username.text = [friendship username];
                cell.type = kFoundType;
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
    [popup show];
}


@end
