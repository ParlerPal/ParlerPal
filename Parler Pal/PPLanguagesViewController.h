//
//  PPLanguagesViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLanguagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    NSArray *languages;
}
@property(nonatomic, strong) IBOutlet UITableView *table;

@end
