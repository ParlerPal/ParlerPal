//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PPProfileViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CGPoint *previousPoint; 
}
@property (nonatomic, weak) IBOutlet UITextField *passwordField, *confirmPasswordField, *privateEmailField, *countryField, *sharedEmailField, *skypeIDField, *age;
@property (nonatomic, weak) IBOutlet UITextView *profile;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *gender;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

//Text field action methods for when editing is complete
-(IBAction)fieldDidEndEditing:(id)sender;
//Update password confirm button action
-(IBAction)updatePassword:(id)sender;
//Delete Account!
-(IBAction)deleteAccount:(id)sender;

//Select user profile photo
-(IBAction)selectPhoto:(UIButton *)sender;
-(IBAction)takePhoto:(UIButton *)sender;
@end
