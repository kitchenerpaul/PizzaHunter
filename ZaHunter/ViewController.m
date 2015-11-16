//
//  ViewController.m
//  ZaHunter
//
//  Created by Paul Kitchener on 10/14/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "Pizzeria.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLLocation *destinationLocation;
@property Pizzeria *pizzeria;
@property NSMutableArray *pizzeriaNames;

@property double latitude;
@property double longitude;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    self.pizzeriaNames = [NSMutableArray new];
    self.pizzeria = [Pizzeria new];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;

    if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
        [self.locationManager stopUpdatingLocation];
        [self findPizzeriasNearby:location];
        self.currentLocation = location;
    }
}

-(void)findPizzeriasNearby:(CLLocation *)location {

    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mapItems = response.mapItems;
        NSLog(@"mapItems: %@", mapItems);
        [self savePizzeriaArray:mapItems];
    }];
}

-(void)savePizzeriaArray:(NSArray *)inputArray {
    self.pizzeriaNames = [NSMutableArray arrayWithArray:inputArray];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pizzeriaNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PizzaCellID"];
    self.pizzeria.pizzeriaName = [[self.pizzeriaNames objectAtIndex:indexPath.row]valueForKey:@"name"];
//    self.pizzeria.pizzeriaDistance = [NSString stringWithFormat:@"%f", [self.currentLocation distanceFromLocation:[[self.pizzeriaNames objectAtIndex:indexPath.row]valueForKey:@"center"]]];
    cell.textLabel.text = self.pizzeria.pizzeriaName;
    cell.detailTextLabel.text = self.pizzeria.pizzeriaDistance;
    return cell;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location manager error %@", error);
}

@end