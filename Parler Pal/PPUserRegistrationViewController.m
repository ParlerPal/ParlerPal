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

#pragma mark -
#pragma mark view methods

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

#pragma mark -
#pragma mark gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
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
#pragma mark text field action methods

-(IBAction)textFieldDidReturn:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark -
#pragma mark sign up methods

-(IBAction)signup:(id)sender
{
    if(self.usernameField.text == NULL || self.usernameField.text.length <= 0)
    {
         NSLog(@"Missing username!");
    }
    
    else if(self.passwordField.text == NULL || self.confirmField.text == NULL || self.passwordField.text.length <= 0 || self.confirmField.text.length <= 0 || ![self.passwordField.text isEqualToString:self.confirmField.text])
    {
         NSLog(@"Missing or mismatched passwords!");
    }
    
    else if(self.emailField.text == NULL || self.emailField.text.length <= 0)
    {
         NSLog(@"Missing email address!");
    }
    
    [[PPDatabaseManager sharedDatabaseManager]signUpWithUsername:self.usernameField.text password:self.passwordField.text andEmail:self.emailField.text];
    
    [self performSegueWithIdentifier:@"leave" sender:self];
}

#pragma mark - 
#pragma mark pop return methods

-(IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
