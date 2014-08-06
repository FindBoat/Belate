//
//  BLFriendCell.h
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

@interface BLFriendCell : UITableViewCell

@property (nonatomic, strong) PFUser *user;

@property (nonatomic, strong) PFImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;


- (void)initViews;
- (void)applyConstraints;

+ (CGFloat)cellHight;

@end
