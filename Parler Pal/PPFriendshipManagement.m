//
//  PPFriendshipManagement.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/20/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPFriendshipManagement.h"

@implementation PPFriendshipManagement
@synthesize delegate;

#pragma mark -
#pragma mark request and confirm methods

+(BOOL)requestFriendshipWith:(NSString *)theUser trusted:(BOOL)trusted confirmed:(BOOL)confirmed
{
     PFObject *friendship = [PFObject objectWithClassName:@"Friendship"];
     friendship[@"userA"] = [[PFUser currentUser]username];
     friendship[@"userB"] = theUser;
     friendship[@"trusted"] = [NSNumber numberWithBool:trusted];
     friendship[@"confirmed"] = [NSNumber numberWithBool:confirmed];
     [friendship saveInBackground];
    
    return YES;
}

+(BOOL)confirmFriendshipWith:(NSString *)theUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friendship"];
    [query whereKey:@"userA" equalTo:theUser];
    [query whereKey:@"userB" equalTo:[[PFUser currentUser]username]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
         if (!error)
         {
             for (PFObject *object in objects) {
                    object[@"confirmed"] = @YES;
                    [object saveInBackground];
             }
         }
         
         else
         {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    return YES;
}

#pragma mark -
#pragma trust methods
+(BOOL)trustFriend:(NSString *)theUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friendship"];
    [query whereKey:@"userA" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"userB" equalTo:theUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in objects) {
                 object[@"trusted"] = @YES;
                 [object saveInBackground];
             }
         }
         
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    return YES;
}

+(BOOL)untrustFriend:(NSString *)theUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friendship"];
    [query whereKey:@"userA" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"userB" equalTo:theUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in objects) {
                 object[@"trusted"] = @YES;
                 [object saveInBackground];
             }
         }
         
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    return YES;
}

#pragma mark -
#pragma delete methods

+(BOOL)deleteFriendshipWith:(NSString*)theUser
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"Friendship"];
    [query1 whereKey:@"userA" equalTo:[[PFUser currentUser]username]];
    [query1 whereKey:@"userB" equalTo:theUser];
     
    PFQuery *query2 = [PFQuery queryWithClassName:@"Friendship"];
    [query2 whereKey:@"userB" equalTo:[[PFUser currentUser]username]];
    [query2 whereKey:@"userA" equalTo:theUser];
     
    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in objects) {
                [object deleteInBackground];
             }
         }
         
         else{NSLog(@"Error: %@ %@", error, [error userInfo]);}
     }];
    
    return YES;
}

#pragma mark -
#pragma mark get methods

-(void)getFriendships
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friendship"];
    [query whereKey:@"userA" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"confirmed" equalTo:@YES];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Friendship"];
    [query1 whereKey:@"userB" equalTo:[[PFUser currentUser]username]];
    [query1 whereKey:@"confirmed" equalTo:@YES];
    
    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query,query1]];
    
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([self.delegate respondsToSelector:@selector(didGetFriendships:)])[self.delegate didGetFriendships:objects];
    }];
}

-(void)getFriendshipRequests
{    
    PFQuery *query = [PFQuery queryWithClassName:@"Friendship"];
    [query whereKey:@"userB" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"confirmed" equalTo:@NO];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([self.delegate respondsToSelector:@selector(didGetFriendshipRequests:)])[self.delegate didGetFriendshipRequests:objects];
    }];
    
}

+(PFUser *)getUserForUserName:(NSString *)username
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    return (PFUser *)[query getFirstObject];
}

@end
