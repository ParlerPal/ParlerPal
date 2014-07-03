//
//  PPMessagesComposeViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/26/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface PPMessagesComposeViewController : UIViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    BOOL audioMessageRecorded;
}
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, weak) IBOutlet UITextField *toField, *subjectField;
@property (nonatomic, weak) IBOutlet UITextView *messageBox;
@property (nonatomic, strong) CLLocationManager *lm;
@property (nonatomic, strong) CLLocation *location;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

-(IBAction)findUserButton:(id)sender;
-(IBAction)sendButton:(id)sender;
-(IBAction)saveButton:(id)sender;

-(IBAction)recordAudio:(id)sender;
-(IBAction)playAudio:(id)sender;
-(IBAction)stopAudio:(id)sender;
-(IBAction)deleteAudio:(id)sender; 

@end
