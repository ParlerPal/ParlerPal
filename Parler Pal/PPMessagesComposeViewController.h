//
//  PPMessagesComposeViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/26/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PPMessagesComposeViewController : UIViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate>
{

}
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property (nonatomic, weak) IBOutlet UITextField *toField, *subjectField;
@property (nonatomic, weak) IBOutlet UITextView *messageBox;
@property (nonatomic, strong) CLLocationManager *lm;
@property (nonatomic, strong) CLLocation *location;

-(IBAction)findUserButton:(id)sender;
-(IBAction)sendButton:(id)sender;
-(IBAction)saveButton:(id)sender;
@end
