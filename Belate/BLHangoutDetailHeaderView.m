//
//  BLHangoutDetailHeaderView.m
//  Belate
//
//  Created by Hang Zhao on 7/31/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutDetailHeaderView.h"
#import "BLHangoutAnnotation.h"
#import "BLHangoutActionView.h"
#import "BLUtility.h"

@interface BLHangoutDetailHeaderView()

@property (nonatomic, strong) BLHangoutActionView *actionView;

@property (nonatomic, strong) PFObject *hangout;
@property (nonatomic, strong) PFUser *creator;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) UILabel *locationAddressLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) CGRect mapViewFrame;
@property (nonatomic) BOOL isMapOpen;
@property (nonatomic) BOOL hasInitMapViewRegion;

@end

@implementation BLHangoutDetailHeaderView

- (id)initWithFrame:(CGRect)frame
         andHangout:(PFObject *)hangout
         andCreator:(PFUser *)creator
          andStatus:(NSString *)status {
    self = [super initWithFrame:frame];
    if (self) {
        _hangout = hangout;
        _creator = creator;
        _status = status;
        
        [self initViews];
        [self applyConstraints];
        
        [self.actionView.acceptButton addTarget:self action:@selector(acceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionView.rejectButton addTarget:self action:@selector(rejectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionView.checkInButton addTarget:self action:@selector(checkInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)updateDistance:(float)distance {
    [self.actionView updateDistance:distance];
}

+ (CGRect)rectForViewBasedOnStatus:(NSString *)status {
    float actionViewHeight = [BLHangoutActionView heightBasedOnStatus:status];
    if (actionViewHeight > 0) {
        // This is used for top padding.
        actionViewHeight += 15.0f;
    }
    return CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 240 + actionViewHeight);
}

- (void)initViews {
    self.actionView = [[BLHangoutActionView alloc] initWithFrame:CGRectZero andCreator:self.creator andHStatus:self.status];
    self.actionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionView];
    
    self.locationNameLabel = [UILabel new];
    self.locationNameLabel.textAlignment = NSTextAlignmentLeft;
    self.locationNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:18.0];
    self.locationNameLabel.text = self.hangout[kHangoutVenueKey][kVenueNameKey];
    self.locationNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.locationNameLabel];
    
    self.locationAddressLabel = [UILabel new];
    self.locationAddressLabel.textAlignment = NSTextAlignmentLeft;
    self.locationAddressLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.locationAddressLabel.text = self.hangout[kHangoutVenueKey][kVenueAddressKey];
    self.locationAddressLabel.text = [NSString stringWithFormat:@"%@, %@", self.hangout[kHangoutVenueKey][kVenueAddressKey], self.hangout[kHangoutVenueKey][kVenueCityKey]];
    
    self.locationAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.locationAddressLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.dateLabel.text = [[BLUtility blDateFormatter] stringFromDate:self.hangout[kHangoutTimeKey]];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.dateLabel];
    
    [self initMapView];
}

- (void)initMapView {
    self.mapView = [MKMapView new];
    self.mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.mapView.layer.borderWidth = 0.5;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mapView];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([self.hangout[kHangoutVenueKey][kVenueLatKey] doubleValue], [self.hangout[kHangoutVenueKey][kVenueLngKey] doubleValue]), 2000, 2000);
    [self.mapView setRegion:region animated:NO];
    
    BLHangoutAnnotation *annotation = [BLHangoutAnnotation new];
    [annotation setTitle:self.hangout[kHangoutVenueKey][kVenueNameKey]];
    [annotation setSubtitle:[NSString stringWithFormat:@"%@, %@", self.hangout[kHangoutVenueKey][kVenueAddressKey], self.hangout[kHangoutVenueKey][kVenueCityKey]]];
    [annotation setIsOpen:YES];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.hangout[kHangoutVenueKey][kVenueLatKey] doubleValue], [self.hangout[kHangoutVenueKey][kVenueLngKey] doubleValue]);
    [annotation setCoordinate:coordinate];
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:NO];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.isMapOpen = NO;
    self.hasInitMapViewRegion = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMapView:)];
    [self.mapView addGestureRecognizer:tapGesture];
}

- (void)applyConstraints {
    // Constraints for actionView.
    float actionViewHeight = [BLHangoutActionView heightBasedOnStatus:self.status];
    if (actionViewHeight > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:15]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:actionViewHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    }
    // Constraints for locationNameLabel.
    if (actionViewHeight > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.actionView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:15]];
    } else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:15]];
    }
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationNameLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    // Constraints for locationAddressLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationAddressLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.locationNameLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationAddressLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationAddressLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    // Constraints for dateLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.locationAddressLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    // Constraints for mapView;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.dateLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:10]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:150]];
}

- (void)updateMapViewRegion {
    if (!self.hasInitMapViewRegion) {
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
        
        self.hasInitMapViewRegion = YES;
    }
}

- (void)openMapView:(UIGestureRecognizer*)recognizer {
    if (self.isMapOpen) {
        return;
    }
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.mapViewFrame = self.mapView.frame;
                         [self.mapView setFrame:self.superview.frame];
                     } completion:^(BOOL finished) {
                         [self.mapView setZoomEnabled:YES];
                         [self.mapView setScrollEnabled:YES];
                         self.mapView.userInteractionEnabled = YES;
                         self.isMapOpen = YES;

                         [self.delegate hangoutDetailHeaderView:self didToggleMapView:YES];
                     }];
}

- (void)closeMapView {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [self.mapView setFrame:self.mapViewFrame];
                     } completion:^(BOOL finished){
                         self.isMapOpen = NO;
                         [self.delegate hangoutDetailHeaderView:self didToggleMapView:NO];
                     }];
}

#pragma mark - button
- (void)acceptButtonAction:(id)sender {
    [self.delegate hangoutDetailHeaderView:self didTapAcceptButton:sender];
}

- (void)rejectButtonAction:(id)sender {
    [self.delegate hangoutDetailHeaderView:self didTapRejectButton:sender];
}

- (void)checkInButtonAction:(id)sender {
    [self.delegate hangoutDetailHeaderView:self didTapCheckInButton:sender];
}

@end
