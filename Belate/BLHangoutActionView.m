//
//  BLHangoutActionView.m
//  Belate
//
//  Created by Hang Zhao on 8/4/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutActionView.h"
#import "BLUtility.h"

@interface BLHangoutActionView()

@property (nonatomic, strong) UILabel *requestLabel;

@end

@implementation BLHangoutActionView

- (id)initWithFrame:(CGRect)frame andCreator:(PFUser *)creator andHStatus:(NSString *)status {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViewsWithCreator:creator andStatus:status];
        [self applyConstraints];
    }
    return self;
}

+ (CGFloat)heightBasedOnStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] ||
        [status isEqualToString:kUserHangoutStatusJoin] ||
        [status isEqualToString:kUserHangoutStatusRequested]) {
        return 60.0f;
    }
    return 0;
}

- (void)updateDistance:(float)distance {
    NSString *str = [NSString stringWithFormat:@"%0.1f miles away", distance];
    [self.checkInButton setTitle:str forState:UIControlStateNormal];
}

- (void)initViews {
    self.checkInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.checkInButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:15.0];
    [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self.checkInButton layer] setBorderWidth:1.0f];
    [[self.checkInButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.checkInButton layer] setCornerRadius:6.0f];
    self.checkInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.checkInButton];
    
    self.requestLabel = [[UILabel alloc] init];
    self.requestLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.requestLabel.textColor = [UIColor whiteColor];
    self.requestLabel.textAlignment = NSTextAlignmentCenter;
    self.requestLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.requestLabel];
    
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    self.acceptButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.acceptButton setTitleColor:[BLUtility colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [[self.acceptButton layer] setBorderWidth:1.0f];
    [[self.acceptButton layer] setBorderColor:[BLUtility colorWithHexString:@"FFFFFF"].CGColor];
    [[self.acceptButton layer] setCornerRadius:6.0f];
    self.acceptButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.acceptButton];
    
    self.rejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rejectButton setTitle:@"Reject" forState:UIControlStateNormal];
    self.rejectButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.rejectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self.rejectButton layer] setBorderWidth:1.0f];
    [[self.rejectButton layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    [[self.rejectButton layer] setCornerRadius:6.0f];
    self.rejectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rejectButton];
    
    self.backgroundColor = [UIColor colorWithRed:4/255.0 green:143.0/255.0 blue:236.0/255.0 alpha:0.9];
}

- (void)updateViewsWithCreator:(PFUser *)creator andStatus:(NSString *)status {
    if ([status isEqualToString:kUserHangoutStatusCreate] ||
        [status isEqualToString:kUserHangoutStatusJoin]) {
        self.hidden = NO;
        self.checkInButton.hidden = NO;
        self.acceptButton.hidden = YES;
        self.rejectButton.hidden = YES;
        self.requestLabel.hidden = YES;
    } else if ([status isEqualToString:kUserHangoutStatusRequested]) {
        self.requestLabel.text = [NSString stringWithFormat:@"%@ has invited you to this Hangout", creator[kUserNameKey]];
        self.hidden = NO;
        self.checkInButton.hidden = YES;
        self.acceptButton.hidden = NO;
        self.rejectButton.hidden = NO;
        self.requestLabel.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (void)applyConstraints {
    // Constraints for checkInButton;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.checkInButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.checkInButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.checkInButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.checkInButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:150]];
    // Constraints for requestLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.requestLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.requestLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:-15]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.requestLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    // Constraints for acceptButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.acceptButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:-70]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.acceptButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:13]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.acceptButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:25]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.acceptButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:70]];
    // Constraints for rejectButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rejectButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:70]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rejectButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:13]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rejectButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:25]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rejectButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:70]];

}

@end
