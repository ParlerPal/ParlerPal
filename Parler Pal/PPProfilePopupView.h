//
//  PPProfilePopupView.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/29/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPReplyPopupView.h"

@interface PPProfilePopupView : UIView
{
    PPReplyPopupView *popupReply;
}
@property(nonatomic, weak) IBOutlet UILabel *username, *country, *email, *skype, *age, *gender;
@property(nonatomic, weak) IBOutlet UITextView *profile, *languages;
@property(nonatomic, weak) IBOutlet UIView *view;
@property(nonatomic, weak) IBOutlet UIImageView *image;
@property(nonatomic, weak) IBOutlet UIButton *messageButton;

-(void)show;
-(IBAction)sendMessage:(id)sender;
-(IBAction)hide:(id)sender;

@end
