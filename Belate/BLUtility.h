//
//  BLUtility.h
//  Belate
//
//  Created by Hang Zhao on 7/20/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUtility : NSObject

+ (UIColor *)colorWithHexString:(NSString *)hex;

+ (void)refreshFacebookFriends;

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData;

+ (void)showErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (void)askFacebookPublishPermissionWithBlock:(void(^)(BOOL succeeded))block;

+ (void)punishWithHangout:(PFObject *)hangout;

+ (float)distanceBetweenPoint:(CLLocationCoordinate2D)point1 andPoint:(CLLocationCoordinate2D)point2;

+ (void)createLocalNotificationWithDate:(NSDate *)date andVenue:(PFObject *)venue;

+ (NSDateFormatter *)blDateFormatter;

@end
