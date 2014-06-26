//
//  PPUserManagement.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/16/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUserManagement : NSObject
{

}

//Signup a user with all the required information
+(NSString *)signUpWithUsername:(NSString *)username password:(NSString *)password confirm:(NSString *)confirm andEmail:(NSString *)email;

@end
