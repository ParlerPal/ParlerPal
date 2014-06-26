//
//  PPUserManagement.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/16/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//
#import "PPUserManagement.h"
#import "PPDatabaseManager.h"

@implementation PPUserManagement

#pragma mark -
#pragma mark sign up methods

+(NSString *)signUpWithUsername:(NSString *)username password:(NSString *)password confirm:(NSString *)confirm andEmail:(NSString *)email
{
    NSString *errorString = @"";
    
    if(username == NULL || username.length <= 0)
    {
        return @"Missing username!";
    }
    
    else if(password == NULL || confirm == NULL || password.length <= 0 || confirm.length <= 0 || ![password isEqualToString:confirm])
    {
        return @"Missing or mismatched passwords!";
    }
    
    else if(email == NULL || email.length <= 0)
    {
        return @"Missing email address!";
    }
    
    [[PPDatabaseManager sharedDatabaseManager]signUpWithUsername:username password:password andEmail:email];
    
    return errorString;
}

@end
