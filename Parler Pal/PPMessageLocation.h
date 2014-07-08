//
//  PPMessageLocation.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/1/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PPMessageLocation : NSObject <MKAnnotation>
@property (nonatomic, readwrite) int index;

-(id)initWithName:(NSString*)name subject:(NSString*)subject coordinate:(CLLocationCoordinate2D)coordinate;
-(MKMapItem*)mapItem;

@end
