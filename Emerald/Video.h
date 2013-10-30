//
//  Video.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTools.h"
#import "VideoDataManager.h"
#import "LocalData.h"
#import "ODRefreshControl.h"
#import "FullScreenVideo.h"
@interface Video : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,VideoDataManagerDelegate,UIScrollViewDelegate>{
    IBOutlet UITableView *tableV;
    IBOutlet UILabel *lblTitleNav;
    IBOutlet UIView *viewHeader;
    NSMutableArray *dataTable;
    ShareTools *sharing;
    VideoDataManager *feedLoader;
    BOOL isHeaderHidden;
    ODRefreshControl *refreshControl;
    UIActivityIndicatorView *loading;
    UIView *viewNetworkError;
}
@property (nonatomic,retain) NSString *XMLsource;
@end
