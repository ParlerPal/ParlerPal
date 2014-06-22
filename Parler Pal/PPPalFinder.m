//
//  PPPalFinder.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/21/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPalFinder.h"
#import <Parse/Parse.h>

#define kBlockSize 5

@implementation PPPalFinder
@synthesize delegate;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        lastReturnCount = 0;
    }
    
    return self;
}

//returning languages but needs to return users
-(void)searchForABatchOfPossiblePals
{
    PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"languageStatus" equalTo:@1];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(finishSearchBasedOnUserLanguages:)];
    
}

-(void)finishSearchBasedOnUserLanguages:(NSArray *)allUserLanguesLearning
{
    if(allUserLanguesLearning.count == 0)return;
    
    NSMutableArray *allQueries = [NSMutableArray array];
    
    for(PFObject *object in allUserLanguesLearning)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Languages"];
        [query whereKey:@"name" equalTo:object[@"name"]];
        [query whereKey:@"languageStatus" equalTo:@0];
        [query whereKey:@"user" notEqualTo:[PFUser currentUser]];
        
        [allQueries addObject:query];
    }
    
    PFQuery *combinedOrQuery = [PFQuery orQueryWithSubqueries:allQueries];
    combinedOrQuery.limit = kBlockSize;
    combinedOrQuery.skip = lastReturnCount;
    [combinedOrQuery includeKey:@"user"];
    
    [combinedOrQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         NSMutableArray *users = [NSMutableArray array];
         
         for(PFObject *object in objects)
         {
             [users addObject:object[@"user"]];
         }
         
         if([self.delegate respondsToSelector:@selector(didFindBatchOfPals:)])[self.delegate didFindBatchOfPals:users];
         lastReturnCount += objects.count;
     }];
}
@end
