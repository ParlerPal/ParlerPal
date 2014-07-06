//
//  PPDatabaseManager.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/25/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPDatabaseManager.h"

#import "PPUser.h"
#import "PPMessage.h"
#import "PPLanguage.h"
#import "PPPal.h"

@implementation PPDatabaseManager

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

#pragma mark - Signin and Registration Methods

-(void)signUpWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email
{
    NSDictionary *parameters = @{@"username": username, @"pwd": password, @"email": email};
    
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/register.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        
        NSArray *results = [xmlDoc nodesForXPath:@"//success" error:nil];
        
            for (DDXMLElement *item in results) {
                if([[item stringValue]boolValue] == NO)
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

-(void)signinWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void(^)(bool success))handler
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
                 if(handler)handler(NO);
            }
            else{
                 if(handler)handler(YES);
            }
        }
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)logoutCompletionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/logout.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

#pragma mark - User Profile Methods

-(void)getUserProfileCompletionHandler:(void(^)(PPUser *results))handler
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
        
        PPUser *user = [[PPUser alloc]initWithDictionary:item];
        if(handler)handler(user);
        
        }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)updateUserProfileWithEmail:(NSString *)email country:(NSString *)country profile:(NSString *)profile skypeID:(NSString *)skypeID age:(NSString *)age gender:(int)gender completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"country": country, @"profile": profile, @"sharedEmail": email, @"skypeID": skypeID, @"age": age, @"gender":[NSNumber numberWithInt:gender]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/updateUserProfile.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)updatePasswordWithPassword:(NSString *)password completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"password": password};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/updatePassword.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)deleteProfileCompletionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"users/deleteUser.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)getSharedUserProfileForUsername:(NSString *)username WithFinish:(void(^)(PPPal *results))handler
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
            
            PPLanguage *newLanguage = [[PPLanguage alloc]initWithDictionary:language];
            [allLanguages addObject:newLanguage];
        }
        
        [userProfileData setObject:allLanguages forKey:@"languages"];
        
        PPPal *pal = [[PPPal alloc]initWithDictionary:userProfileData];
        
        if(handler)handler(pal);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - Language Methods

-(void)updateLanguageWithName:(NSString *)name languageStatus:(int)status languageLevel:(int)level completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"languageName": name, @"languageStatus": [NSNumber numberWithInt:status], @"languageLevel": [NSNumber numberWithInt:level]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"languages/updateLanguage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)getAllLanguagesCompletionHandler:(void(^)(NSMutableArray *results))handler
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
            
            PPLanguage *language = [[PPLanguage alloc]initWithDictionary:item];
            [allResults addObject:language];
        }
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - Friendship Methods

-(void)getAllPalsCompletionHandler:(void(^)(NSMutableArray *results))handler
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
            
            PPPal *pal = [[PPPal alloc]initWithDictionary:item];
            [allResults addObject:pal];
        }
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllPalRequestsCompletionHandler:(void(^)(NSMutableArray *results))handler
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
            
            PPPal *pal = [[PPPal alloc]initWithDictionary:item];
            [allResults addObject:pal];
        }
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)confirmFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToConfirm": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/confirmFriendRequest.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)deleteFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToDelete": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/deleteFriend.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)getBatchOfPalsCompletionHandler:(void(^)(NSMutableArray *results))handler
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
            
            PPPal *pal = [[PPPal alloc]initWithDictionary:item];
            [allResults addObject:pal];
        }
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)requestFriendshipWith:(NSString *)theUser completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"userToRequest": theUser};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"friendships/requestFriendship.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

#pragma mark - messaging methods

-(void)submitMessageTo:(NSString *)theUser subject:(NSString *)subject andMessage:(NSString *)message location:(CLLocation *)location sendMemo:(bool)sendMemo completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"to": theUser, @"subject": subject, @"message": message, @"lat":[NSNumber numberWithDouble:location.coordinate.latitude], @"lon":[NSNumber numberWithDouble:location.coordinate.longitude], @"memoAttached": [NSNumber numberWithBool:sendMemo]};
    
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/submitMessage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *results = [xmlDoc nodesForXPath:@"//message" error:nil];
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

        if(sendMemo){[self uploadMemoForMessageID:[item objectForKey:@"messageID"]];}
        
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

-(void)uploadMemoForMessageID:(NSString *)messageID
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    NSURL *soundFileURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"memo.m4a"]];
    NSData *audioData = [NSData dataWithContentsOfURL:soundFileURL];
    
    NSDictionary *parameters = @{@"messageID": messageID};
    AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"files/uploadAudio.php"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:audioData name:@"memo" fileName:[NSString stringWithFormat:@"memo%@.m4a",messageID] mimeType:@"audio/x-m4a"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}

-(void)getUnreadReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler
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
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllReceivedMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler
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
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getAllSentMessagesCompletionHandler:(void(^)(NSMutableArray *results))handler
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
        
        if(handler)handler(allResults);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)getMessageContentForID:(int)messageID completionHandler:(void(^)(NSMutableDictionary *results))handler
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
        
        if(handler)handler(item);
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)markMessageAsRead:(int)messageID completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"id": [NSNumber numberWithInt:messageID]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/setMessageAsOpened.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)if(handler)handler(NO);
          }];
}

-(void)deleteMessage:(int)messageID  completionHandler:(void(^)(bool success))handler
{
    NSDictionary *parameters = @{@"id": [NSNumber numberWithInt:messageID]};
    [manager POST:[NSString stringWithFormat:@"%@%@", WEB_SERVICES, @"messages/deleteMessage.php"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(handler)if(handler)handler(YES);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if(handler)handler(NO);
          }];
}

@end
