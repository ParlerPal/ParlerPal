//
//  PPPalTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalTableViewCell.h"

@implementation PPPalTableViewCell
@synthesize username, image, delegate, type, addRemoveButton, rejectButton;

#pragma mark - action methods

-(IBAction)didSelectAddRemoveButton:(id)sender
{
    if(self.type == kPalType)
    {
        [self.delegate shouldDeleteFriend:self];
    }
    
    else if(self.type == kFoundType)
    {
        self.addRemoveButton.enabled = NO;
        [self.delegate shouldRequestFriend:self];
    }
    
    else if(self.type == kRequestType)
    {
        [self.delegate shouldAcceptRequest:self];
    }
}

-(IBAction)rejectRequestButton:(id)sender
{
    if(self.type == kRequestType)
    {
        [self.delegate shouldDenyRequest:self];
    }
}

#pragma mark - setter methods

-(void)setType:(PalTableViewCellType)theType
{
    type = theType;
    
    if(self.type == kPalType)
    {
        [self.addRemoveButton setImage:[UIImage imageNamed:@"deletePalButton.png"]  forState: UIControlStateNormal];
        [self.rejectButton setHidden:YES];
    }
    
    else if(self.type == kFoundType)
    {
        [self.addRemoveButton setImage:[UIImage imageNamed:@"addPalButton.png"] forState: UIControlStateNormal];
        [self.rejectButton setHidden:YES];
    }
    
    else if(self.type == kRequestType)
    {
        [self.addRemoveButton setImage:[UIImage imageNamed:@"addPalButton.png"] forState: UIControlStateNormal];

        [self.rejectButton setHidden:NO];
    }
}

@end
