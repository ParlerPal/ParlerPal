//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PPUserManagement.h"

@interface PPProfileViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmPasswordField;
    
    IBOutlet UITextField *privateEmailField;
    
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *sharedEmailField;
    IBOutlet UITextField *skypeIDField;
    
    IBOutlet UITextField *age;
    IBOutlet UISegmentedControl *gender;
    
    IBOutlet UITextView *profile;
    
    IBOutlet UIView *contentView;
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, strong) IBOutlet UITextField *passwordField, *confirmPasswordField, *privateEmailField, *countryField, *sharedEmailField, *skypeIDField, *age;
@property (nonatomic, strong) IBOutlet UITextView *profile;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *gender;

//Text field action methods for when editing is complete
-(IBAction)fieldDidEndEditing:(id)sender;
//Update password confirm button action
-(IBAction)updatePassword:(id)sender;
@end
