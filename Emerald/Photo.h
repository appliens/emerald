//
//  Photo.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTools.h"
#import "PhotoDataManager.h"
#import "FullScreenPhoto.h"
#import "LocalData.h"
#import "ODRefreshControl.h"
@interface Photo : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,PhotoDataManagerDelegate,UIScrollViewDelegate>{
    IBOutlet UITableView *tableV;
    IBOutlet UILabel *lblTitleNav;
    IBOutlet UIView *viewHeader;
    NSMutableArray *dataTable;
    ShareTools *sharing;
    PhotoDataManager *feedLoader;
    BOOL isHeaderHidden;
    ODRefreshControl *refreshControl;
    UIActivityIndicatorView *loading;
    UIView *viewNetworkError;
}
@property (nonatomic,retain) NSString *XMLsource;
@end
