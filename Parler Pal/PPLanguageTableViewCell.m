//
//  PPLanguageTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguageTableViewCell.h"
#import "PPDatabaseManager.h"

@implementation PPLanguageTableViewCell
@synthesize language, status, level;

#pragma mark -
#pragma mark setup methods

-(void)layoutSubviews
{

}

#pragma mark -
#pragma mark action methods

-(IBAction)statusChange:(id)sender
{
    if(self.status.selectedSegmentIndex == 0 || self.status.selectedSegmentIndex == 1)
    {
        self.level.enabled = YES;
    }
    
    else
    {
        self.level.enabled = NO;
        self.level.selectedSegmentIndex = -1;
    }
    
    [self saveUserLanguageInformation];
}

-(IBAction)levelChange:(id)sender
{
    [self saveUserLanguageInformation];
}

#pragma mark -
#pragma mark save user information methods

-(void)saveUserLanguageInformation
{
    [[PPDatabaseManager sharedDatabaseManager]updateLanguageWithName:language.text languageStatus:(int)status.selectedSegmentIndex languageLevel:(int)level.selectedSegmentIndex finish:^(bool success) {}];
}

@end
