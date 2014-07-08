//
//  UIImage+Resize.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/8/14.
//  Copyright (c) 2014 AaronVizzini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

@end
