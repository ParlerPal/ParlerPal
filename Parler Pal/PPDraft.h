//
//  PPDraft.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/7/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDraft : NSObject
@property (nonatomic, strong) NSString *from, *to, *subject, *message, *memoID;
@property (nonatomic, readwrite) int dbID;
@property (nonatomic, strong) NSDate *created;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
