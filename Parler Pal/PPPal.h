//
//  PPPal.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PPPalGenderMale,
    PPPalGenderFemale,
    PPPalGenderX,
} PPPalGender;

@interface PPPal : NSObject
@property (nonatomic, strong) NSString *username, *country, *profile, *recommendationScore;
@property (nonatomic, readwrite) int dbID, age;
@property (nonatomic, readwrite) PPPalGender gender;
@property (nonatomic, strong) NSMutableArray *languages;
@property (nonatomic, strong) NSDate *created;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
