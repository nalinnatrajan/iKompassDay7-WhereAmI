//
//  MapAnnotation.h
//  whereAmI
//
//  Created by Nalin Natrajan on 14/3/15.
//  Copyright (c) 2015 Nalin Natrajan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>


@property NSString *title;
@property NSString *subtitle;
@property CLLocationCoordinate2D coordinate;

@end
