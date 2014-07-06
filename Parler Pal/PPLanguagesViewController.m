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
#import "PPLanguage.h"

@implementation PPLanguagesViewController
@synthesize table;

#pragma mark - view methods

-(void)viewDidLoad
{
    languages = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SupportedLanguages" ofType:@"plist"]];
    
    [[PPDatabaseManager sharedDatabaseManager]getAllLanguagesCompletionHandler:^(NSMutableArray *results) {
        allUserLanguages = results;
        [self.table reloadData];
    }];
    
    [super viewDidLoad];
}

#pragma mark - table view delegate methods

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"language";
    
    PPLanguageTableViewCell *cell = (PPLanguageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPLanguageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PPLanguageTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    cell.language.text = [languages objectAtIndex:indexPath.row];
    
    for(PPLanguage *language in allUserLanguages)
    {
        if([language.name isEqualToString:[languages objectAtIndex:indexPath.row]])
        {
                cell.status.selectedSegmentIndex = language.languageStatus;
                
                if(language.languageStatus == PPLanguageStatusNeither)
                {
                    cell.level.enabled = NO;
                }
                
                else if(language.languageStatus == PPLanguageStatusLearning || language.languageStatus == PPLanguageStatusKnown)
                {
                    cell.level.selectedSegmentIndex = language.languageLevel;
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

-(void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
@end
