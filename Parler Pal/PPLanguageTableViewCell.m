//
//  PPLanguageTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguageTableViewCell.h"

@implementation PPLanguageTableViewCell
@synthesize language, status, level, delegate;

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
    
    if([self.delegate respondsToSelector:@selector(didAlterLanguageSettingsForCell:)])
    {
        [self.delegate didAlterLanguageSettingsForCell:self];
    }
}

-(IBAction)levelChange:(id)sender
{
    [self saveUserLanguageInformation];
    
    if([self.delegate respondsToSelector:@selector(didAlterLanguageSettingsForCell:)])
    {
        [self.delegate didAlterLanguageSettingsForCell:self];
    }
}

#pragma mark -
#pragma mark save user information methods

-(void)saveUserLanguageInformation
{
    PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
    [query whereKey:@"name" equalTo:self.language.text];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if(object)
        {
            object[@"languageStatus"] = [NSNumber numberWithInt:(int)status.selectedSegmentIndex];
            object[@"languageLevel"] = [NSNumber numberWithInt:(int)level.selectedSegmentIndex];
            [object saveInBackground];
        }
        
        else
        {
            PFObject *object = [PFObject objectWithClassName:@"Languages"];
            object[@"name"] = self.language.text;
            object[@"languageStatus"] = [NSNumber numberWithInt:(int)status.selectedSegmentIndex];
            object[@"languageLevel"] = [NSNumber numberWithInt:(int)level.selectedSegmentIndex];
            object[@"user"] = [PFUser currentUser];
            object[@"username"] = [PFUser currentUser].username;
            [object saveInBackground];
        }
    }];
    
    /*
    PFUser *currentUser = [PFUser currentUser];
    NSDictionary *languageStatuses = currentUser[@"languageStatuses"];
    NSDictionary *languageLevels = currentUser[@"languageLevels"];
    
    currentUser[@"languageStatuses"] = languageStatuses;
    currentUser[@"languageLevels"] = languageLevels;
    
    [languageStatuses setValue:[NSNumber numberWithInt:(int)status.selectedSegmentIndex] forKey:language.text];
    [languageLevels setValue:[NSNumber numberWithInt:(int)level.selectedSegmentIndex] forKey:language.text];
    
    [currentUser setObject:languageStatuses forKey:@"languageStatuses"];
    [currentUser setObject:languageLevels forKey:@"languageLevels"];
    [currentUser saveInBackground];*/
}

@end
