//
//  PPLanguagesPopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLanguagesPopupView : UIView
{

}
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *view;

//Button Actions
-(IBAction)hide:(id)sender;

//Show and display the popup
-(void)setup;
-(void)show;

@end
