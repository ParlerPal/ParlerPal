//
//  PPAppDelegate.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPUserManagement.h"

@implementation PPAppDelegate

- (id)init
{
	if ((self = [super init]))
	{
		
	}
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"oNpx1fvw2xIFgAlwRez4xLcyHpiIiDDZiW3BLgFp"
                  clientKey:@"EfLOgZuil4i7A55DfAwvtHLGAwuejVjFH2jb4bu3"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
