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

@interface PPPalsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PPPalTableViewCellDelegate>
{
    IBOutlet UITableView *table;
    NSMutableArray *friendships;
    NSMutableArray *requests; 
    PPLanguagesPopupView *popup;
}
@property(nonatomic, strong) IBOutlet UITableView *table;
@end

