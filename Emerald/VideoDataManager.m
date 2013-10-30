//
//  VideoDataManager.m
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "VideoDataManager.h"
#import "Tools.h"
@implementation VideoDataManager
@synthesize delegate;
@synthesize UrlSource;
-(void)RefreshInfo{
    if ([Tools isNetWorkConnectionAvailable]) {
        if ([self.UrlSource rangeOfString:@"youtube"].location == NSNotFound) {
            if ([self.UrlSource rangeOfString:@"vimeo"].location == NSNotFound){
                
                ClassicVideo *classic = [[ClassicVideo alloc]init];
                classic.delegate=self;
                classic.url=self.UrlSource;
                [classic RefreshInfo];
                
            } else{
                Vimeo *vimeo = [[Vimeo alloc]init];
                vimeo.delegate=self;
                vimeo.url=self.UrlSource;
                [vimeo RefreshInfo];
            }
        } else {
            Youtube *yt = [[Youtube alloc]init];
            yt.delegate=self;
            yt.url=self.UrlSource;
            [yt RefreshInfo];
            
        }
    }
    else
    {
        [Tools DisplayNetworkAlert];
        [delegate VideoDataManagerDidReceivedNetWorkError];
    }
}
#pragma mark Delegates
-(void)YoutubeDidFailToLoadInfo:(NSError *)error{
    [delegate VideoDataManagerFailedToLoadInfo:error];
}
-(void)YoutubeDidLoadInfo:(NSMutableArray *)data{
    [delegate VideoDataManagerDidLoadInfo:data];
}
-(void)VimeoDidFailToLoadInfo:(NSError *)error{
    [delegate VideoDataManagerFailedToLoadInfo:error];
}
-(void)VimeoDidLoadInfo:(NSMutableArray *)data{
    [delegate VideoDataManagerDidLoadInfo:data];
}
-(void)ClassicVideoDidFailToLoadInfo:(NSError *)error{
    [delegate VideoDataManagerFailedToLoadInfo:error];
}
-(void)ClassicVideoDidLoadInfo:(NSMutableArray *)data{
    [delegate VideoDataManagerDidLoadInfo:data];
}
@end
