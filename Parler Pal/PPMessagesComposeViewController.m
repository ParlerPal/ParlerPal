//
//  PPMessagesComposeViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/26/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPMessagesComposeViewController.h"
#import "SWRevealViewController.h"
#import "PPDatabaseManager.h"

@implementation PPMessagesComposeViewController
@synthesize revealButton, toField, subjectField, messageBox;

#pragma mark -
#pragma mark Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View Methods

- (void)viewDidLoad
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
    
}

#pragma mark -
#pragma mark gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[UITextView class]]) {
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
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
    
    [[PPDatabaseManager sharedDatabaseManager]submitMessageTo:toField.text subject:subjectField.text andMessage:messageBox.text finish:^(bool success) {
        subjectField.text = @"";
        messageBox.text = @"";
    }];
}

-(IBAction)saveButton:(id)sender
{
    
}

@end
