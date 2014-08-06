//
//  BLFriendStatusCell.h
//  Belate
//
//  Created by Hang Zhao on 8/3/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLFriendCell.h"

@interface BLFriendStatusCell : BLFriendCell

@property (nonatomic, strong) UILabel *statusLabel;

- (void)setUser:(PFUser *)user withHangoutStatus:(NSString *)status;

@end
