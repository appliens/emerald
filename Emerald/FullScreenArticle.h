//
//  FullScreenArticle.h
//  Emerald
//
//  Created by ColtBoys on 12/27/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "ShareTools.h"
#import "LocalData.h"
#import "Tools.h"
@interface FullScreenArticle : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{
    IBOutlet UIWebView *webV;
    IBOutlet UIView *viewHeader;
    IBOutlet UILabel *lblTitle;
    ShareTools *sharing;
    IBOutlet UIActivityIndicatorView *loading;
}
@property (nonatomic,retain) NSDictionary *content;
-(IBAction)Back:(id)sender;
-(IBAction)More:(id)sender;
@end
