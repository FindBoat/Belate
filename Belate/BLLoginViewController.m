//
//  BLLoginViewController.m
//  Belate
//
//  Created by Hang Zhao on 7/17/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLLoginView.h"
#import "BLUtility.h"
#import "BLHangoutListViewController.h"

@interface BLLoginViewController () {
    NSMutableData *_data;
}

@property (nonatomic, strong) BLLoginView *loginView;

@end

@implementation BLLoginViewController

- (void)loadView {
    self.navigationItem.title = @"Belate";
    self.navigationController.navigationBar.barTintColor = [BLUtility colorWithHexString:kMainColor];
    self.loginView = [[BLLoginView alloc] initWithFrame:CGRectZero];
    self.view = self.loginView;
    
    [self.loginView.fbLoginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button
- (void)loginButtonAction:(id)sender {
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
        if (user) {
            [FBRequestConnection startWithGraphPath:@"me/?fields=name,id,picture"
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      if (!error) {
                                          NSString *facebookId = [result objectForKey:@"id"];
                                          NSString *facebookName = [result objectForKey:@"name"];

                                          PFUser *user = [PFUser currentUser];
                                          user[kUserNameKey] = facebookName;
                                          user[kUserFacebookIdKey] = facebookId;
                                          [user saveEventually];
                                          
                                          // Refresh user's profile photo.
                                          NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kUserFacebookIdKey]]];
                                          // Facebook profile picture cache policy: Expires in 2 weeks
                                          NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];                                           [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];                                          
                                      }
                                  }];
            
            [BLUtility refreshFacebookFriends];
            
            BLHangoutListViewController *hangoutListViewController = [BLHangoutListViewController new];
            [self.navigationController pushViewController:hangoutListViewController animated:YES];
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [BLUtility processFacebookProfilePictureData:_data];
}





@end
