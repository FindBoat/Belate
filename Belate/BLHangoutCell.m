//
//  BLHangoutCell.m
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutCell.h"
#import "BLUtility.h"

#define MAX_AVATAR_SHOW 4

@interface BLHangoutCell()

@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) NSMutableArray *avatarArray;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *othersLabel;

@end

@implementation BLHangoutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.locationNameLabel = [UILabel new];
        self.locationNameLabel.textAlignment = NSTextAlignmentLeft;
        self.locationNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:16.0];
        self.locationNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.locationNameLabel];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.dateLabel];
        
        self.statusLabel = [UILabel new];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:13.0];
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.statusLabel];
        
        self.othersLabel = [UILabel new];
        self.othersLabel.textAlignment = NSTextAlignmentCenter;
        self.othersLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        self.othersLabel.textColor = [UIColor darkGrayColor];
        self.othersLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.othersLabel];

        
        self.avatarArray = [NSMutableArray new];

        [self applyConstraints];
    }
    return self;
}

+ (CGFloat)cellHight {
    return 120.0f;
}

- (void)setHangout:(PFObject *)hangout {
    self.locationNameLabel.text = hangout[kHangoutVenueKey][kVenueNameKey];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM dd 'at' hh:mm a"];
    self.dateLabel.text = [formatter stringFromDate:hangout[kHangoutTimeKey]];
}

- (void)setParticipantsAvatarFiles:(NSArray *)avatarFiles andStatus:(NSString *)hangoutStatus {
    for (UIView *avatarView in self.avatarArray) {
        [avatarView removeFromSuperview];
    }
    [self.avatarArray removeAllObjects];
    
    for (int i = 0; i < MIN(MAX_AVATAR_SHOW, avatarFiles.count); ++i) {
        PFImageView *avatarView = [[PFImageView alloc] init];
        avatarView.image = [UIImage imageNamed:@"avatar-placeholder"];
        avatarView.file = avatarFiles[i];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:avatarView];
        [avatarView loadInBackground];
        
        [self.avatarArray addObject:avatarView];
    }
    
    self.statusLabel.text = [self stringFromHangoutStatus:hangoutStatus];
    self.statusLabel.textColor = [self statusLabelColorFromHangoutStatus:hangoutStatus];
    self.contentView.backgroundColor = [self cellColorFromHangoutStatus:hangoutStatus];
    
    self.othersLabel.text = [NSString stringWithFormat:@"%lu people joined", avatarFiles.count];
    
    [self addAvatarConstraints];
    [self setNeedsUpdateConstraints];
}

- (void)applyConstraints {
    // Constraints for locationNameLabel.
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeLeft
																multiplier:1
																  constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:250.0f]];

    // Constraints for dateLabel.
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.locationNameLabel
																 attribute:NSLayoutAttributeBottom
																multiplier:1
																  constant:5]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeLeft
																multiplier:1
																  constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeWidth
																multiplier:1
																  constant:0]];
    
    // Constraints for statusLabel.
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
																 attribute:NSLayoutAttributeCenterY
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.locationNameLabel
																 attribute:NSLayoutAttributeCenterY
																multiplier:1
																  constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:-10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:110.0f]];
}

- (void)addAvatarConstraints {
    for (int i = 0; i < self.avatarArray.count; ++i) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarArray[i]
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.dateLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:10]];
        if (i == 0) {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarArray[i]
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1
                                                                          constant:10]];
        } else {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarArray[i]
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.avatarArray[i - 1]
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1
                                                                          constant:5]];
        }
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarArray[i]
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:40.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarArray[i]
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:40.0f]];
    }
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.othersLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.avatarArray[0]
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.othersLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.avatarArray[self.avatarArray.count - 1]
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:5]];
   
}

- (NSString *)stringFromHangoutStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] || [status isEqualToString:kUserHangoutStatusJoin]) {
        return @"Active";
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        return @"Request";
    } else if ([status isEqualToString:kUserHangoutStatusArrived]) {
        return @"Arrived";
    } else if ([status isEqualToString:kUserHangoutStatusLate]) {
        return @"Late";
    } else if ([status isEqualToString:kUserHangoutStatusReject]) {
        return @"Rejected";
    }
    return nil;
}

- (UIColor *)cellColorFromHangoutStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] || [status isEqualToString:kUserHangoutStatusJoin]) {
        return [BLUtility colorWithHexString:@"FFFFFF"];
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        return [BLUtility colorWithHexString:@"F5ECCE"];
    } else if ([status isEqualToString:kUserHangoutStatusArrived]) {
        return [BLUtility colorWithHexString:@"EBEBEB"];
    } else if ([status isEqualToString:kUserHangoutStatusLate]) {
        return [BLUtility colorWithHexString:@"EBEBEB"];
    } else if ([status isEqualToString:kUserHangoutStatusReject]) {
        return [BLUtility colorWithHexString:@"EBEBEB"];
    }
    return nil;
}

- (UIColor *)statusLabelColorFromHangoutStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] || [status isEqualToString:kUserHangoutStatusJoin]) {
        return [BLUtility colorWithHexString:@"328735"];
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        return [BLUtility colorWithHexString:@"000000"];
    } else if ([status isEqualToString:kUserHangoutStatusArrived]) {
        return [UIColor darkGrayColor];
    } else if ([status isEqualToString:kUserHangoutStatusLate]) {
        return [BLUtility colorWithHexString:@"883532"];
    } else if ([status isEqualToString:kUserHangoutStatusReject]) {
        return [UIColor darkGrayColor];
    }
    return nil;
}

@end
