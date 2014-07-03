//
//  PPReplyPopupView.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPReplyPopupView.h"
#import "PPDatabaseManager.h"

@implementation PPReplyPopupView
@synthesize view, contentField, subjectField, toField;

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
    
    [[NSBundle mainBundle]loadNibNamed:@"PPReplyPopupView" owner:self options:nil];
    [self addSubview:self.view];
    [self setTransform:CGAffineTransformMakeScale(0, 0)];
    
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

#pragma mark - Core Location Delegate Method

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations objectAtIndex:0];
}

#pragma mark gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    
    return YES;
}

#pragma mark - action methods

-(IBAction)hide:(id)sender
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    } completion:^(BOOL finished){[self removeFromSuperview];}];
    
    [self.lm stopUpdatingLocation];
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
    
    else if(contentField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't Send Message" message:@"A message needs content!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[PPDatabaseManager sharedDatabaseManager]submitMessageTo:toField.text subject:subjectField.text andMessage:contentField.text location: self.location sendMemo:NO completionHandler:^(bool success) {
        subjectField.text = @"";
        contentField.text = @"";
        self.stopButton.enabled = NO;
        self.playButton.enabled = NO;
        self.deleteButton.enabled = NO;
        [self hide:nil];
    }];
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


#pragma mark - AVAudio delegate methods

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

#pragma mark - visibility methods methods

-(void)show
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished){}];
    
    [self.lm startUpdatingLocation];
}

@end
