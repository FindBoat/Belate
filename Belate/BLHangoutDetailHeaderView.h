//
//  BLHangoutDetailHeaderView.h
//  Belate
//
//  Created by Hang Zhao on 7/31/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BLHangoutActionView;

@protocol BLHangoutDetailHeaderViewDelegate <NSObject>
- (void)hangoutDetailHeaderView:(id)headerView didToggleMapView:(BOOL)open;
- (void)hangoutDetailHeaderView:(id)headerView didTapAcceptButton:(UIButton *)button;
- (void)hangoutDetailHeaderView:(id)headerView didTapRejectButton:(UIButton *)button;
- (void)hangoutDetailHeaderView:(id)headerView didTapCheckInButton:(UIButton *)button;
@end

@interface BLHangoutDetailHeaderView : UIView

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id<BLHangoutDetailHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
         andHangout:(PFObject *)hangout
         andCreator:(PFUser *)creator
          andStatus:(NSString *)status;

- (void)closeMapView;

- (void)updateMapViewRegion;

- (void)updateDistance:(float)distance;

+ (CGRect)rectForViewBasedOnStatus:(NSString *)status;

@end
