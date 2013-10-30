//
//  More.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2012 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "More-Favorites.h"
@interface More : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>{
    IBOutlet UITableView *tableV;
    IBOutlet UILabel *lblTitleNav;
    IBOutlet UIView *viewHeader;
    NSMutableArray *dataTable;
    BOOL isHeaderHidden;
}
@property (nonatomic,retain) NSString *DataSource;

@end
