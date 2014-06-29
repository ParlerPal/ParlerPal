//
//  PPViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPMainViewController.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"

@implementation PPLoginViewController
@synthesize userName, password, scrollView, contentView, welcomeMessage;

#pragma mark -
#pragma mark view methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self animateText];

    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    languageIndex = 0;
    welcomeLanguages = @[@"Welcome",@"أهلا وسهلا", @"Bienvenue",@"Willkommen",@"Benvenuto",@"ようこそ",@"환영합니다",@"歡迎",@"Bem-vindo",@"Merhaba", @"witaj", @"добро пожаловать", @"Ласкаво просимо",@"chào mừng"];
    
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
#pragma mark textfield action methods

-(IBAction)userFieldDidReturn:(id)sender
{
    [self.userName resignFirstResponder];
}

-(IBAction)passwordFieldDidReturn:(id)sender
{
    [self.password resignFirstResponder];
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
#pragma mark create account button action

-(IBAction)createAccount:(id)sender
{

}

#pragma mark -
#pragma mark Welcome text animation methods

-(void)animateText
{
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(-10, 130, 340, 100)];
    welcome.text = @"Welcome";
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.alpha = 0.0;
    welcome.font = [UIFont fontWithName:@"Noteworthy" size:36];
    welcome.textColor = [UIColor colorWithRed:0 green:0  blue:0  alpha:1.0];
    [self.contentView addSubview:welcome];
    [self beginFadeInTextLabel:welcome];
}

-(void)beginFadeInTextLabel:(UILabel *)label
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished){[self fadeOutTextLabel:label];}];
}

-(void)fadeOutTextLabel:(UILabel *)label
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 0.0;
    } completion:^(BOOL finished){
        [self beginFadeInTextLabel:label];
        languageIndex = languageIndex + 1 > welcomeLanguages.count -1 ? 0 : languageIndex + 1;
        label.text = [welcomeLanguages objectAtIndex:languageIndex];
    }];
}

#pragma mark -
#pragma mark login methods

-(IBAction)login:(id)sender
{    
    [[PPDatabaseManager sharedDatabaseManager]signinWithUsername:userName.text password:password.text finish:^(bool success){
        if(success)
        {
            [[PPDataShare sharedSingleton]setCurrentUser:userName.text];
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else {}
    }];
}

@end
