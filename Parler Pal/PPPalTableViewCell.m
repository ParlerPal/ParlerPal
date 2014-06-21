//
//  PPPalTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalTableViewCell.h"

@implementation PPPalTableViewCell
@synthesize username, image, delegate;

#pragma mark -
#pragma mark action methods

-(IBAction)didSelectDetailsButton:(id)sender
{
    [self.delegate shouldShowDetails:username.text];
}

-(IBAction)didSelectAddRemoveButton:(id)sender
{
    [self.delegate didAddUser:username.text];
}

@end
