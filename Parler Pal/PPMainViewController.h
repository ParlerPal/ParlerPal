//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"
#import "PPMessageTableViewCell.h"

@interface PPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PPMessagesPopupViewDelegate, PPMessagesTableViewCellDelegate>
{
    int languageIndex;
    NSArray *allQuotes;
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *toolbarTitle;
@property (weak, nonatomic) IBOutlet UILabel *quotes;
@property (nonatomic, weak) IBOutlet UITableView *table;

- (IBAction)unwindMainMenuViewController:(UIStoryboardSegue *)unwindSegue;

@end
