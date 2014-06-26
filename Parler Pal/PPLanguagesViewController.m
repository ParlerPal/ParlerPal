//
//  PPLanguagesViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguagesViewController.h"
#import "PPLanguageTableViewCell.h"
#import "PPDatabaseManager.h"

@implementation PPLanguagesViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    languages = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SupportedLanguages" ofType:@"plist"]];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllLanguages:^(NSMutableArray *results) {
        allUserLanguages = results;
        [self.table reloadData];
    }];
    
    [super viewDidLoad];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 103.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [languages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"language";
    
    PPLanguageTableViewCell *cell = (PPLanguageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPLanguageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PPLanguageTableViewCell *)currentObject;
                cell.delegate = self;
                break;
            }
        }
    }
    
    cell.language.text = [languages objectAtIndex:indexPath.row];
    
    for(NSDictionary *dict in allUserLanguages)
    {
        if([[dict objectForKey:@"name"]isEqualToString:[languages objectAtIndex:indexPath.row]])
        {
                cell.status.selectedSegmentIndex = [[dict objectForKey:@"languageStatus"]intValue];
                
                if([[dict objectForKey:@"languageStatus"]intValue] == 2)
                {
                    cell.level.enabled = NO;
                }
                
                else if([[dict objectForKey:@"languageStatus"]intValue] == 1 || [[dict objectForKey:@"languageStatus"]intValue] == 0)
                {
                    cell.level.selectedSegmentIndex = [[dict objectForKey:@"languageLevel"]intValue];
                    cell.level.enabled = YES;
                }
                else
                {
                    cell.level.enabled = NO;
                }
         }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
@end
