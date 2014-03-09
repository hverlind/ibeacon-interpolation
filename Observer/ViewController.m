//
//  ViewController.m
//  Observer
//
//  Created by Hannes Verlinde on 08/03/14.
//  Copyright (c) 2014 In the Pocket. All rights reserved.
//

@import CoreLocation;

#import "ViewController.h"
#import "View.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"38DC5592-CC7E-4E5E-BCC1-B0817D5F5E45"];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"My region"];

    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    [manager startMonitoringForRegion:region];
    [manager requestStateForRegion:region];
    self.manager = manager;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        NSLog(@"INSIDE");
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"ENTER");
    [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"EXIT");
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        NSLog(@"%@ %@ %@ %ld %f",
              beacon.major,
              beacon.minor,
              @[@"Unknown", @"Immediate", @"Near", @"Far"][beacon.proximity],
              beacon.rssi,
              beacon.accuracy);
        [(View*)self.view setAccuracy:beacon.accuracy forBeacon:beacon.minor];
    }
}

@end
