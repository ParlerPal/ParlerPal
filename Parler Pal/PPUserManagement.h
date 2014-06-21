//
//  PPUserManagement.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/16/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PPUserManagement : NSObject
{

}

//Signup a user with all the required information
+(NSString *)signUpWithUsername:(NSString *)username password:(NSString *)password confirm:(NSString *)confirm andEmail:(NSString *)email;

//Update the passfor of the PFUser current user
+(BOOL)updatePasswordWithPassword:(NSString *)password confirm:(NSString *)confirm;

//Update some required and option information of the PFUser current user
+(BOOL)updateUserWithPrivateEmail:(NSString *)privateEmail country:(NSString *)country sharedEmail:(NSString *)sharedEmail skypeID:(NSString *)skypeID profile:(NSString *)profile;

@end
