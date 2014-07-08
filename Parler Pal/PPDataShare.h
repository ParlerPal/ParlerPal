//
//  PPDataShare.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPalsViewController;
@class PPDraft;

@interface PPDataShare : NSObject
{
    NSString *currentUser;
    NSMutableDictionary *sharedMessage;
    NSString *sharedUser;
}
@property(nonatomic, strong) NSString *currentUser, *sharedUser;
@property(nonatomic, strong) NSMutableDictionary *sharedMessage;
@property(nonatomic, strong) PPDraft *draft;

+(PPDataShare *)sharedSingleton;

@end
