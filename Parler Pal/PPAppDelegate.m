//
//  PPAppDelegate.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPAppDelegate.h"

@implementation PPAppDelegate

-(id)init
{
	if ((self = [super init]))
	{
	}
	return self;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    if(![fm fileExistsAtPath:[docsDir stringByAppendingPathComponent:@"audioMessages"]])
    {
        [fm createDirectoryAtPath:[docsDir stringByAppendingPathComponent:@"audioMessages"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}
							
-(void)applicationWillResignActive:(UIApplication *)application
{

}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{

}

-(void)applicationDidBecomeActive:(UIApplication *)application
{

}

-(void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end