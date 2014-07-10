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

@interface PPFindPalsViewController : UIViewController <PPPalTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate, PPSearchFilterPopupViewDelegate>
{
    NSMutableArray *foundPals;
    PPProfilePopupView *profilePopup;
    PPSearchFilterPopupView *searchFilterView;
}
@property(nonatomic, weak) IBOutlet UITableView *table;
@property(nonatomic, strong) NSMutableArray *filteredPalsArray;
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;

-(IBAction)filter;

@end
