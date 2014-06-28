//
//  PPMessagePopup.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPReplyPopupView.h"

@interface PPMessagePopupView : UIView
{
    IBOutlet UITextView *content;
    IBOutlet UILabel *toLabel;
    IBOutlet UILabel *fromLabel;
    IBOutlet UILabel *subjectLabel;
    IBOutlet UIView *view;
    int messageID;
    PPReplyPopupView *popupReply;
}
@property (nonatomic, strong) IBOutlet UILabel *toLabel, *fromLabel, *subjectLabel;
@property (nonatomic, strong) IBOutlet UITextView *content;
@property (nonatomic, strong) IBOutlet UIView *view;
@property (readwrite) int messageID;

//Button Actions
-(IBAction)hide:(id)sender;
-(IBAction)showReply:(id)sender;

//Show and display the popup
-(void)setup;
-(void)show;

@end
