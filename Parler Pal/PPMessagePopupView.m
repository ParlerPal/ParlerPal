//
//  PPMessagePopup.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPMessagePopupView.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"

@implementation PPMessagePopupView
@synthesize view, content, toLabel, fromLabel, subjectLabel, messageID, replyButton, shouldShowReply, delegate;
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
    
    [[NSBundle mainBundle]loadNibNamed:@"PPMessagePopupView" owner:self options:nil];
    [self addSubview:self.view];
    [self setTransform:CGAffineTransformMakeScale(0, 0)];
    
    popupReply = [[PPReplyPopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
}

-(void)setShouldShowReply:(bool)showReply
{
    [self.replyButton setHidden:!showReply];
}

#pragma mark -
#pragma mark action methods

-(IBAction)hide:(id)sender
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    } completion:^(BOOL finished){[self removeFromSuperview];}];
}

-(IBAction)showReply:(id)sender
{
    [self.view addSubview:popupReply];
    popupReply.toField.text = self.fromLabel.text;
    [popupReply show];
}

-(IBAction)deleteMessage:(id)sender
{
    [self.delegate shouldDeleteMessageWithID:self.messageID];
    
    [self hide:nil];
}

#pragma mark -
#pragma mark visibility methods methods

-(void)show
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished){}];
}

@end
