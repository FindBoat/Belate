//
//  BLFriendCell.m
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLFriendCell.h"

@interface BLFriendCell()

@end

@implementation BLFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self applyConstraints];
    }
    return self;
}

- (void)initViews {
    self.avatarView = [[PFImageView alloc] init];
    self.avatarView.image = [UIImage imageNamed:@"avatar-placeholder"];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];
}

- (void)setUser:(PFUser *)user {
    _user = user;
    
    self.nameLabel.text = user[kUserNameKey];
    self.avatarView.file = (PFFile *)user[kUserProfilePictureSmallKey];
    [self.avatarView loadInBackground];
}

- (void)applyConstraints {
    // Constraints for avatarView.
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeLeft
																multiplier:1
																  constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeHeight
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:40.0f]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:40.0f]];

    // Constraints for nameLabel.
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.avatarView
																 attribute:NSLayoutAttributeRight
																multiplier:1
																  constant:10.0f]];
    
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeTop
																multiplier:1
																  constant:20.0f]];
}

+ (CGFloat)cellHight {
    return 60.0f;
}

@end
