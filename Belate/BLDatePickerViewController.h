//
//  BLDatePickerViewController.h
//  Belate
//
//  Created by Hang Zhao on 7/27/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGConferenceDatePickerDelegate.h"

@protocol BLDatePickerViewControllerDelegate <NSObject>
- (void)datePickerViewController:(id)controller didSelectDate:(NSDate *)date;
@end

@interface BLDatePickerViewController : UIViewController <MGConferenceDatePickerDelegate>

@property (nonatomic, weak) id<BLDatePickerViewControllerDelegate> delegate;

- (id)initWithDate:(NSDate *)date;

@end
