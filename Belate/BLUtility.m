//
//  BLUtility.m
//  Belate
//
//  Created by Hang Zhao on 7/20/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLUtility.h"
#import "UIImage+ResizeAdditions.h"
#import <Parse/Parse.h>
#import "OLGhostAlertView.h"


@implementation BLUtility

+ (UIColor *)colorWithHexString:(NSString *)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (void)refreshFacebookFriends {
    // Refresh friends data.
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *data = [result objectForKey:@"data"];
            NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
            for (NSDictionary *friendData in data) {
                if (friendData[@"id"]) {
                    [facebookIds addObject:friendData[@"id"]];
                }
            }
            
            // Find current friends.
            PFQuery *fromQuery = [PFQuery queryWithClassName:kFriendClassKey];
            [fromQuery whereKey:kFriendStatusKey equalTo:kFriendStatusFriend];
            [fromQuery whereKey:kFriendFromUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *toQuery = [PFQuery queryWithClassName:kFriendClassKey];
            [toQuery whereKey:kFriendStatusKey equalTo:kFriendStatusFriend];
            [toQuery whereKey:kFriendToUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *friendQuery = [PFQuery orQueryWithSubqueries:@[fromQuery, toQuery]];
            [friendQuery includeKey:kFriendToUserKey];
            [friendQuery includeKey:kFriendFromUserKey];

            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                if (!error) {
                    // Store current friend id in a set.
                    NSMutableSet *friendIds = [NSMutableSet new];
                    for (PFObject *friendship in results) {
                        NSString *fromId = [friendship[kFriendFromUserKey] objectId];
                        if (![fromId isEqualToString:[PFUser currentUser].objectId]) {
                            [friendIds addObject:[friendship[kFriendFromUserKey] objectId]];
                        } else {
                            [friendIds addObject:[friendship[kFriendToUserKey] objectId]];
                        }
                    }
                    
                    // Add new Facebook friends.
                    PFQuery *query = [PFUser query];
                    [query whereKey:kUserFacebookIdKey containedIn:facebookIds];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *queryError) {
                        if (!queryError) {
                            for (PFUser *friend in objects) {
                                if (![friendIds containsObject:friend.objectId]) {
                                    PFObject *friendship = [PFObject objectWithClassName:kFriendClassKey];
                                    friendship[kFriendFromUserKey] = [PFUser currentUser];
                                    friendship[kFriendToUserKey] = friend;
                                    friendship[kFriendStatusKey] = kFriendStatusFriend;
                                    
                                    [friendship saveEventually];
                                }
                            }
                        }
                    }];
                }
            }];

        }
    }];
}

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    if (newProfilePictureData.length == 0) {
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile
    // picture data matches the incoming profile picture. If it does, avoid uploading this
    // data to Parse.
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture.
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            return;
        }
    }
    
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
    
    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
    
    // Using JPEG for larger pictures.
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5);
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:kUserProfilePictureMediumKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kUserProfilePictureSmallKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
}

+ (void)showErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    OLGhostAlertView *ghastly = [[OLGhostAlertView alloc] initWithTitle:title message:message];
    ghastly.position = OLGhostAlertViewPositionCenter;
    ghastly.style = OLGhostAlertViewStyleDark;
    ghastly.timeout = 1.5;
    [ghastly show];
}

@end
