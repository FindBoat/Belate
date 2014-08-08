//
//  BLHangoutDetailViewController.h
//  Belate
//
//  Created by Hang Zhao on 7/31/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLHangoutDetailHeaderView.h"

@interface BLHangoutDetailViewController : PFQueryTableViewController <BLHangoutDetailHeaderViewDelegate, MKMapViewDelegate>

- (id)initWithUserHangout:(PFObject *)userHangout;

@end
