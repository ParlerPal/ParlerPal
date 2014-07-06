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

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *foundPals;
    PPProfilePopupView *profilePopup;
}
@property(nonatomic, weak) IBOutlet UITableView *table;
@property(nonatomic, strong) NSMutableArray *filteredPalsArray;
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end
