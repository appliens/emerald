//
//  MapViewAnnotation.m
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation
@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	title = ttl;
	coordinate = c2d;
	return self;
}
@end
