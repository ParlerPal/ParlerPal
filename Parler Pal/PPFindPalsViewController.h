//
//  PPFindPalsViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLanguagesPopupView.h"
#import "PPPalTableViewCell.h"

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate>
{
    IBOutlet UITableView *table;
    NSMutableArray *foundPals;
    PPLanguagesPopupView *popup;
}
@property(nonatomic, strong) IBOutlet UITableView *table;

@end
