//
//  PPMessagesMainViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesMainViewController.h"
#import "SWRevealViewController.h"

@implementation PPMessagesMainViewController
@synthesize sidebarButton;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

@end
