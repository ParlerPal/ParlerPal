//
//  PPDatabaseManager.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/25/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import "PPDatabaseManager.h"

#define WEB_SERVICES @"http://192.168.1.10/ppWebServices/"

@implementation PPDatabaseManager

#pragma mark -
#pragma mark instance methods

+ (PPDatabaseManager *)sharedDatabaseManager
{
    static PPDatabaseManager *sharedDatabaseManager;
    
    @synchronized(self)
    {
        if (!sharedDatabaseManager)
            sharedDatabaseManager = [[PPDatabaseManager alloc] init];
        
        return sharedDatabaseManager;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Signin and Registration Methods

-(void)signUpWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email
{
    NSDictionary *parameters = @{@"username": username, @"pwd": password, @"email": email};
    
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/register.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        
        NSArray *results = [xmlDoc nodesForXPath:@"//success" error:nil];
        
            for (DDXMLElement *item in results) {
                if([[item stringValue]boolValue] == false)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username taken" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                    [alert show];
                }
            }
        
        }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)signinWithUsername:(NSString *)username password:(NSString *)password finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"username": username, @"password": password};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/validateUser.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//validated" error:nil];
        
        for (DDXMLElement *item in results) {
            if([[item stringValue]boolValue] == NO)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid sign in!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
                 handler(NO);
            }
            else{
                 handler(YES);
            }
        }
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)logoutWithFinish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/logout.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

#pragma mark -
#pragma mark User Profile Methods

-(void)getUserProfileWithFinish:(void(^)(NSMutableDictionary *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/getUserProfile.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//user" error:nil];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];

        for (DDXMLElement *node in results)
        {
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
        }
        
        handler(item);
        
        }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)updateUserProfileWithEmail:(NSString *)email country:(NSString *)country profile:(NSString *)profile skypeID:(NSString *)skypeID age:(NSString *)age gender:(int)gender finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"country": country, @"profile": profile, @"sharedEmail": email, @"skypeID": skypeID, @"age": age, @"gender":[NSNumber numberWithInt:gender]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/updateUserProfile.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)updatePasswordWithPassword:(NSString *)password finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"password": password};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/updatePassword.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)deleteProfileWithFinish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/deleteUser.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)getSharedUserProfileForUsername:(NSString *)username WithFinish:(void(^)(NSMutableDictionary *results))handler
{
    NSDictionary *parameters = @{@"username": username};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/getSharedUserProfile.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        
        NSArray *sharedUser = [xmlDoc nodesForXPath:@"//sharedUser" error:nil];
        NSMutableDictionary *userProfileData = [[NSMutableDictionary alloc] init];
        for (DDXMLElement *node in sharedUser)
        {
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [userProfileData setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
        }
        
        NSArray *resultsLanguages = [xmlDoc nodesForXPath:@"//language" error:nil];
        NSMutableArray *allLanguages = [[NSMutableArray alloc]init];
        for (DDXMLElement *node in resultsLanguages)
        {
            NSMutableDictionary *language = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [language setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            [allLanguages addObject:language];
        }
        
        [userProfileData setObject:allLanguages forKey:@"languages"];
        handler(userProfileData);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark -
#pragma mark Language Methods

-(void)updateLanguageWithName:(NSString *)name languageStatus:(int)status languageLevel:(int)level finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"languageName": name, @"languageStatus": [NSNumber numberWithInt:status], @"languageLevel": [NSNumber numberWithInt:level]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"languages/updateLanguage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)getAllLanguages:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"languages/getAllLanguages.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//language" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];

            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark -
#pragma mark Friendship Methods

-(void)getAllPals:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/getAllPals.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//user" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllPalRequests:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/getAllPalRequests.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//user" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)confirmFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToConfirm": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/confirmFriendRequest.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)deleteFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToDelete": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/deleteFriend.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)getBatchOfPals:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/findBatchOfPals.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//user" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)requestFriendshipWith:(NSString *)theUser finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToRequest": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/requestFriendship.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

#pragma mark -
#pragma mark messaging methods

-(void)submitMessageTo:(NSString *)theUser subject:(NSString *)subject andMessage:(NSString *)message location:(CLLocation *)location finish:(void(^)(bool success))handler
{

    NSDictionary *parameters = @{@"to": theUser, @"subject": subject, @"message": message, @"lat":[NSNumber numberWithDouble:location.coordinate.latitude], @"lon":[NSNumber numberWithDouble:location.coordinate.longitude]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/submitMessage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)getUnreadReceivedMessages:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/getUnreadReceivedMessages.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//message" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllReceivedMessages:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/getAllReceivedMessages.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//message" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllSentMessages:(void(^)(NSMutableArray *results))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/getSentMessages.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//message" error:nil];
        
        NSMutableArray *allResults = [[NSMutableArray alloc]init];
        
        for (DDXMLElement *node in results)
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
            
            [allResults addObject:item];
        }
        
        handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getMessageContentForID:(int)messageID andFinish:(void(^)(NSMutableDictionary *results))handler
{
    NSDictionary *parameters = @{@"id":[NSNumber numberWithInt:messageID]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/getContentForMessage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//messageContent" error:nil];
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        
        for (DDXMLElement *node in results)
        {
            for(int counter = 0; counter < [node childCount]; counter++)
            {
                if ([[node childAtIndex:counter] stringValue] != nil)
                {
                    NSString * strKeyValue = [[[node childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if ([strKeyValue length] != 0)
                    {
                        [item setObject:strKeyValue forKey:[[node childAtIndex:counter] name]];
                    }
                }
            }
        }
        
        handler(item);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)markMessageAsRead:(int)messageID finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"id": [NSNumber numberWithInt:messageID]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/setMessageAsOpened.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

-(void)deleteMessage:(int)messageID finish:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"id": [NSNumber numberWithInt:messageID]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/deleteMessage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              handler(NO);
          }];
}

@end
