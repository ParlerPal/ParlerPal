//
//  PPMessagesComposeViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/26/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessagesComposeViewController.h"
#import "SWRevealViewController.h"
#import "PPDatabaseManager.h"

@implementation PPMessagesComposeViewController
@synthesize revealButton, toField, subjectField, messageBox, lm, deleteButton, stopButton, playButton, recordButton;

#pragma mark -
#pragma mark Init Methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View Methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self.revealButton setTarget: self.revealViewController];
    [self.revealButton setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    if(!self.lm)self.lm = [CLLocationManager new];
    self.lm.delegate = self;
    self.lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.lm.distanceFilter = 10.0f;
    self.lm.headingFilter = 5;
    [self.lm startUpdatingLocation];
    
    [self setUpAudio];
}

-(void)setUpAudio
{
    audioMessageRecorded = NO;
    
    self.stopButton.enabled = NO;
    self.playButton.enabled = NO;
    self.deleteButton.enabled = NO;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    NSURL *soundFileURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"memo.m4a"]];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: 1], AVNumberOfChannelsKey, [NSNumber numberWithFloat:12000.0], AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.audioRecorder prepareToRecord];
    }
}

#pragma mark -
#pragma mark Core Location Delegate Method

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations objectAtIndex:0];
}

#pragma mark -
#pragma mark gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[UITextView class]]) {
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark -
#pragma mark Action Methods

-(IBAction)findUserButton:(id)sender
{
    
}

-(IBAction)sendButton:(id)sender
{
    if(toField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"Please choose a recipient." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(subjectField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"A message needs a subject!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(messageBox.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"A message needs content!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[PPDatabaseManager sharedDatabaseManager]submitMessageTo:toField.text subject:subjectField.text andMessage:messageBox.text location: self.location sendMemo:audioMessageRecorded finish:^(bool success) {
        subjectField.text = @"";
        messageBox.text = @"";
        
        self.stopButton.enabled = NO;
        self.playButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }];
}

-(IBAction)saveButton:(id)sender
{
    
}

-(IBAction)recordAudio:(id)sender
{
    if (!self.audioRecorder.recording)
    {
        audioMessageRecorded = YES;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        self.playButton.enabled = NO;
        self.stopButton.enabled = YES;
        [self.audioRecorder record];
    }
}

-(IBAction)playAudio:(id)sender
{
    if (!self.audioRecorder.recording)
    {
        self.stopButton.enabled = YES;
        self.recordButton.enabled = NO;
        
        NSError *error;
        
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.audioRecorder.url error:&error];
        self.audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", [error localizedDescription]);
        else
            [self.audioPlayer play];
    }
}

-(IBAction)stopAudio:(id)sender
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.stopButton.enabled = NO;
    self.playButton.enabled = YES;
    self.recordButton.enabled = YES;
    self.deleteButton.enabled = YES;
    
    if (self.audioRecorder.recording)
    {
        [self.audioRecorder stop];
    } else if (self.audioPlayer.playing) {
        [self.audioPlayer stop];
    }
}

-(IBAction)deleteAudio:(id)sender
{
    audioMessageRecorded = NO;
    
    self.stopButton.enabled = NO;
    self.playButton.enabled = NO;
    self.deleteButton.enabled = NO;
}


#pragma mark -
#pragma AVAudio delegate methods
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.recordButton.enabled = YES;
    self.stopButton.enabled = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"CALL");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
@end
