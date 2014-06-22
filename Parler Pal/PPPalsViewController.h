//
//  PPPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPalTableViewCell.h"
#import "PPLanguagesPopupView.h"
#import "PPFriendshipManagement.h"

@interface PPPalsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PPPalTableViewCellDelegate, PPFriendshipManagementDelegate>
{
    IBOutlet UITableView *table;
    NSArray *friendships;
    NSArray *requests;
    PPLanguagesPopupView *popup;
    PPFriendshipManagement *fm;
}
@property(nonatomic, strong) IBOutlet UITableView *table;

@end

