//
//  PPMessageContentViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMessageContentViewController : UIViewController
{
    IBOutlet UITextView *messageContent;
}
@property(nonatomic, strong)IBOutlet UITextView *messageContent;
@end

