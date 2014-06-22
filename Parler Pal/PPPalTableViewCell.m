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
@synthesize username, image, delegate;

#pragma mark -
#pragma mark action methods

-(IBAction)didSelectDetailsButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(shouldShowDetails:)])[self.delegate shouldShowDetails:username.text];
}

-(IBAction)didSelectAddRemoveButton:(id)sender
{
    [PPFriendshipManagement requestFriendshipWith:username.text trusted:NO confirmed:NO];
    if([self.delegate respondsToSelector:@selector(requestFriendshipWith:trusted:confirmed:)])[self.delegate didAddUser:username.text];
}

@end
