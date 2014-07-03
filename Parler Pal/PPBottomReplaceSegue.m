//
//  PPBottomReplaceSegue.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPBottomReplaceSegue.h"

@implementation PPBottomReplaceSegue

-(void)perform
{
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    
    [src.view setUserInteractionEnabled:NO];
    
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    dst.view.frame = CGRectMake(src.view.frame.origin.x, src.view.frame.size.height, src.view.frame.size.width, src.view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    src.view.layer.speed = .5;
    src.view.frame = CGRectMake(original.origin.x, original.origin.y-original.size.height, original.size.width, original.size.height);
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:.6f];
}

-(void)animationDone:(id)vc
{
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
    [dst.view setUserInteractionEnabled:YES];
}

@end
