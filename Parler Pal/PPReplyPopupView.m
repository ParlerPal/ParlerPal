//
//  PPReplyPopupView.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPReplyPopupView.h"
#import "PPDatabaseManager.h"

@implementation PPReplyPopupView
@synthesize view, contentField, subjectField, toField;
#pragma mark -
#pragma mark init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark setup methods

-(void)setup
{
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(-4, 4);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.5;
    
    [[NSBundle mainBundle]loadNibNamed:@"PPReplyPopupView" owner:self options:nil];
    [self addSubview:self.view];
    [self setTransform:CGAffineTransformMakeScale(0, 0)];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    if(!self.lm)self.lm = [CLLocationManager new];
    self.lm.delegate = self;
    self.lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.lm.distanceFilter = 10.0f;
    self.lm.headingFilter = 5;
    [self.lm startUpdatingLocation];
}

#pragma mark -
#pragma mark Core Location Delegate Method

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations objectAtIndex:0];
}

#pragma mark -
#pragma mark gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    
    return YES;
}

#pragma mark -
#pragma mark action methods

-(IBAction)hide:(id)sender
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    } completion:^(BOOL finished){[self removeFromSuperview];}];
    
    [self.lm stopUpdatingLocation];
}

-(IBAction)sendButton:(id)sender
{
    if(toField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"Please choose a recipient." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(subjectField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"A message needs a subject!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(contentField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"A message needs content!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[PPDatabaseManager sharedDatabaseManager]submitMessageTo:toField.text subject:subjectField.text andMessage:contentField.text location: self.location finish:^(bool success) {
        subjectField.text = @"";
        contentField.text = @"";
        [self hide:nil];
    }];
}

#pragma mark -
#pragma mark visibility methods methods

-(void)show
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished){}];
    
    [self.lm startUpdatingLocation];
}

@end
