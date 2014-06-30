//
//  PPMessagePopup.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPReplyPopupView.h"

@protocol PPMessagesPopupViewDelegate <NSObject>

@required
-(void)shouldDeleteMessageWithID:(int)theID;

@end

@interface PPMessagePopupView : UIView
{
    int messageID;
    PPReplyPopupView *popupReply;
    bool shouldShowReply;
}
@property (nonatomic, weak) IBOutlet UILabel *toLabel, *fromLabel, *subjectLabel;
@property (nonatomic, weak) IBOutlet UIButton *replyButton;
@property (nonatomic, weak) IBOutlet UITextView *content;
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, readwrite) int messageID;
@property (nonatomic, readwrite) bool shouldShowReply;
@property (nonatomic, weak) id delegate;

//Button Actions
-(IBAction)hide:(id)sender;
-(IBAction)showReply:(id)sender;
-(IBAction)deleteMessage:(id)sender;
//Show and display the popup
-(void)setup;
-(void)show;

@end
