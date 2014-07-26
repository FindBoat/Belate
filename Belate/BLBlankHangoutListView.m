//
//  BLBlankHangoutListView.m
//  Belate
//
//  Created by Hang Zhao on 7/24/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLBlankHangoutListView.h"
#import "BLUtility.h"

@interface BLBlankHangoutListView()

@property (nonatomic, strong) UILabel *blankLabel;

@end

@implementation BLBlankHangoutListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blankLabel = [UILabel new];
        self.blankLabel.textAlignment = NSTextAlignmentCenter;
        self.blankLabel.text = @"Let's create a Hangout with your friends, people who are late will be punished by posting something funny on their Facebook.";
        self.blankLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        self.blankLabel.textColor = [UIColor blackColor];
        self.blankLabel.adjustsFontSizeToFitWidth = NO;
        self.blankLabel.numberOfLines = 0;
        self.blankLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.blankLabel];
        
        self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.createButton setTitle:@"Create a hangout" forState:UIControlStateNormal];
        self.createButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:16.0];
        [self.createButton setTitleColor:[BLUtility colorWithHexString:kMainColor] forState:UIControlStateNormal];
        [self.createButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.createButton.backgroundColor = [UIColor whiteColor];
        self.createButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.createButton];

        self.backgroundColor = [UIColor colorWithRed:245.0/250.0 green:240.0/250.0 blue:235.0/250.0 alpha:1.0];
        
        [self applyConstraints];

    }
    return self;
}

- (void)applyConstraints {
    // Constraints for blankLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.blankLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.blankLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:130]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.blankLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:250]];
    
    // Constraints for createButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.createButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.createButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.blankLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:25]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.createButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.createButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:35]];

}

@end
