//
//  PPDraft.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/7/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPDraft.h"

@implementation PPDraft
@synthesize to, from, subject, message, memoID, created, dbID;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        self.dbID = [[dictionary objectForKey:@"id"]intValue];
        self.from = [dictionary objectForKey:@"from"];
        self.to = [dictionary objectForKey:@"to"];
        self.subject = [dictionary objectForKey:@"subject"];
        self.message = [dictionary objectForKey:@"message"];
        self.memoID = [[dictionary objectForKey:@"memoID"]intValue];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [df setTimeZone:gmt];
        NSDate *theDate = [df dateFromString:[dictionary objectForKey:@"created"]];
        
        self.created = theDate;
    }
    
    return self;
}

@end
