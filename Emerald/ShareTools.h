//
//  ShareTools.h
//  Emerald
//
//  Created by ColtBoys on 12/26/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface ShareTools : NSObject <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    NSString * _url,* _message;
    UIViewController *_controller;
}
-(void)ShowShareToolsInController:(UIViewController *)controller withMessage:(NSString *)message andUrl:(NSString *)url;
@end
