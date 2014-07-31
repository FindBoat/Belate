//
//  BLHangoutCell.h
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLHangoutCell : UITableViewCell

@property (nonatomic, strong) PFObject *hangout;

+ (CGFloat)cellHight;

- (void)setParticipantsAvatarFiles:(NSArray *)avatarFiles andStatus:(NSString *)hangoutStatus;

@end
