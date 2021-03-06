//
//  BLConstants.h
//  Belate
//
//  Created by Hang Zhao on 7/20/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLConstants : NSObject

extern NSString *const kMainColor;

#pragma mark - User class
extern NSString *const kUserClassKey;

extern NSString *const kUserFacebookIdKey;
extern NSString *const kUserNameKey;
extern NSString *const kUserProfilePictureMediumKey;
extern NSString *const kUserProfilePictureSmallKey;

#pragma mark - Hangout class
extern NSString *const kHangoutClassKey;

extern NSString *const kHangoutCreatorKey;
extern NSString *const kHangoutTimeKey;
extern NSString *const kHangoutVenueKey;

#pragma mark - Venue class
extern NSString *const kVenueClassKey;

extern NSString *const kVenueNameKey;
extern NSString *const kVenueAddressKey;
extern NSString *const kVenueCityKey;
extern NSString *const kVenueCountryKey;
extern NSString *const kVenueCrossStreetKey;
extern NSString *const kVenueLatKey;
extern NSString *const kVenueLngKey;
extern NSString *const kVenuePostalCodeKey;
extern NSString *const kVenueStateKey;
extern NSString *const kVenueMainCategoryKey;

#pragma mark - Friend class keys
extern NSString *const kFriendClassKey;

extern NSString *const kFriendFromUserKey;
extern NSString *const kFriendToUserKey;
extern NSString *const kFriendStatusKey;

#pragma mark - Friend class values
extern NSString *const kFriendStatusRequest;
extern NSString *const kFriendStatusFriend;


#pragma mark - User Hangout relation class
extern NSString *const kUserHangoutClassKey;

extern NSString *const kUserHangoutUserKey;
extern NSString *const kUserHangoutHangoutKey;
extern NSString *const kUserHangoutStatusKey;
extern NSString *const kUserHangoutPunished;

#pragma mark - User Hangout relation value
extern NSString *const kUserHangoutStatusCreate;
extern NSString *const kUserHangoutStatusRequested;
extern NSString *const kUserHangoutStatusJoin;
extern NSString *const kUserHangoutStatusReject;
extern NSString *const kUserHangoutStatusArrived;
extern NSString *const kUserHangoutStatusLate;


#pragma Notification
extern NSString *const kHangoutListRefreshNotification;


#pragma Else
extern float const kMinCheckInDistance;

@end
