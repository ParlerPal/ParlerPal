//
//  PPPalFinder.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/21/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPPalFinderDelegate <NSObject>

@required
-(void)didFindBatchOfPals:(NSArray *)pals;

@end

@interface PPPalFinder : NSObject
{
    __block int lastReturnCount;
    __block id delegate;
}
@property(nonatomic, strong) id delegate;

-(void)searchForABatchOfPossiblePals;

@end
