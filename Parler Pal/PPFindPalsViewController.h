//
//  PPFindPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPProfilePopupView.h"
#import "PPPalTableViewCell.h"
#import "PPSearchFilterPopupView.h"

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate,PPSearchFilterPopupViewDelegate>
{
    NSMutableArray *foundPals;
    PPProfilePopupView *profilePopup;
    PPSearchFilterPopupView *searchFilterView;
}
@property(nonatomic, weak) IBOutlet UITableView *table;

-(IBAction)filter;

@end
