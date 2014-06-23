//
//  PPPalTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalTableViewCell.h"
#import "PPFriendshipManagement.h"

@implementation PPPalTableViewCell
@synthesize username, image, delegate, type, addRemoveButton, rejectButton;

#pragma mark -
#pragma mark action methods

-(IBAction)didSelectDetailsButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(shouldShowDetails:)])[self.delegate shouldShowDetails:username.text];
}

-(IBAction)didSelectAddRemoveButton:(id)sender
{
    if(self.type == kPalType)
    {
        [PPFriendshipManagement deleteFriendshipWith:username.text];
    }
    
    else if(self.type == kFoundType)
    {
        [PPFriendshipManagement requestFriendshipWith:username.text confirmed:NO];
    }
    
    else if(self.type == kRequestType)
    {
        [PPFriendshipManagement confirmFriendshipWith:username.text];
    }
}

-(IBAction)rejectRequestButton:(id)sender
{
    if(self.type == kRequestType)
    {
        [PPFriendshipManagement deleteFriendshipWith:username.text];
    }
}

#pragma mark -
#pragma mark Setter methods

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
