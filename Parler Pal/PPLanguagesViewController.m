//
//  PPLanguagesViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguagesViewController.h"
#import "PPLanguageTableViewCell.h"

@implementation PPLanguagesViewController
@synthesize table;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    languages = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SupportedLanguages" ofType:@"plist"]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(didGetLanguages:)];
    
    [super viewDidLoad];
}

#pragma mark -
#pragma mark - query did finish method

-(void)didGetLanguages:(NSArray *)theReceivedLanguages
{
    allUserLanguages = theReceivedLanguages;
    [self.table reloadData];
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
                break;
            }
        }
    }
    
    cell.language.text = [languages objectAtIndex:indexPath.row];
    
    for(PFObject *object in allUserLanguages)
    {
        if([object[@"name"]isEqualToString:[languages objectAtIndex:indexPath.row]])
        {
            if(object)
            {
                cell.status.selectedSegmentIndex = [[object objectForKey:@"languageStatus"]intValue];
                
                if([[object objectForKey:@"languageLevel"]intValue] != -1)
                {
                    cell.level.enabled = YES;
                }
                
                else if(cell.status.selectedSegmentIndex == 0 || cell.status.selectedSegmentIndex == 1)
                {
                    cell.level.enabled = YES;
                }
                else
                {
                    cell.level.enabled = NO;
                }
                
                cell.level.selectedSegmentIndex = [[object objectForKey:@"languageLevel"]intValue];
            }
        }
    }
    
    return cell;
}

@end
