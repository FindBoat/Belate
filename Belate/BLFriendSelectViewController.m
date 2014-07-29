//
//  BLFriendSelectViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLFriendSelectViewController.h"
#import "BLFriendCell.h"
#import "BLUtility.h"

@interface BLFriendSelectViewController ()

@property (nonatomic, copy) NSMutableArray *selectedUsers;
@property (nonatomic, copy) NSMutableSet *selectedUserIds;

@end

@implementation BLFriendSelectViewController

- (id)initWithStyle:(UITableViewStyle)style andSelectedUsers:(NSMutableArray *)selectedUsers {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = kFriendClassKey;
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = YES;
        
        if (selectedUsers) {
            _selectedUsers = [selectedUsers mutableCopy];
        } else {
            _selectedUsers = [NSMutableArray new];
        }
        
        _selectedUserIds = [NSMutableSet new];
        for (PFUser *user in _selectedUsers) {
            [_selectedUserIds addObject:user.objectId];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self initWithStyle:style andSelectedUsers:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Friends";
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
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (PFQuery *)queryForTable {
    PFQuery *fromQuery = [PFQuery queryWithClassName:kFriendClassKey];
    [fromQuery whereKey:kFriendStatusKey equalTo:kFriendStatusFriend];
    [fromQuery whereKey:kFriendFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *toQuery = [PFQuery queryWithClassName:kFriendClassKey];
    [toQuery whereKey:kFriendStatusKey equalTo:kFriendStatusFriend];
    [toQuery whereKey:kFriendToUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[fromQuery, toQuery]];
    [query includeKey:kFriendToUserKey];
    [query includeKey:kFriendFromUserKey];
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    BLFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BLFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:cellIdentifier];
    }
    
    PFUser *friend = [self friendFromFriendRelation:object];
    [cell setUser:friend];
    
    if ([self.selectedUserIds containsObject:friend.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *friendRelation = self.objects[indexPath.row];
    PFUser *selectedUser = [self friendFromFriendRelation:friendRelation];

    if (![self.selectedUserIds containsObject:selectedUser.objectId]) {
        [self.selectedUsers addObject:selectedUser];
        [self.selectedUserIds addObject:selectedUser.objectId];
    } else {
        [self.selectedUserIds removeObject:selectedUser.objectId];
        for (int i = 0; i < self.selectedUsers.count; ++i) {
            if ([((PFUser *)self.selectedUsers[i]).objectId isEqualToString:selectedUser.objectId]) {
                [self.selectedUsers removeObjectAtIndex:i];
                break;
            }
        }
    }
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BLFriendCell cellHight];
}

- (PFUser *)friendFromFriendRelation:(PFObject *)relation {
    NSString *fromId = [relation[kFriendFromUserKey] objectId];
    if (![fromId isEqualToString:[PFUser currentUser].objectId]) {
        return relation[kFriendFromUserKey];
    }
    return relation[kFriendToUserKey];
}

- (void)navCancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navDoneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate friendSelectViewController:self didSelectFriends:self.selectedUsers];
}

@end
