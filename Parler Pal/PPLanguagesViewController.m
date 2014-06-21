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
    
    [super viewDidLoad];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94.0;
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
    
    return cell;
}

@end
