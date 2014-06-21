//
//  PPMessageTableViewCell.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMessageTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *fromLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *dateLabel;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *fromLabel, *messageLabel, *dateLabel;

@end
