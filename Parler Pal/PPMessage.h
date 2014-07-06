//
//  PPMessage.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPMessage : NSObject
@property (nonatomic, strong) NSString *from, *to, *subject, *message;
@property (nonatomic, readwrite) BOOL opened, senderDeleted, receiverDeleted, memoAttached;
@property (nonatomic, readwrite) double lat, lon;
@property (nonatomic, readwrite) int dbID;
@property (nonatomic, strong) NSDate *created;
@end
