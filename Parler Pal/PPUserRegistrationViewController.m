//
//  PPUserRegistrationViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/17/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPUserRegistrationViewController.h"

@implementation PPUserRegistrationViewController
@synthesize usernameField, passwordField, confirmField, emailField, welcomeMessage, scrollView, contentView;

#pragma mark -
#pragma mark view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark -
#pragma mark text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y/2.2);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark -
#pragma mark text field action methods

-(IBAction)textFieldDidReturn:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark -
#pragma mark sign up methods

-(BOOL)signup
{
    self.welcomeMessage.text = [PPUserManagement signUpWithUsername:self.usernameField.text password:self.passwordField.text confirm:self.confirmField.text andEmail:self.emailField.text];
    if([self.welcomeMessage.text isEqualToString:@"Success!"]){return YES;}
    return NO;
}

#pragma mark -
#pragma mark segue methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Signup"])
    {
        return [self signup];
    }
    
    return YES;
}

@end
