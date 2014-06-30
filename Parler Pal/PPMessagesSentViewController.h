//
//  PPMessagesSentViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/28/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPMessagePopupView.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"
#import "PPMessageTableViewCell.h"

@interface PPMessagesSentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, PPMessagesPopupViewDelegate, PPMessagesTableViewCellDelegate>
{
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}
@property(nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, weak) IBOutlet UITableView *table;

@end