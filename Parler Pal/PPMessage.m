//
//  PPMessage.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessage.h"

@implementation PPMessage
@synthesize dbID, from, to, subject, message, opened, created, senderDeleted, receiverDeleted, lat, lon, memoAttached;

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
        self.opened = [dictionary objectForKey:@"opened"];
        self.senderDeleted = [[dictionary objectForKey:@"senderDeleted"]boolValue];
        self.receiverDeleted = [[dictionary objectForKey:@"receiverDeleted"]boolValue];
        self.lat = [[dictionary objectForKey:@"lat"]doubleValue];
        self.lon = [[dictionary objectForKey:@"lon"]doubleValue];
        self.memoAttached = [[dictionary objectForKey:@"memoAttached"]boolValue];

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
