//
//  BLFriendCell.h
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Parse/Parse.h>

@interface BLFriendCell : UITableViewCell

@property (nonatomic, strong) PFUser *user;

+ (CGFloat)cellHight;


@end
