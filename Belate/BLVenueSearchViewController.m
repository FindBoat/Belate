//
//  BLVenueSearchViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/27/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLVenueSearchViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"

@interface BLVenueSearchViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSMutableArray *venues;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, weak) NSOperation *lastSearchOperation;

@property (nonatomic) BOOL loading;

@end

@implementation BLVenueSearchViewController

- (void)loadView {
    // Init TableView.
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Removes separator for empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Init search bar.
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.placeholder = @"Where shall you meet?";
    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsTableView.hidden = NO;
    
    self.view = self.tableView;
    
    self.loading = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    [self.searchController setActive:YES animated:YES];
    [self.searchController.searchBar becomeFirstResponder];

    // Add spinner when loading.
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    self.location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // This is a hack to hide "No Results" while loading.
    if (self.venues.count || !self.loading) {
        return self.venues.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VenueCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // When loading, we display an invisible cell to hide "No Results".
    if (!self.venues.count && self.loading) {
        cell.hidden = YES;
        return cell;
    }

    FSVenue *venue = self.venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@, %@", venue.mainCategory, venue.location.address, venue.location.city];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate venueSearchViewController:self didSelectVenue:self.venues[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self startSearchWithString:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startSearchWithString:(NSString *)searchText {
    self.loading = YES;
    [self.spinner startAnimating];
    
    // Append * if query is less than 3 letters.
    NSMutableString *query = [[NSMutableString alloc] initWithString:searchText];
    if (searchText.length < 3) {
        for (int i = 3 - (int)searchText.length; i > 0; --i) {
            [query appendString:@"*"];
        }
    }
    
    [self.lastSearchOperation cancel];
    
    self.lastSearchOperation = [Foursquare2 venueSuggestCompletionByLatitude:@(37.422293)
                                                                   longitude:@(-122.083954)
//    self.lastSearchOperation = [Foursquare2 venueSuggestCompletionByLatitude:@(self.location.coordinate.latitude)
//                                                                   longitude:@(self.location.coordinate.longitude)
                                                                        near:nil
                                                                  accuracyLL:nil
                                                                    altitude:nil
                                                                 accuracyAlt:nil
                                                                       query:query
                                                                       limit:nil
                                                                      radius:@(80000)
                                                                           s:nil
                                                                           w:nil
                                                                           n:nil
                                                                           e:nil
                                                                    callback:^(BOOL success, id result) {
                                                                        NSLog(@"%@", result);
                                                                        if (!success) {
                                                                            return;
                                                                        }
                                                                        NSDictionary *dic = result;
                                                                        NSArray *venues = [dic valueForKeyPath:@"response.minivenues"];
                                                                        FSConverter *converter = [[FSConverter alloc] init];
                                                                        self.venues = (NSMutableArray *)[converter convertToObjects:venues];
                                                                        self.loading = NO;

                                                                        [self.searchDisplayController.searchResultsTableView reloadData];

                                                                        [self.spinner stopAnimating];
                                                                    }];
}


@end
