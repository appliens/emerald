//
//  MoreDetails-General.m
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "MoreDetails-General.h"
#import "Config.h"

@interface MoreDetails_General ()

@end

@implementation MoreDetails_General
@synthesize infos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = [[self.infos componentsSeparatedByString:@"#"]lastObject];
    lblTitle.font = [Config getMainFont];
    
    if ([[[self.infos componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"map"]) {
        theMap.hidden=NO;
        txtView.hidden=YES;
        CLLocationCoordinate2D location;
        location.latitude = [[[[[self.infos componentsSeparatedByString:@"#"]objectAtIndex:1]componentsSeparatedByString:@","]objectAtIndex:0]floatValue];
        location.longitude = [[[[[self.infos componentsSeparatedByString:@"#"]objectAtIndex:1]componentsSeparatedByString:@","]objectAtIndex:1]floatValue];
        // Add the annotation to our map view
        newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[[self.infos componentsSeparatedByString:@"#"]objectAtIndex:2] andCoordinate:location];
        [theMap addAnnotation:newAnnotation];
    }
    else
    {
        theMap.hidden=YES;
        theMap.delegate=nil;
        [theMap removeFromSuperview];
        theMap=nil;
        
        txtView.hidden=NO;
        txtView.text = [[self.infos componentsSeparatedByString:@"#"]objectAtIndex:1];
        txtView.textColor = [Config getMoreTextColor];
        txtView.font = [Config getMoreFont];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)Back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark MapKit protocol
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}
@end
