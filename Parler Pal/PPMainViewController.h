//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int languageIndex;
    NSArray *allQuotes;
}

@property (strong, nonatomic) IBOutlet UINavigationItem *toolbarTitle;
@property (strong, nonatomic) IBOutlet UILabel *quotes;

@end
