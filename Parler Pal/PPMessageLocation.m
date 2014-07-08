//
//  PPMessageLocation.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/1/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMessageLocation.h"
#import <AddressBook/AddressBook.h>

@interface PPMessageLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation PPMessageLocation
@synthesize index;

-(id)initWithName:(NSString*)name subject:(NSString*)subject coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"";
        }
        self.subject = subject;
        self.theCoordinate = coordinate;
    }
    return self;
}

#pragma mark - property return methods

-(NSString *)title {
    return _name;
}

-(NSString *)subtitle {
    return _subject;
}

-(CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

-(MKMapItem*)mapItem
{
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _subject};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
