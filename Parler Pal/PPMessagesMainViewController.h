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

typedef enum : NSUInteger {
    PPMessagesDisplayTypeUnread,
    PPMessagesDisplayTypeAll,
    PPMessagesDisplayTypeSent,
} PPMessagesDisplayType;

@interface PPMessagesMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIGestureRecognizerDelegate, PPMessagesPopupViewDelegate>
{
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
    PPMessagesDisplayType displayType;
}
@property(nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, weak) IBOutlet UITableView *table;
@property(nonatomic, weak) IBOutlet UINavigationItem *toolbarTitle;
@property(nonatomic, readwrite) PPMessagesDisplayType displayType;
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) NSMutableArray *filteredMessagesArray;

@end
