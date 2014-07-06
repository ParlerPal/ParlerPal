//
//  PPLanguages.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguage.h"

@implementation PPLanguage
@synthesize dbID, name, languageLevel, languageStatus, created, user;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        self.dbID = [[dictionary objectForKey:@""]intValue];
        self.name = [dictionary objectForKey:@"name"];
        self.languageStatus = [[dictionary objectForKey:@"languageStatus"]intValue];
        self.languageLevel = [[dictionary objectForKey:@"languageLevel"]intValue];
        self.user = [dictionary objectForKey:@"user"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        NSDate *theDate = [df dateFromString:[dictionary objectForKey:@"created"]];
        self.created = theDate;
    }
    
    return self;
}

@end
