//
//  PPLanguageTableViewCell.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLanguageTableViewCell : UITableViewCell
@property(nonatomic, weak)UILabel *language;
@property(nonatomic, weak)UISegmentedControl *status, *level;

//Action Methods
-(IBAction)statusChange:(id)sender;
-(IBAction)levelChange:(id)sender;

//Save user information for the languages
-(void)saveUserLanguageInformation;

@end
