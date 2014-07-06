//
//  PPPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPalTableViewCell.h"
#import "PPProfilePopupView.h"

@interface PPPalsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PPPalTableViewCellDelegate>
{
    NSMutableArray *friendships;
    NSMutableArray *requests; 
    PPProfilePopupView *profilePopup;
}
@property(nonatomic, weak) IBOutlet UITableView *table;

-(IBAction)unwindPalsViewController:(UIStoryboardSegue *)unwindSegue;

@end

