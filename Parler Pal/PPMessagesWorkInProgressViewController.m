//
//  PPMessagesWorkInProgressViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesWorkInProgressViewController.h"
#import "SWRevealViewController.h"

@implementation PPMessagesWorkInProgressViewController

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = nil;
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
