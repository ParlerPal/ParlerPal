//
//  PPDataShare.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDataShare : NSObject
{
    NSArray *sharedFriendshipRequests;
    NSArray *sharedFriendships;
}
@property (nonatomic, strong)NSArray *sharedFriendshipRequests, *sharedFriendships;

+(PPDataShare *)sharedSingleton;

@end
