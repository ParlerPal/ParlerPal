//
//  PPReplyPopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
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
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
 
-(IBAction)recordAudio:(id)sender;
-(IBAction)playAudio:(id)sender;
-(IBAction)stopAudio:(id)sender;
-(IBAction)deleteAudio:(id)sender;

//Button Actions
-(IBAction)hide:(id)sender;

//Show and display the popup
-(void)show;

@end