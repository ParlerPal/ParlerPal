//
//  PPDatabaseManager.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/25/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DDXML.h"
#import <CoreLocation/CoreLocation.h>

#define WEB_SERVICES @"http://24.131.92.164/ppWebServices/"

@interface PPDatabaseManager : NSObject
{
    AFHTTPRequestOperationManager *manager;
}

+(PPDatabaseManager *)sharedDatabaseManager;

//Sign in and out methods
-(void)signUpWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email;
-(void)signinWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void(^)(bool success))handler;
-(void)logoutCompletionHandler:(void(^)(bool success))handler;

//User profile methods
-(void)getUserProfileCompletionHandler:(void(^)(NSMutableDictionary *results))handler;
-(void)updateUserProfileWithEmail:(NSString *)email country:(NSString *)country profile:(NSString *)profile skypeID:(NSString *)skypeID age:(NSString *)age gender:(int)gender completionHandler:(void(^)(bool success))handler;
-(void)updatePasswordWithPassword:(NSString *)password completionHandler:(void(^)(bool success))handler;
-(void)deleteProfileCompletionHandler:(void(^)(bool success))handler;
-(void)getSharedUserProfileForUsername:(NSString *)username WithFinish:(void(^)(NSMutableDictionary *results))handler;

//Language methods
-(void)updateLanguageWithName:(NSString *)name languageStatus:(int)status languageLevel:(int)level completionHandler:(void(^)(bool success))handler;
-(void)getAllLanguagesCompletionHandler:(void(^)(NSMutableArray *results))handler;

//Friendship methods
-(void)getAllPalsCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getAllPalRequestsCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getBatchOfPalsCompletionHandler:(void(^)(NSMutableArray *results))handler;

-(void)requestFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;
-(void)confirmFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;
-(void)deleteFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;

//Messaging methods
-(void)submitMessageTo:(NSString *)theUser subject:(NSString *)subject andMessage:(NSString *)message location:(CLLocation *)location sendMemo:(bool)sendMemo completionHandler:(void(^)(bool success))handler;
-(void)getAllReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getUnreadReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getAllSentMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getMessageContentForID:(int)messageID completionHandler:(void(^)(NSMutableDictionary *results))handler;
-(void)markMessageAsRead:(int)messageID completionHandler:(void(^)(bool success))handler;
-(void)deleteMessage:(int)messageID completionHandler:(void(^)(bool success))handler;
@end
