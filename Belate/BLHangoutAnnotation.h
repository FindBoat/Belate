//
//  BLHangoutAnnotation.h
//  Belate
//
//  Created by Hang Zhao on 7/31/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface BLHangoutAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) BOOL isOpen;

@end
