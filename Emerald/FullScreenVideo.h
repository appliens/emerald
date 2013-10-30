//
//  FullScreenVideo.h
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "ShareTools.h"
#import "LocalData.h"
#import "AppDelegate.h"
@interface FullScreenVideo : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{
    IBOutlet UIWebView *webV;
    IBOutlet UIWebView *webVLandscape;
    IBOutlet UIView *viewHeader;
    IBOutlet UILabel *lblTitle;
    ShareTools *sharing;
    IBOutlet UIActivityIndicatorView *loading;
    AppDelegate *deleg;
    BOOL isTabBarHidden;
    BOOL needAudioBack;
    BOOL isVideoControllerLaunched;
}
@property (nonatomic,retain) NSDictionary *content;
-(IBAction)Back:(id)sender;
-(IBAction)More:(id)sender;
@end
