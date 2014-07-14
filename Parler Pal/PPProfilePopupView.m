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
@synthesize username, country, age, gender, profile, languages, view, image, messageButton, score, scoreControl;

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

-(IBAction)changeScore:(id)sender
{
    int newScore = self.scoreControl.selectedSegmentIndex == 1 ? 1 : -1;
    [[PPDatabaseManager sharedDatabaseManager]setRecommendationOfUser:self.username.text recommendation:newScore completionHandler:^(bool success) {
    }];
}

#pragma mark - visibility methods methods

-(void)show
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        [self.languages scrollRangeToVisible:NSMakeRange(0, 0)];
        [self.profile scrollRangeToVisible:NSMakeRange(0, 0)];
        
        [[PPDatabaseManager sharedDatabaseManager]getRecommendationValueOfUser:self.username.text completionHandler:^(int value) {
            if(value == 1 || value == -1)self.scoreControl.selectedSegmentIndex = value ==  -1 ? 0 : 1;
            else self.scoreControl.selectedSegmentIndex = -1;
        }];
    } completion:^(BOOL finished){}];
}

@end