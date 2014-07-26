//
//  BLHangoutListViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/24/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLHangoutListViewController.h"
#import "BLBlankHangoutListView.h"
#import "BLUtility.h"

@interface BLHangoutListViewController()

@property (nonatomic, strong) BLBlankHangoutListView *blankView;

@end

@implementation BLHangoutListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = kHangoutClassKey;
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Belate";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    
    UIBarButtonItem *navCreateButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(save_Clicked:)];
    self.navigationItem.rightBarButtonItem = navCreateButton;
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.blankView = [[BLBlankHangoutListView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = self.blankView;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[kHangoutLocationKey];
    cell.detailTextLabel.text = @"12312312";
    
    return cell;
}

@end
