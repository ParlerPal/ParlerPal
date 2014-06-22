//
//  PPFindPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPalFinder.h"
#import "PPLanguagesPopupView.h"
#import "PPPalTableViewCell.h"

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate, PPPalFinderDelegate>
{
    IBOutlet UITableView *table;
    NSArray *foundPals;
    PPLanguagesPopupView *popup;
    PPPalFinder *pf;
}
@property(nonatomic, strong) IBOutlet UITableView *table;

@end
