//
//  BLHangoutListViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/24/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutListViewController.h"
#import "BLBlankHangoutListView.h"
#import "BLCreateHangoutViewController.h"
#import "BLHangoutCell.h"
#import "BLUtility.h"
#import "BLHangoutDetailViewController.h"

@interface BLHangoutListViewController()

@property (nonatomic, strong) BLBlankHangoutListView *blankView;

@end

@implementation BLHangoutListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHangoutListRefreshNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = kUserHangoutUserKey;
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Belate";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    
    UIBarButtonItem *navCreateButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(createButtonAction:)];
    self.navigationItem.rightBarButtonItem = navCreateButton;
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.blankView = [[BLBlankHangoutListView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView.createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add observer.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hangoutListNeedReload:) name:kHangoutListRefreshNotification object:nil];
}

#pragma mark - PFQueryTableViewController
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:kUserHangoutClassKey];
    [query whereKey:kUserHangoutUserKey equalTo:[PFUser currentUser]];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", kUserHangoutHangoutKey, kHangoutVenueKey]];
    [query orderByAscending:kUserHangoutStatusKey];
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.blankView.alpha = 1.0f;
        self.tableView.tableHeaderView = self.blankView;
    } else {
        self.blankView.alpha = 0;
        self.tableView.tableHeaderView = nil;
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    BLHangoutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BLHangoutCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    PFObject *hangout = object[kUserHangoutHangoutKey];
    [cell setHangout:hangout];

    PFQuery *query = [PFQuery queryWithClassName:kUserHangoutClassKey];
    [query whereKey:kUserHangoutHangoutKey equalTo:hangout];
    [query includeKey:kUserHangoutUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *avatarFiles = [NSMutableArray new];
            NSMutableArray *staleUserHangouts = [NSMutableArray new];
            NSString *hangoutStatus;

            for (PFObject *userHangout in objects) {
                PFUser *user = userHangout[kUserHangoutUserKey];
                [avatarFiles addObject:user[kUserProfilePictureSmallKey]];
                
                // Check if it's late.
                if ([(NSDate *)hangout[kHangoutTimeKey] compare:[NSDate date]] == NSOrderedAscending) {
                    // Set to Late if the user has joined or created.
                    if ([userHangout[kUserHangoutStatusKey] isEqualToString:kUserHangoutStatusJoin] ||
                        [userHangout[kUserHangoutStatusKey] isEqualToString:kUserHangoutStatusCreate]) {
                        userHangout[kUserHangoutStatusKey] = kUserHangoutStatusLate;
                        [staleUserHangouts addObject:userHangout];
                        
                        // Punish.
                        [BLUtility showErrorAlertWithTitle:@"Oh No..." andMessage:[NSString stringWithFormat:@"You're LATE for %@.\nWe're gonna post something funny on your Facebook as punishment!", hangout[kHangoutVenueKey][kVenueNameKey]]];
                        [BLUtility punish];
                    } else if ([userHangout[kUserHangoutStatusKey] isEqualToString:kUserHangoutStatusRequested]) {
                        // Set to Reject if the status is requested.
                        userHangout[kUserHangoutStatusKey] = kUserHangoutStatusReject;
                        [staleUserHangouts addObject:userHangout];
                    }
                }
            
                if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    hangoutStatus = userHangout[kUserHangoutStatusKey];
                }
            }
            
            if (staleUserHangouts.count > 0) {
                [PFObject saveAllInBackground:staleUserHangouts block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [cell setParticipantsAvatarFiles:avatarFiles andStatus:hangoutStatus];
                    }
                }];
            } else {
                [cell setParticipantsAvatarFiles:avatarFiles andStatus:hangoutStatus];
            }
        }
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    BLHangoutDetailViewController *hangoutDetailViewController = [[BLHangoutDetailViewController alloc] initWithUserHangout:self.objects[indexPath.row]];
    [self.navigationController pushViewController:hangoutDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BLHangoutCell cellHight];
}

#pragma mark - ()
- (void)createButtonAction:(id)sender {
    BLCreateHangoutViewController *createHangoutViewController = [BLCreateHangoutViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createHangoutViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)hangoutListNeedReload:(NSNotification *)note {
    [self loadObjects];
}


@end
