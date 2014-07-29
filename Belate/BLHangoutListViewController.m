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
                                        action:@selector(createButtonAction:)];
    self.navigationItem.rightBarButtonItem = navCreateButton;
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.blankView = [[BLBlankHangoutListView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView.createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];

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
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[kHangoutLocationNameKey];
    cell.detailTextLabel.text = @"12312312";
    
    return cell;
}

#pragma mark - BLCreateHangoutViewControllerDelegate
- (void)createHangoutViewController:(id)controller didCreateHangout:(PFObject *)hangout {
    [self loadObjects];
}


#pragma mark - ()
- (void)createButtonAction:(id)sender {
    BLCreateHangoutViewController *createHangoutViewController = [BLCreateHangoutViewController new];
    createHangoutViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createHangoutViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
