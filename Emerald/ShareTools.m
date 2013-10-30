//
//  ShareTools.m
//  Emerald
//
//  Created by ColtBoys on 12/26/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "ShareTools.h"
#import "Config.h"
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation ShareTools
-(void)ShowShareToolsInController:(UIViewController *)controller withMessage:(NSString *)message andUrl:(NSString *)url{
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=6) {
        
        NSArray *activityItems = @[message,url];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        [controller presentViewController:activityController animated:YES completion:nil];

    }
    else
    {
        _url = url;
        _message = message;
        _controller=controller;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[Config getStringShare] delegate:self cancelButtonTitle:[Config getStringCancel] destructiveButtonTitle:nil otherButtonTitles:@"Twitter",@"Facebook",@"Mail", nil];
        [actionSheet showFromTabBar:controller.tabBarController.tabBar];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        
        if ([TWTweetComposeViewController canSendTweet]) {
            TWTweetComposeViewController *twitterSharing = [[TWTweetComposeViewController alloc]init];
            [twitterSharing setInitialText:_message];
            [twitterSharing addURL:[NSURL URLWithString:_url]];
            [_controller presentViewController:twitterSharing animated:YES completion:nil];

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Config getStringTwitterAccountMissing]
                                                            message:[Config getStringTwitterAccountMissingMessage]
                                                           delegate:nil cancelButtonTitle:[Config getStringOK] otherButtonTitles:nil];
            [alert show];
        }
    } else if (buttonIndex==1){
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"fb://publish/profile/me?text=text"]]) {
            _message = [[NSString stringWithFormat:@"%@ %@",_message,_url]stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://publish/profile/me?text=%@",[[NSString stringWithFormat:@"%@",_message] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
            //NSLog(@"Val : %@",[[NSString stringWithFormat:@"fb://publish/profile/me?text=%@",[NSString stringWithFormat:@"%@ %@",_message,_url]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Config getStringFacebookAppMissing]
                                                            message:[Config getStringFacebookAppMissingMessage]
                                                           delegate:nil cancelButtonTitle:[Config getStringOK] otherButtonTitles:nil];
            [alert show];
        }
        
    } else if (buttonIndex==2){
        MFMailComposeViewController *controllerMail = [[MFMailComposeViewController alloc] init];
            [controllerMail setMessageBody:[NSString stringWithFormat:@"%@ \n%@",_message,_url] isHTML:YES];
        controllerMail.mailComposeDelegate = self;
        [_controller presentViewController:controllerMail animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[_controller becomeFirstResponder];
	[_controller dismissViewControllerAnimated:YES completion:nil];
}

//fb://publish
@end
