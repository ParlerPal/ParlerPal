//
//  PPUserRegistrationViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/17/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUserManagement.h"

@interface PPUserRegistrationViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmField;
    IBOutlet UITextField *emailField;
    
    IBOutlet UILabel *welcomeMessage;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
}

@property(nonatomic, strong)UITextField *usernameField, *passwordField, *confirmField, *emailField;
@property(nonatomic, strong)UILabel *welcomeMessage;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;

//Returns if the signup was a sucess
-(BOOL)signup;

//Textfield did end editing so hide it
-(IBAction)textFieldDidReturn:(id)sender;

@end
