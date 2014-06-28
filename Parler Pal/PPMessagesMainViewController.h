//
//  PPMessagesMainViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/19/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"

@interface PPMessagesMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIBarButtonItem *sidebarButton;
    IBOutlet UITableView *table;
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}
@property(nonatomic, strong) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, strong) IBOutlet UITableView *table;

@end
