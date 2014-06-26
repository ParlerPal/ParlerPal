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
#pragma mark text field delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y/2.2);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [scrollView setContentOffset:CGPointZero animated:YES];
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
    //[PPUserManagement updatePasswordWithPassword:passwordField.text confirm:confirmPasswordField.text];
    passwordField.text = @"";
    confirmPasswordField.text = @"";
}

-(IBAction)deleteAccount:(id)sender
{
    NSLog(@"DELETE ACCOUNT!");
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
