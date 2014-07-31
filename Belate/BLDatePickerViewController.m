//
//  BLDatePickerViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/27/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLDatePickerViewController.h"
#import "BLUtility.h"
#import "MGConferenceDatePicker.h"

@interface BLDatePickerViewController ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) MGConferenceDatePicker *datePicker;

@end

@implementation BLDatePickerViewController

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
    }
    return self;
}

- (void)loadView {
    self.navigationItem.title = @"Time";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    
    UIBarButtonItem *navCancelButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                        target:self
                                        action:@selector(navCancelButtonAction:)];
    self.navigationItem.leftBarButtonItem = navCancelButton;
    
    UIBarButtonItem *navDoneButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self
                                      action:@selector(navDoneButtonAction:)];
    self.navigationItem.rightBarButtonItem = navDoneButton;
    
    self.datePicker = [[MGConferenceDatePicker alloc] initWithFrame:CGRectZero andDate:self.date];
    [self.datePicker setDelegate:self];
    [self.datePicker setBackgroundColor:[UIColor colorWithRed:245.0/250.0 green:240.0/250.0 blue:235.0/250.0 alpha:1.0]];
    [self setView:self.datePicker];
}

#pragma mark - MGConferenceDatePickerDelegate
- (void)conferenceDatePicker:(MGConferenceDatePicker *)datePicker saveDate:(NSDate *)date {
    // Check if date is a future.
    if ([date compare:[NSDate date]] == NSOrderedDescending) {
        [self.delegate datePickerViewController:self didSelectDate:date];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [BLUtility showErrorAlertWithTitle:@"Hint" andMessage:@"Please select a future date :)"];
    }
}

- (void)conferenceDatePicker:(MGConferenceDatePicker *)datePicker doneButtonShouldEnable:(BOOL)enable {
    [self.navigationItem.rightBarButtonItem setEnabled:enable];
}

- (void)navCancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navDoneButtonAction:(id)sender {
    [self.datePicker saveDate];
}

@end
