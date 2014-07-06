//
//  PPUser.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPUser.h"

@implementation PPUser
@synthesize sharedEmail, username, country, profile, skypeID, age, gender, email, created, dbID;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        self.dbID = [[dictionary objectForKey:@"id"]intValue];
        self.sharedEmail = [dictionary objectForKey:@"sharedEmail"];
        self.username = [dictionary objectForKey:@"username"];
        self.country = [dictionary objectForKey:@"country"];
        self.profile = [dictionary objectForKey:@"profile"];
        self.skypeID = [dictionary objectForKey:@"skypeID"];
        self.age = [[dictionary objectForKey:@"age"]intValue];
        self.gender = [[dictionary objectForKey:@"gender"]intValue];
        self.email = [dictionary objectForKey:@"email"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        NSDate *theDate = [df dateFromString:[dictionary objectForKey:@"created"]];
        self.created = theDate;
    }
    
    return self;
}

@end
