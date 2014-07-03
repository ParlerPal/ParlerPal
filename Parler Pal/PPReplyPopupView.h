//
//  PPReplyPopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface PPReplyPopupView : UIView <UIGestureRecognizerDelegate, CLLocationManagerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    BOOL audioMessageRecorded;
}
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UITextView *contentField;
@property (nonatomic, weak) IBOutlet UITextField *toField, *subjectField;
@property (nonatomic, strong) CLLocationManager *lm;
@property (nonatomic, strong) CLLocation *location;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
 
-(IBAction)recordAudio:(id)sender;
-(IBAction)playAudio:(id)sender;
-(IBAction)stopAudio:(id)sender;
-(IBAction)deleteAudio:(id)sender;

//Button Actions
-(IBAction)hide:(id)sender;

//Show and display the popup
-(void)setup;
-(void)show;

@end