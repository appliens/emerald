//
//  PhotoDataManager.m
//  Emerald
//
//  Created by ColtBoys on 1/2/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "PhotoDataManager.h"
#import "Tools.h"
@implementation PhotoDataManager
@synthesize delegate;
@synthesize UrlSource;
-(void)RefreshInfo{
    if ([Tools isNetWorkConnectionAvailable]) {
        if ([self.UrlSource rangeOfString:@"flickr"].location == NSNotFound) {
            if ([self.UrlSource rangeOfString:@"pinterest"].location == NSNotFound){
               
                ClassicPicture *classic = [[ClassicPicture alloc]init];
                classic.delegate=self;
                classic.url=self.UrlSource;
                [classic RefreshInfo];

            } else{
                Pinterest *pinterest = [[Pinterest alloc]init];
                pinterest.delegate=self;
                pinterest.url=self.UrlSource;
                [pinterest LoadData];
                }
        } else {
            Flickr *flickr = [[Flickr alloc]init];
            flickr.delegate=self;
            flickr.url=self.UrlSource;
            [flickr RefreshInfo];

        }
    }
    else
    {
        [Tools DisplayNetworkAlert];
        [delegate PhotoDataManagerDidReceivedNetWorkError];
    }
}
#pragma mark Delegates
-(void)FlickrDidFailToLoadInfo:(NSError *)error{
    [delegate PhotoDataManagerFailedToLoadInfo:error];
}
-(void)FlickrDidLoadInfo:(NSMutableArray *)data{
    [delegate PhotoDataManagerDidLoadInfo:data];
}
-(void)PinterestDidFailToLoadInfo:(NSError *)error{
    [delegate PhotoDataManagerFailedToLoadInfo:error];
}
-(void)PinterestDidLoadInfo:(NSMutableArray *)data{
    [delegate PhotoDataManagerDidLoadInfo:data];
}
-(void)ClassicPictureDidFailToLoadInfo:(NSError *)error{
    [delegate PhotoDataManagerFailedToLoadInfo:error];
}
-(void)ClassicPictureDidLoadInfo:(NSMutableArray *)data{
    [delegate PhotoDataManagerDidLoadInfo:data];
}
@end
