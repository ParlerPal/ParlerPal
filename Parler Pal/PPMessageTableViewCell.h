//
//  PPMessageTableViewCell.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMessageTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *fromLabel, *messageLabel, *dateLabel, *toLabel;
@property (readwrite) int messageID;

@end
