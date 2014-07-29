//
//  BLFriendSelectViewController.h
//  Belate
//
//  Created by Hang Zhao on 7/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Parse/Parse.h>

@protocol BLFriendSelectViewControllerDelegate <NSObject>
- (void)friendSelectViewController:(id)controller didSelectFriends:(NSMutableArray *)friends;
@end

@interface BLFriendSelectViewController : PFQueryTableViewController

@property (nonatomic, weak) id<BLFriendSelectViewControllerDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style andSelectedUsers:(NSMutableArray *)selectedUsers;

@end
