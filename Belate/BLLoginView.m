//
//  BLLoginView.m
//  Belate
//
//  Created by Hang Zhao on 7/17/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLLoginView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLLoginView ()

@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *backgroundCoverImageView;

@end

@implementation BLLoginView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [UIImageView new];
        self.backgroundImageView.image = [UIImage imageNamed:@"login.jpg"];
        self.backgroundImageView.alpha = 0.9;
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundImageView];
        
        // This is a hacky way to darken the background image.
        self.backgroundCoverImageView = [UIImageView new];
        self.backgroundCoverImageView.image = [UIImage new];
        self.backgroundCoverImageView.backgroundColor = [UIColor blackColor];
        self.backgroundCoverImageView.alpha = 0.6;
        self.backgroundCoverImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundCoverImageView];
        
        self.logoLabel = [UILabel new];
        self.logoLabel.textAlignment = NSTextAlignmentCenter;
        self.logoLabel.text = @"Belate";
        self.logoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0];
        self.logoLabel.textColor = [UIColor whiteColor];
        self.logoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.logoLabel];
        
        self.fbLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.fbLoginButton.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:94.0/255.0 blue:201.0/255.0 alpha:0.85];
        [self.fbLoginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        [self.fbLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fbLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.fbLoginButton];

        [self applyConstraints];
    }

    return self;
}

- (void)applyConstraints {
    // Constraints for backgroundImageView;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    // Constraints for backgroundCoverImageView;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCoverImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCoverImageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCoverImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCoverImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    // Constraints for logoLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:200.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:40.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:220.0f]];
    
    // Constraints for fbLoginButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-100.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:250.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:40.0f]];
}


@end
