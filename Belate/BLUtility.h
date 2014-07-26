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

@end