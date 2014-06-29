//
//  PPProfileViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPProfileViewController.h"
#import "PPDatabaseManager.h"

@implementation PPProfileViewController
@synthesize passwordField, confirmPasswordField, privateEmailField, countryField, sharedEmailField, skypeIDField, profile, scrollView, contentView, age, gender;

#pragma mark -
#pragma mark view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    [[PPDatabaseManager sharedDatabaseManager]getUserProfileWithFinish:^(NSMutableDictionary *results)
    {
        privateEmailField.text = [results objectForKey: @"email"];
        countryField.text = [results objectForKey: @"country"];
        sharedEmailField.text = [results objectForKey: @"sharedEmail"];
        skypeIDField.text = [results objectForKey: @"skypeID"];
        profile.text = [results objectForKey: @"profile"];
        age.text = [results objectForKey:@"age"];
        [gender setSelectedSegmentIndex:[[results objectForKey:@"gender"]intValue]];
    }];
    
    [self registerForKeyboardNotifications];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark -
#pragma textfield delegate methods

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+10, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark text view delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y/2.2);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textView resignFirstResponder];
}

#pragma mark -
#pragma mark textfield action methods

-(IBAction)fieldDidEndEditing:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark -
#pragma mark gesutre recoginizer methods

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES;
}

#pragma mark -
#pragma mark account action methods

-(IBAction)updatePassword:(id)sender
{
    [self.view endEditing:YES];
    
    if([passwordField.text isEqualToString:confirmPasswordField.text])
    {
        [[PPDatabaseManager sharedDatabaseManager]updatePasswordWithPassword:passwordField.text finish:^(bool success)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your password has been changed." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Passwords did not match, try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
    
    passwordField.text = @"";
    confirmPasswordField.text = @"";
}

-(IBAction)deleteAccount:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Caution!" message:@"There is no coming back from this, choose carefully." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Delete", nil];
    [alert show];
}

#pragma mark -
#pragma mark Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[PPDatabaseManager sharedDatabaseManager]deleteProfileWithFinish:^(bool success) {
            [self performSegueWithIdentifier:@"loginReturn" sender:self];
        }];
    }
    
    else{
        return;
    }
}

#pragma mark -
#pragma mark seque methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"doneSegue"])
    {
        //[PPUserManagement updateUserWithPrivateEmail:privateEmailField.text country:countryField.text sharedEmail:sharedEmailField.text skypeID:skypeIDField.text profile:profile.text age:age.text gender:(int)gender.selectedSegmentIndex];
        
        [[PPDatabaseManager sharedDatabaseManager]updateUserProfileWithEmail:sharedEmailField.text country:countryField.text profile:profile.text skypeID:skypeIDField.text age:age.text gender:(int)gender.selectedSegmentIndex finish:^(bool success) {
            
        }];
        
        return YES;
    }
    
    return YES;
}

@end
