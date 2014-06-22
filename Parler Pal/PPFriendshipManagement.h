//
//  PPFriendshipManagement.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol PPFriendshipManagementDelegate <NSObject>

@optional
-(void)didGetFriendships:(NSArray *)theFriendships;
-(void)didGetFriendshipRequests:(NSArray *)theRequests;

@end

@interface PPFriendshipManagement : NSObject
{
    id <PPFriendshipManagementDelegate>delegate;
}
@property (nonatomic, strong) id delegate;

//Request a friendship with a given person, the trusted and confirmed variables may be obsolete
+(BOOL)requestFriendshipWith:(NSString *)theUser trusted:(BOOL)trusted confirmed:(BOOL)confirmed;

//Confirm a friendship with a given username
+(BOOL)confirmFriendshipWith:(NSString *)theUser;

//Trust a given username, this may be obsolete
+(BOOL)trustFriend:(NSString *)theUser;

//Untrust a given username, this may be obsolete
+(BOOL)untrustFriend:(NSString *)theUser;

//Remove a friendship with a given username
+(BOOL)deleteFriendshipWith:(NSString*)theUser;

//Get all friendships for the current user
-(void)getFriendships;

//Get all friendship requests for the current user
-(void)getFriendshipRequests;

//Get the PFUser object for a given username
+(PFUser *)getUserForUserName:(NSString *)username;

@end
