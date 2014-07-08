//
//  PPMessagesWorkInProgressViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMessagesWorkInProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *drafts;
}
@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButton;
@property(nonatomic, weak) IBOutlet UITableView *table;

@end
