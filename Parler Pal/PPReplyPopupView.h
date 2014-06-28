//
//  PPReplyPopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPReplyPopupView : UIView <UIGestureRecognizerDelegate>
{
    IBOutlet UIView *view;
    IBOutlet UITextField *toField;
    IBOutlet UITextField *subjectField;
    IBOutlet UITextView *contentField;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITextView *contentField;
@property (nonatomic, strong) IBOutlet UITextField *toField, *subjectField;

//Button Actions
-(IBAction)hide:(id)sender;

//Show and display the popup
-(void)setup;
-(void)show;

@end