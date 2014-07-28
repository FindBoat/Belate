//
//  BLVenueSearchViewController.h
//  Belate
//
//  Created by Hang Zhao on 7/27/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class FSVenue;


@protocol BLVenueSearchViewControllerDelegate <NSObject>
- (void)venueSearchViewController:(id)controller didSelectVenue:(FSVenue *)venue;
@end


@interface BLVenueSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<BLVenueSearchViewControllerDelegate> delegate;


@end

