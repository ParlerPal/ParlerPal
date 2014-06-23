//
//  PPUserManagement.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/16/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//
#import "PPUserManagement.h"

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
    
    PFUser *user = [PFUser user];

    user.username = username;
    user.password = password;
    user.email = email;
    
    // other fields can be set just like with PFObject
    //user[@"phone"] = @"415-392-0202";
    
    NSError *error;
    [user signUp:&error];
    
    if(!error)
    {
       errorString = @"Success!";
    }
    
    else
    {
        errorString = [error userInfo][@"error"];
    }
    
    return errorString;
}

#pragma mark -
#pragma mark update methods

+(BOOL)updateUserWithPrivateEmail:(NSString *)privateEmail country:(NSString *)country sharedEmail:(NSString *)sharedEmail skypeID:(NSString *)skypeID profile:(NSString *)profile age:(NSString*)age gender:(int)gender
{
    if(privateEmail.length <= 0)
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Problem" message:@"You need to enter a private email address." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    
    currentUser.email = privateEmail;
    currentUser[@"countryOfOrigin"] = country;
    currentUser[@"sharedEmail"] = sharedEmail;
    currentUser[@"skypeID"] = skypeID;
    currentUser[@"profile"] = profile;
    currentUser[@"age"] = age;
    currentUser[@"gender"] = [NSNumber numberWithInt:gender];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            //No Message
        }
        
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Problem" message:@"Your profile could not be updated." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    return YES;
}

+(BOOL)updatePasswordWithPassword:(NSString *)password confirm:(NSString *)confirm
{
    PFUser *currentUser = [PFUser currentUser];

    if(password.length > 0 && confirm.length > 0 && [password isEqualToString:confirm])
    {
        currentUser.password = password;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Success" message:@"Your password has been changed." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            }
            
            else
            {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Problem" message:@"Password could not be updated." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            }
        }];
        return YES;
    }
    
    else if(password.length <= 0 || confirm <= 0)
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Problem" message:@"Both fields for changing a password are required." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    else if(![password isEqualToString:confirm])
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Problem" message:@"Passwords do not match." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
    
    return NO;
}

@end
