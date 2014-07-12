//
//  PPUserRegistrationViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/17/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPUserRegistrationViewController.h"
#import "PPDatabaseManager.h"

@implementation PPUserRegistrationViewController
@synthesize usernameField, passwordField, confirmField, emailField, welcomeMessage, scrollView, contentView;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
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

#pragma mark - gesutre recoginizer methods

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES;
}


// Call this method somewhere in your view controller setup code.
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [activeField.superview setFrame:bkgndRect];
    [scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

#pragma mark - text field action methods

-(IBAction)usernameFieldDidReturn:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField becomeFirstResponder];
}

-(IBAction)passwordFieldDidReturn:(id)sender
{
    [self.passwordField resignFirstResponder];
    [self.confirmField becomeFirstResponder];
}

-(IBAction)confirmFieldDidReturn:(id)sender
{
    [self.confirmField resignFirstResponder];
    [self.emailField becomeFirstResponder];
}

-(IBAction)emailFieldDidReturn:(id)sender
{
    [self.emailField resignFirstResponder];
    [self signup:nil];
}

#pragma mark - sign up methods

-(IBAction)signup:(id)sender
{
    if(self.usernameField.text == NULL || self.usernameField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Missing username." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(self.passwordField.text == NULL || self.confirmField.text == NULL || self.passwordField.text.length <= 0 || self.confirmField.text.length <= 0 || ![self.passwordField.text isEqualToString:self.confirmField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Missing or missmatched password." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if(self.emailField.text == NULL || self.emailField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Missing email address." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[PPDatabaseManager sharedDatabaseManager]signUpWithUsername:self.usernameField.text password:self.passwordField.text andEmail:self.emailField.text];
    
    [self performSegueWithIdentifier:@"leave" sender:self];
}

#pragma mark - pop return methods

-(IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
