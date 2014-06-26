//
//  PPViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMainViewController.h"

@interface PPLoginViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
    IBOutlet UILabel *welcomeMessage;
    
    int languageIndex;
    NSArray *welcomeLanguages;
}
@property (nonatomic, strong) IBOutlet UITextField *userName, *password;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property(nonatomic, strong)UILabel *welcomeMessage;

//Check if login credentials are correct
-(IBAction)login:(id)sender;

//Text field action methods for when fields did return
-(IBAction)userFieldDidReturn:(id)sender;
-(IBAction)passwordFieldDidReturn:(id)sender;

//Create an account button action
-(IBAction)createAccount:(id)sender;

@end
