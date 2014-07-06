//
//  PPLanguage.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PPLanguageStatusKnown,
    PPLanguageStatusLearning,
    PPLanguageStatusNeither,
} PPLanguageStatus;

typedef enum : NSUInteger {
    PPLanguageLevelBeginner,
    PPLanguageLevelIntermediate,
    PPLanguageLevelFluent,
} PPLanguageLevel;

@interface PPLanguage : NSObject
@property (nonatomic, readwrite) int dbID;
@property (nonatomic, strong) NSString *name,*user;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, readwrite) PPLanguageStatus languageStatus;
@property (nonatomic, readwrite) PPLanguageLevel languageLevel;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
