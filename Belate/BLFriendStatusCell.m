//
//  BLFriendStatusCell.m
//  Belate
//
//  Created by Hang Zhao on 8/3/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLFriendStatusCell.h"
#import "BLUtility.h"

@interface BLFriendStatusCell()

@end

@implementation BLFriendStatusCell

- (void)setUser:(PFUser *)user withHangoutStatus:(NSString *)status {
    [super setUser:user];
    self.statusLabel.text = [self stringFromHangoutStatus:status];
    self.statusLabel.textColor = [self statusLabelColorFromHangoutStatus:status];
}

- (void)initViews {
    [super initViews];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.statusLabel];
}

- (void)applyConstraints {
    [super applyConstraints];
    
    // Constraints for statusLabel.
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:-10.0f]];
    
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:20.0f]];
}

- (NSString *)stringFromHangoutStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] || [status isEqualToString:kUserHangoutStatusJoin]) {
        return @"On the way";
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        return @"Pending";
    } else if ([status isEqualToString:kUserHangoutStatusArrived]) {
        return @"Arrived";
    } else if ([status isEqualToString:kUserHangoutStatusLate]) {
        return @"Late";
    } else if ([status isEqualToString:kUserHangoutStatusReject]) {
        return @"Rejected";
    }
    return nil;
}

- (UIColor *)statusLabelColorFromHangoutStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] || [status isEqualToString:kUserHangoutStatusJoin]) {
        return [BLUtility colorWithHexString:@"000000"];
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        return [UIColor grayColor];
    } else if ([status isEqualToString:kUserHangoutStatusArrived]) {
        return [BLUtility colorWithHexString:@"328735"];
    } else if ([status isEqualToString:kUserHangoutStatusLate]) {
        return [BLUtility colorWithHexString:@"883532"];
    } else if ([status isEqualToString:kUserHangoutStatusReject]) {
        return [UIColor grayColor];
    }
    return nil;
}



@end
