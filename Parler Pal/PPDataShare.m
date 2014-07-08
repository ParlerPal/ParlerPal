//
//  PPDataShare.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPDataShare.h"

@implementation PPDataShare
@synthesize currentUser, sharedMessage, sharedUser, draft;

+ (PPDataShare *)sharedSingleton
{
    static PPDataShare *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[PPDataShare alloc] init];
        
        return sharedSingleton;
    }
}

@end
