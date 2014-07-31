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
#import "BLFriendSelectViewController.h"
#import "MBProgressHUD.h"

@interface BLCreateHangoutViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BLVenueSearchViewController *venueSearchViewController;

@property (nonatomic, strong) FSVenue *venue;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSMutableArray *friends;

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
    
    UIBarButtonItem *navDoneButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self
                                      action:@selector(navDoneButtonAction:)];
    self.navigationItem.rightBarButtonItem = navDoneButton;
    
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

    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
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
        NSMutableString *strFriends = [NSMutableString new];
        if (self.friends) {
            for (int i = 0; i < MIN(2, self.friends.count); ++i) {
                if (i == 0) {
                    [strFriends appendString:self.friends[i][kUserNameKey]];
                } else {
                    [strFriends appendString:@", "];
                    [strFriends appendString:self.friends[i][kUserNameKey]];
                }
            }
            if (self.friends.count > 2) {
                [strFriends appendString:[NSString stringWithFormat:@", +%lu", (self.friends.count - 2)]];
            }
            cell.textLabel.text = strFriends;
        } else {
            cell.textLabel.text = @"Add your friends to this Hangout";
        }
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        self.venueSearchViewController = [BLVenueSearchViewController new];
        self.venueSearchViewController.delegate = self;
        [self presentViewController:self.venueSearchViewController animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        BLDatePickerViewController *datePickerViewController = [[BLDatePickerViewController alloc] initWithDate:self.date];
        [datePickerViewController setDelegate:self];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:datePickerViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    } else if (indexPath.section == 2) {
        BLFriendSelectViewController *friendSelectViewController = [[BLFriendSelectViewController alloc] initWithStyle:UITableViewStylePlain andSelectedUsers:self.friends];
        friendSelectViewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:friendSelectViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)navCancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navDoneButtonAction:(id)sender {
    if (![self checkHangoutValidity]) {
        return;
    }
    
    [BLUtility askFacebookPublishPermissionWithBlock:^(BOOL succeeded) {
        if (succeeded) {
            [self createHangout];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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

#pragma mark - BLFriendSelectViewControllerDelegate
- (void)friendSelectViewController:(id)controller didSelectFriends:(NSMutableArray *)friends {
    self.friends = friends;
    [self.tableView reloadData];
}

#pragma mark - ()
- (BOOL)checkHangoutValidity {
    if (!self.venue) {
        [BLUtility showErrorAlertWithTitle:@"Location" andMessage:@"Please select a location :)"];
        return NO;
    } else if (!self.date) {
        [BLUtility showErrorAlertWithTitle:@"Time" andMessage:@"Please select a time :)"];
        return NO;
    }
    
    return YES;
}

- (void)createHangout {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    PFObject *hangout = [PFObject objectWithClassName:kHangoutClassKey];
    hangout[kHangoutTimeKey] = self.date;
    hangout[kHangoutLocationNameKey] = self.venue.name;
    hangout[kHangoutLocationAddressKey] = self.venue.location.address;
    [hangout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Store hangout user relation.
            NSMutableArray *relations = [NSMutableArray new];
            
            PFObject *relation = [PFObject objectWithClassName:kUserHangoutClassKey];
            relation[kUserHangoutHangoutKey] = hangout;
            relation[kUserHangoutUserKey] = [PFUser currentUser];
            relation[kUserHangoutStatusKey] = kUserHangoutStatusCreate;
            [relations addObject:relation];
            
            for (PFUser *friend in self.friends) {
                PFObject *relation = [PFObject objectWithClassName:kUserHangoutClassKey];
                relation[kUserHangoutHangoutKey] = hangout;
                relation[kUserHangoutUserKey] = friend;
                relation[kUserHangoutStatusKey] = kUserHangoutStatusRequested;
                [relations addObject:relation];
            }
            
            [PFObject saveAllInBackground:relations block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self createLocalNotification];
                    [self.delegate createHangoutViewController:self didCreateHangout:hangout];
                }
                [hud hide:YES];
            }];
        }
    }];
}

- (void)createLocalNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = self.date;
    localNotification.alertBody = [NSString stringWithFormat:@"You are LATE for %@!", self.venue.name];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
