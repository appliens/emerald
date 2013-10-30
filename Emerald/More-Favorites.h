//
//  More-Favorites.h
//  Emerald
//
//  Created by ColtBoys on 1/24/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTools.h"
#import "FullScreenArticle.h"
#import "LocalData.h"
#import "ODRefreshControl.h"
@interface More_Favorites : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>{
    IBOutlet UITableView *tableV;
    IBOutlet UILabel *lblTitleNav;
    IBOutlet UIView *viewHeader;
    NSMutableArray *dataTable;
    ShareTools *sharing;
    BOOL isHeaderHidden;
    ODRefreshControl *refreshControl;
    UIActivityIndicatorView *loading;
    UIView *viewFavError;
}
@property (nonatomic,retain) NSString *stringTitle;
-(IBAction)Back:(id)sender;
@end
