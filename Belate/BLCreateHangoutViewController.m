//
//  BLCreateHangoutViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/26/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLCreateHangoutViewController.h"
#import "FSVenue.h"
#import "BLUtility.h"
#import "MGConferenceDatePicker.h"

@interface BLCreateHangoutViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BLVenueSearchViewController *venueSearchViewController;

@property (nonatomic, strong) FSVenue *venue;
@property (nonatomic, strong) NSDate *date;

@end

@implementation BLCreateHangoutViewController

- (void)loadView {
    self.navigationItem.title = @"Create Hangout";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    
    UIBarButtonItem *navCancelButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                        target:self
                                        action:@selector(navCancelButtonAction:)];
    self.navigationItem.leftBarButtonItem = navCancelButton;
    
    // Init TableView.
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                  style:UITableViewStyleGrouped];
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/250.0 green:240.0/250.0 blue:235.0/250.0 alpha:1.0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HangoutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) {
        if (self.venue) {
            cell.textLabel.text = self.venue.name;
            cell.detailTextLabel.text = self.venue.location.address;
        } else {
            cell.textLabel.text = @"Where shall you meet";
        }
    } else if (indexPath.section == 1) {
        if (self.date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEEE, MMM dd 'at' hh:mm a"];
            cell.textLabel.text = [formatter stringFromDate:self.date];
        } else {
            cell.textLabel.text = @"When shall you meet";
        }
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Add your friends to this Hangout";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Add location";
    } else if (section == 1) {
        return @"Add time";
    } else if (section == 2) {
        return @"Add friends";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.venueSearchViewController = [BLVenueSearchViewController new];
        self.venueSearchViewController.delegate = self;
        [self presentViewController:self.venueSearchViewController animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        BLDatePickerViewController *datePickerViewController = [[BLDatePickerViewController alloc] initWithDate:self.date];
        [datePickerViewController setDelegate:self];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:datePickerViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)navCancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BLVenueSearchViewControllerDelegate
- (void)venueSearchViewController:(id)controller didSelectVenue:(FSVenue *)venue {
    self.venue = venue;
    [self.tableView reloadData];
}

#pragma mark - BLDatePickerViewControllerDelegate
- (void)datePickerViewController:(id)controller didSelectDate:(NSDate *)date {
    self.date = date;
    [self.tableView reloadData];
}


@end
