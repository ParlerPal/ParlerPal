//
//  PPPalTableViewCell.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate for handling when user choses to add/remove the pal or wishes to see details
@protocol PPPalTableViewCellDelegate <NSObject>

@optional
-(void)shouldAcceptRequest:(id)sender;
-(void)shouldDenyRequest:(id)sender;
-(void)shouldDeleteFriend:(id)sender;
-(void)shouldRequestFriend:(id)sender;

@end

//Tells us what kind of pal cell this is, since this will alter the UI
//Requests show a delete and add button
//Found shows a add button
//Pal shows a delete button
typedef enum : NSUInteger {
    kPalType,
    kRequestType,
    kFoundType,
} PalTableViewCellType;

@interface PPPalTableViewCell : UITableViewCell
{
    PalTableViewCellType type;
}
@property (nonatomic, weak) IBOutlet UILabel *username, *country;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) id delegate;
@property (nonatomic, readwrite) PalTableViewCellType type;
@property (nonatomic, weak) IBOutlet UIButton *addRemoveButton, *rejectButton;

-(IBAction)didSelectAddRemoveButton:(id)sender;
-(IBAction)rejectRequestButton:(id)sender;

@end
