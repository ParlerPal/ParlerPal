//
//  PPSearchFilterPopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/10/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPSearchFilterPopupViewDelegate <NSObject>

@required
-(void)didFinishFiltering;

@end

@interface PPSearchFilterPopupView : UIView <UITextFieldDelegate>
@property(nonatomic, weak) IBOutlet UIView *view;
@property(nonatomic, weak) IBOutlet UILabel *minAgeLabel, *maxAgeLabel;
@property(nonatomic, weak) IBOutlet UITextField *usernameField;
@property(nonatomic, weak) IBOutlet UISegmentedControl *genderSegment;
@property(nonatomic, weak) IBOutlet UIStepper *minStepper, *maxStepper;
@property(nonatomic, weak) IBOutlet id delegate;

-(void)show;
-(IBAction)hide:(id)sender;
-(IBAction)minStepper:(id)sender;
-(IBAction)maxStepper:(id)sender;
@end
