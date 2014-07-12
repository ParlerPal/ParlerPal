//
//  PPProfilePopupView.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/29/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPProfilePopupView.h"
#import "PPDatabaseManager.h"

@implementation PPProfilePopupView
@synthesize username, country, email, skype, age, gender, profile, languages, view, image;

-(id)initWithFrame:(CGRect)frame
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

#pragma mark - setup methods

-(void)setup
{
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(-4, 4);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.5;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    [[NSBundle mainBundle]loadNibNamed:@"PPProfilePopupView" owner:self options:nil];
    [self addSubview:self.view];
    [self setTransform:CGAffineTransformMakeScale(0, 0)];
    self.view.frame = screenSize;
    
    popupReply = [[PPReplyPopupView alloc]initWithFrame:screenSize];
}

#pragma mark - action methods

-(IBAction)hide:(id)sender
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    } completion:^(BOOL finished){[self removeFromSuperview];}];
}

-(IBAction)sendMessage:(id)sender
{
    [self.view addSubview:popupReply];
    popupReply.toField.text = self.username.text;
    [popupReply show];
}

#pragma mark - visibility methods methods

-(void)show
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished){}];
}

@end