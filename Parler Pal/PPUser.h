//
//  PPUser.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUser : NSObject
@property (nonatomic, strong) NSString *username, *email, *sharedEmail, *country, *profile, *skypeID;
@property (nonatomic, readwrite) int dbID, age, gender;
@property (nonatomic, strong) NSDate *created;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
