//
//  PPDataShare.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/22/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPalsViewController;

@interface PPDataShare : NSObject
{
    NSString *currentUser;
}
@property(nonatomic, strong) NSString *currentUser;

+(PPDataShare *)sharedSingleton;

@end
