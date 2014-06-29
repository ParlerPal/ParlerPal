//
//  PPDatabaseManager.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/25/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DDXML.h"

@interface PPDatabaseManager : NSObject
{
    AFHTTPRequestOperationManager *manager;
}

+(PPDatabaseManager *)sharedDatabaseManager;

-(void)signUpWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email;
-(void)signinWithUsername:(NSString *)username password:(NSString *)password finish:(void(^)(bool success))handler;

-(void)getUserProfileWithFinish:(void(^)(NSMutableDictionary *results))handler;
-(void)updateUserProfileWithEmail:(NSString *)email country:(NSString *)country profile:(NSString *)profile skypeID:(NSString *)skypeID age:(NSString *)age gender:(int)gender finish:(void(^)(bool success))handler;
-(void)updatePasswordWithPassword:(NSString *)password finish:(void(^)(bool success))handler;
-(void)deleteProfileWithFinish:(void(^)(bool success))handler;

-(void)updateLanguageWithName:(NSString *)name languageStatus:(int)status languageLevel:(int)level finish:(void(^)(bool success))handler;
-(void)getAllLanguages:(void(^)(NSMutableArray *results))handler;

-(void)getAllPals:(void(^)(NSMutableArray *results))handler;
-(void)getAllPalRequests:(void(^)(NSMutableArray *results))handler;
-(void)getBatchOfPals:(void(^)(NSMutableArray *results))handler;

-(void)requestFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler;
-(void)confirmFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler;
-(void)deleteFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler;

-(void)submitMessageTo:(NSString *)theUser subject:(NSString *)subject andMessage:(NSString *)message finish:(void(^)(bool success))handler;
-(void)getAllReceivedMessages:(void(^)(NSMutableArray *results))handler;
-(void)getUnreadReceivedMessages:(void(^)(NSMutableArray *results))handler;
-(void)getAllSentMessages:(void(^)(NSMutableArray *results))handler;
-(void)getMessageContentForID:(int)messageID andFinish:(void(^)(NSMutableDictionary *results))handler;
-(void)markMessageAsRead:(int)messageID finish:(void(^)(bool success))handler;
@end
