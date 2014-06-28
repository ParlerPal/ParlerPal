//
//  PPMessagesComposeViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/26/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMessagesComposeViewController : UIViewController <UIGestureRecognizerDelegate>
{
    IBOutlet UIBarButtonItem *revealButton;
    IBOutlet UITextField *toField;
    IBOutlet UITextField *subjectField;
    IBOutlet UITextView *messageBox;;
}
@property (nonatomic, strong) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, strong) IBOutlet UITextField *toField, *subjectField;
@property (nonatomic, strong) IBOutlet UITextView *messageBox;

-(IBAction)findUserButton:(id)sender;
-(IBAction)sendButton:(id)sender;
-(IBAction)saveButton:(id)sender;
@end
