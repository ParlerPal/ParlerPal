//
//  PPFindPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLanguagesPopupView.h"
#import "PPProfilePopupView.h"
#import "PPPalTableViewCell.h"

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate>
{
    NSMutableArray *foundPals;
    PPProfilePopupView *profilePopup;
}
@property(nonatomic, weak) IBOutlet UITableView *table;

@end
