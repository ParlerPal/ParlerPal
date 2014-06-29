//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"

@interface PPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    int languageIndex;
    NSArray *allQuotes;
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}

@property (strong, nonatomic) IBOutlet UINavigationItem *toolbarTitle;
@property (strong, nonatomic) IBOutlet UILabel *quotes;
@property (nonatomic, strong) IBOutlet UITableView *table;

@end
