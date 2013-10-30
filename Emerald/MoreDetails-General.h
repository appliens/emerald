//
//  MoreDetails-General.h
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
@interface MoreDetails_General : UIViewController{
    IBOutlet UILabel *lblTitle;
    IBOutlet MKMapView *theMap;
    IBOutlet UITextView *txtView;
    MapViewAnnotation *newAnnotation;
}
@property (nonatomic,retain) NSString *infos;
-(IBAction)Back:(id)sender;
@end
