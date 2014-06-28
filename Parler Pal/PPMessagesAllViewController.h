//
//  PPMessagesAllViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/27/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"

@interface PPMessagesAllViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIBarButtonItem *sidebarButton;
    IBOutlet UITableView *table;
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}
@property(nonatomic, strong) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, strong) IBOutlet UITableView *table;

@end
