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

@class PPPal;
@class PPUser;
@class PPDraft;

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
-(void)getUserProfileCompletionHandler:(void(^)(PPUser *results))handler;
-(void)updateUserProfileWithEmail:(NSString *)email country:(NSString *)country profile:(NSString *)profile skypeID:(NSString *)skypeID age:(NSString *)age gender:(int)gender completionHandler:(void(^)(bool success))handler;
-(void)updatePasswordWithPassword:(NSString *)password completionHandler:(void(^)(bool success))handler;
-(void)deleteProfileCompletionHandler:(void(^)(bool success))handler;
-(void)getSharedUserProfileForUsername:(NSString *)username WithFinish:(void(^)(PPPal *results))handler;
-(void)uploadProfileImage:(UIImage *)image completionHandler:(void(^)(bool success))handler;
-(void)deleteProfilePhotoCompletionHandler:(void(^)(bool success))handler;

//Language methods
-(void)updateLanguageWithName:(NSString *)name languageStatus:(int)status languageLevel:(int)level completionHandler:(void(^)(bool success))handler;
-(void)getAllLanguagesCompletionHandler:(void(^)(NSMutableArray *results))handler;

//Friendship methods
-(void)getAllPalsCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getAllPalRequestsCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getBatchOfPalsWithUsername:(NSString *)username gender:(int)gender minAge:(int)minAage maxAge:(int)maxAge completionHandler:(void(^)(NSMutableArray *results))handler;

-(void)requestFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;
-(void)confirmFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;
-(void)deleteFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler;

//Messaging methods
-(void)submitMessageTo:(NSString *)theUser subject:(NSString *)subject andMessage:(NSString *)message location:(CLLocation *)location sendMemo:(bool)sendMemo completionHandler:(void(^)(bool success))handler;
-(void)getAllReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getUnreadReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getAllSentMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)getMessageContentForID:(int)messageID completionHandler:(void(^)(NSMutableDictionary *results))handler __attribute__ ((deprecated));
-(void)markMessageAsRead:(int)messageID completionHandler:(void(^)(bool success))handler;
-(void)deleteMessage:(int)messageID completionHandler:(void(^)(bool success))handler;

//Draft Methods
-(void)submitDraftWithTo:(NSString *)theUser subject:(NSString *)subject message:(NSString *)message andMemoID:(int)memoID draftID:(int)currDraftID completionHandler:(void(^)(bool success, int draftID))handler;
-(void)getDraftByID:(int)draftID completionHandler:(void(^)(PPDraft *results))handler;
-(void)getAllDraftsCompletionHandler:(void(^)(NSMutableArray *results))handler;
-(void)deleteDraftByID:(int)draftID completionHandler:(void(^)(bool success))handler;
@end
