//
//  BLHangoutActionView.h
//  Belate
//
//  Created by Hang Zhao on 8/4/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLHangoutActionView : UIView

@property (nonatomic, strong) UIButton *checkInButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *rejectButton;

- (id)initWithFrame:(CGRect)frame andCreator:(PFUser *)creator andHStatus:(NSString *)status;

- (void)updateDistance:(float)distance;

+ (CGFloat)heightBasedOnStatus:(NSString *)status;

@end
