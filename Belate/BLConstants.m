//
//  BLConstants.m
//  Belate
//
//  Created by Hang Zhao on 7/20/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLConstants.h"

@implementation BLConstants

NSString *const kMainColor = @"6266D8";

#pragma mark - User class
NSString *const kUserClassKey = @"_User";

NSString *const kUserFacebookIdKey = @"facebookId";
NSString *const kUserNameKey = @"name";
NSString *const kUserProfilePictureMediumKey = @"profilePictureMedium";
NSString *const kUserProfilePictureSmallKey = @"profilePictureSmall";

#pragma mark - Hangout class
NSString *const kHangoutClassKey = @"Hangout";

NSString *const kHangoutCreatorKey = @"creator";
NSString *const kHangoutTimeKey = @"time";
NSString *const kHangoutVenueKey = @"venue";

#pragma mark - Venue class
NSString *const kVenueClassKey = @"Venue";

NSString *const kVenueNameKey = @"name";
NSString *const kVenueAddressKey = @"address";
NSString *const kVenueCityKey = @"city";
NSString *const kVenueCountryKey = @"country";
NSString *const kVenueCrossStreetKey = @"crossStreet";
NSString *const kVenueLatKey = @"lat";
NSString *const kVenueLngKey = @"lng";
NSString *const kVenuePostalCodeKey = @"postalCode";
NSString *const kVenueStateKey = @"state";
NSString *const kVenueMainCategoryKey = @"mainCategory";

#pragma mark - Friend class keys
NSString *const kFriendClassKey = @"Friend";

NSString *const kFriendFromUserKey = @"fromUser";
NSString *const kFriendToUserKey = @"toUser";
NSString *const kFriendStatusKey = @"status";

#pragma mark - Friend class values
NSString *const kFriendStatusRequest = @"request";
NSString *const kFriendStatusFriend = @"friend";

#pragma mark - User Hangout relation class
NSString *const kUserHangoutClassKey = @"UserHangout";

NSString *const kUserHangoutUserKey = @"user";
NSString *const kUserHangoutHangoutKey = @"hangout";
NSString *const kUserHangoutStatusKey = @"status";

#pragma mark - User Hangout relation value
NSString *const kUserHangoutStatusCreate = @"1_create";
NSString *const kUserHangoutStatusRequested = @"0_requested";
NSString *const kUserHangoutStatusJoin = @"2_join";
NSString *const kUserHangoutStatusReject = @"5_reject";
NSString *const kUserHangoutStatusArrived = @"3_arrived";
NSString *const kUserHangoutStatusLate = @"4_late";


#pragma Notification
NSString *const kHangoutListRefreshNotification = @"HangoutListRefreshNotification";


#pragma Else
float const kMinCheckInDistance = 1;


@end
