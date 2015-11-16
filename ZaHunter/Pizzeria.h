//
//  Pizzeria.h
//  ZaHunter
//
//  Created by Paul Kitchener on 10/14/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Pizzeria : NSObject

@property NSString *pizzeriaName;
@property NSString *pizzeriaDistance;
@property CLLocation *pizzeriaLocation;
@property NSMutableArray *pizzerias;

@end
