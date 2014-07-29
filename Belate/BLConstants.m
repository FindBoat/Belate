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

NSString *const kHangoutTimeKey = @"time";
NSString *const kHangoutLocationNameKey = @"locationName";
NSString *const kHangoutLocationAddressKey = @"locationAddress";

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
NSString *const kUserHangoutStatusCreate = @"create";
NSString *const kUserHangoutStatusRequested = @"requested";
NSString *const kUserHangoutStatusJoin = @"join";
NSString *const kUserHangoutStatusReject = @"reject";
NSString *const kUserHangoutStatusArrived = @"arrived";
NSString *const kUserHangoutStatusLate = @"late";

@end
