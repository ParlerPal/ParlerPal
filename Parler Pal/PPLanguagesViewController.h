//
//  PPLanguagesViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLanguageTableViewCell.h"

@interface PPLanguagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *languages;
    NSMutableArray *allUserLanguages;
}
@property(nonatomic, weak) IBOutlet UITableView *table;

@end
