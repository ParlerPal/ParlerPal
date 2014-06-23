//
//  PPLanguageTableViewCell.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol PPLanguageTableViewCellDelegate <NSObject>

@optional
-(void)didAlterLanguageSettingsForCell:(id)theCell;

@end

@interface PPLanguageTableViewCell : UITableViewCell
{
    IBOutlet UILabel *language;
    IBOutlet UISegmentedControl *status;
    IBOutlet UISegmentedControl *level;
    id <PPLanguageTableViewCellDelegate> delegate;
}
@property(nonatomic, strong)UILabel *language;
@property(nonatomic, strong)UISegmentedControl *status, *level;
@property(nonatomic, strong)id delegate;

//Action Methods
-(IBAction)statusChange:(id)sender;
-(IBAction)levelChange:(id)sender;

//Save user information for the languages
-(void)saveUserLanguageInformation;

@end
