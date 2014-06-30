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

@required
-(void)shouldShowDetails:(NSString *)user;

@optional
-(void)shouldAcceptRequest:(id)sender;
-(void)shouldDenyRequest:(id)sender;
-(void)shouldDeleteFriend:(id)sender;
-(void)shouldRequestFriend:(id)sender;

@end

typedef enum : NSUInteger {
    kPalType,
    kRequestType,
    kFoundType,
} PalTableViewCellType;

@interface PPPalTableViewCell : UITableViewCell
{
    PalTableViewCellType type;
}
@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) id delegate;
@property (nonatomic, readwrite) PalTableViewCellType type;
@property (nonatomic, weak) IBOutlet UIButton *addRemoveButton, *rejectButton;

//Action methods
-(IBAction)didSelectDetailsButton:(id)sender;
-(IBAction)didSelectAddRemoveButton:(id)sender;
-(IBAction)rejectRequestButton:(id)sender;

@end
