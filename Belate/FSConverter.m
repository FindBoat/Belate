//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        
        if ([v valueForKey:@"categories"] && [v[@"categories"] count] > 0) {
            ann.mainCategory = v[@"categories"][0][@"name"];
        }

        ann.location.address = v[@"location"][@"address"];
        if ([v[@"location"] valueForKey:@"city"]) {
            ann.location.city = v[@"location"][@"city"];
        }
        if ([v[@"location"] valueForKey:@"state"]) {
            ann.location.state = v[@"location"][@"state"];
        }
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                      [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}

@end
