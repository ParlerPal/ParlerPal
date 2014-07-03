//
//  PPMessagePopup.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPReplyPopupView.h"
#import <AVFoundation/AVFoundation.h>

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
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UITextView *content;
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, readwrite) int messageID;
@property (nonatomic, readwrite) bool shouldShowReply;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) AVAudioPlayer *player;

//Tells the popup if there is a memo attached and whether or not we should show the audio buttons
-(void)setMemoAttached:(bool)memoAttached;

//Button Actions
-(IBAction)hide:(id)sender;
-(IBAction)showReply:(id)sender;
-(IBAction)deleteMessage:(id)sender;

//prepare and display the popup
-(void)setup;
-(void)show;

//Audio Memo Action
-(IBAction)playAudio:(id)sender;
-(IBAction)stopAudio:(id)sender;

@end
