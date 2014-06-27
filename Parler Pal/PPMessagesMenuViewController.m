//
//  PPMessagesMenuViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesMenuViewController.h"
#import "SWRevealViewController.h"

@implementation PPMessagesMenuViewController
@synthesize tableView;

#pragma mark -
#pragma mark init method

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper.png"]];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    /*
     // configure the destination view controller:
     if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
     [sender isKindOfClass:[UITableViewCell class]] )
     {
     UILabel* c = [(SWUITableViewCell *)sender label];
     ColorViewController* cvc = segue.destinationViewController;
     
     cvc.color = c.textColor;
     cvc.text = c.text;
     }
     */
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc pushFrontViewController:nc animated:YES];
        };
    }
}

@end
