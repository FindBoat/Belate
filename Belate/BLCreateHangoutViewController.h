//
//  BLCreateHangoutViewController.h
//  Belate
//
//  Created by Hang Zhao on 7/26/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLVenueSearchViewController.h"
#import "BLDatePickerViewController.h"
#import "MGConferenceDatePickerDelegate.h"
#import "BLFriendSelectViewController.h"

@protocol BLCreateHangoutViewControllerDelegate <NSObject>
- (void)createHangoutViewController:(id)controller didCreateHangout:(PFObject *)hangout;
@end

@interface BLCreateHangoutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BLVenueSearchViewControllerDelegate, BLDatePickerViewControllerDelegate, BLFriendSelectViewControllerDelegate>

@property (nonatomic, weak) id<BLCreateHangoutViewControllerDelegate> delegate;

@end
