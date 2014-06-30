//
//  PPMessagesMainViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"
#import "PPMessageTableViewCell.h"

@interface PPMessagesMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, PPMessagesPopupViewDelegate, PPMessagesTableViewCellDelegate>
{
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}
@property(nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, weak) IBOutlet UITableView *table;

@end
