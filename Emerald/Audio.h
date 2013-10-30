//
//  Audio.h
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTools.h"
#import "AudioDataManager.h"
#import "FullScreenArticle.h"
#import "LocalData.h"
#import "ODRefreshControl.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface Audio : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,AudioDataManagerDelegate,UIScrollViewDelegate>{
    IBOutlet UITableView *tableV;
    IBOutlet UILabel *lblTitleNav;
    IBOutlet UIView *viewHeader;
    NSMutableArray *dataTable;
    ShareTools *sharing;
    AudioDataManager *feedLoader;
    BOOL isHeaderHidden;
    ODRefreshControl *refreshControl;
    UIActivityIndicatorView *loading;
    BOOL isCurrentViewPlaying;
    AppDelegate *deleg;
    UIView *viewNetworkError;
}
@property (nonatomic,retain) NSString *XMLsource;
@property (nonatomic,retain) UIView *CurrentPlayingView;
@property (nonatomic,assign) int IndexPlaying;
-(void)ReloadData;
@end
