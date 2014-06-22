//
//  PPViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPMainViewController.h"

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
    
    if([PFUser currentUser])
    {
        [self shouldPerformSegueWithIdentifier:@"Login" sender:self];
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y/2.2);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointZero animated:YES];
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
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(-10, 110, 340, 100)];
    welcome.text = @"Welcome";
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.alpha = 0.0;
    welcome.font = [UIFont fontWithName:@"Noteworthy" size:36];
    welcome.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
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

-(BOOL)validateLogin
{
    if([PFUser currentUser]){return YES;}
    
    NSError *error;
    [PFUser logInWithUsername:userName.text password:password.text error:&error];

    if(error)
    {
        welcomeMessage.text = @"Invalid Credentials";
        return NO;
    }
    
    else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark segue methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Login"])
    {
        return [self validateLogin];
    }
    
    return YES;
}

@end
