//
//  BLHangoutDetailViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/31/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutDetailViewController.h"
#import "BLUtility.h"
#import "BLFriendStatusCell.h"
#import "BLHangoutDetailHeaderView.h"
#import "MBProgressHUD.h"

@interface BLHangoutDetailViewController ()

@property (nonatomic, strong) PFObject *userHangout;
@property (nonatomic, strong) PFObject *hangout;
@property (nonatomic, strong) BLHangoutDetailHeaderView *headerView;

@end

@implementation BLHangoutDetailViewController

- (id)initWithUserHangout:(PFObject *)userHangout {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.parseClassName = kUserHangoutUserKey;
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        
        _userHangout = userHangout;
        _hangout = self.userHangout[kUserHangoutHangoutKey];
        [_hangout fetchIfNeeded];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Hangout";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/250.0 green:240.0/250.0 blue:235.0/250.0 alpha:1.0];
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Get hangout status and creator.
    self.headerView = [[BLHangoutDetailHeaderView alloc]
                       initWithFrame:[BLHangoutDetailHeaderView rectForViewBasedOnStatus:self.userHangout[kUserHangoutStatusKey]]
                       andHangout:self.hangout
                       andCreator:self.hangout[kHangoutCreatorKey]
                       andStatus:self.userHangout[kUserHangoutStatusKey]];
    self.headerView.delegate = self;
    self.headerView.mapView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
}

# pragma - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.headerView updateMapViewRegion];
    
    // Calculate distance away.
    CLLocationCoordinate2D hangoutLocation = CLLocationCoordinate2DMake([self.hangout[kHangoutVenueKey][kVenueLatKey] doubleValue],
                                                                        [self.hangout[kHangoutVenueKey][kVenueLngKey] doubleValue]);
    float dist = [BLUtility distanceBetweenPoint:userLocation.coordinate andPoint:hangoutLocation];
    [(BLHangoutDetailHeaderView *)self.headerView updateDistance:dist];
}

#pragma mark - PFQueryTableViewController
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:kUserHangoutClassKey];
    [query whereKey:kUserHangoutHangoutKey equalTo:self.hangout];
    [query includeKey:kUserHangoutUserKey];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:kUserHangoutStatusKey];
    return query;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    BLFriendStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BLFriendStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:cellIdentifier];
    }
    
    [cell setUser:object[kUserHangoutUserKey] withHangoutStatus:object[kUserHangoutStatusKey]];
    cell.backgroundColor = [UIColor colorWithRed:245.0/250.0 green:240.0/250.0 blue:235.0/250.0 alpha:1.0];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BLFriendCell cellHight];
}


# pragma - BLHangoutDetailHeaderViewDelegate
- (void)hangoutDetailHeaderView:(id)headerView didToggleMapView:(BOOL)open {
    if (open) {
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleDone target:self action:@selector(closeMapView)];
        [close setTintColor:[UIColor whiteColor]];
        [self.navigationItem setLeftBarButtonItem:close animated:YES];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)hangoutDetailHeaderView:(id)headerView didTapAcceptButton:(UIButton *)button {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.userHangout[kUserHangoutStatusKey] = kUserHangoutStatusJoin;
    [self.userHangout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self viewDidLoad];
            [self viewWillAppear:YES];
//            [self.tableView.tableHeaderView performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
        }
        [hud hide:YES];
    }];
}

- (void)hangoutDetailHeaderView:(id)headerView didTapRejectButton:(UIButton *)button {
    self.userHangout[kUserHangoutStatusKey] = kUserHangoutStatusReject;
    [self.userHangout saveInBackground];
}

- (void)hangoutDetailHeaderView:(id)headerView didTapCheckInButton:(UIButton *)button {
    
}


- (void)closeMapView {
    [self.headerView closeMapView];
}

@end
