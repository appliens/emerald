//
//  FullScreenPhoto.m
//  Emerald
//
//  Created by ColtBoys on 1/2/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "FullScreenPhoto.h"

@interface FullScreenPhoto ()

@end

@implementation FullScreenPhoto
@synthesize content;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [LocalData addArticleToMemory:[content objectForKey:@"link"]];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        webV.frame = CGRectMake(webV.frame.origin.x, webV.frame.origin.y, webV.frame.size.width, self.view.frame.size.height-webV.frame.origin.y);
    }
    else
    {
        webV.frame = CGRectMake(webV.frame.origin.x, webV.frame.origin.y, webV.frame.size.width, self.view.frame.size.height-webV.frame.origin.y-88);
    }
    loading.center = webV.center;
    [loading setColor:[Config getMainColor]];
    [webV loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                          <style type=\"text/css\">\
                          body {\
                          background-color: black;\
                          color: black;\
                          }\
                          img {\
                          width:%fpx;\
                          align:left;\
                          margin-left:-8px;\
                          margin-top:-18px;\
                          margin-bottom:-10px\
                          }\
                          </style>\
                          </head><body> \
                          <center><img src=\"%@\"></center>\
                          </body></html>",webV.frame.size.width,[self.content objectForKey:@"image"]] baseURL:nil];
    lblTitle.text = [[self.content objectForKey:@"title"]stringByReplacingOccurrencesOfString:@" " withString:@""];
    lblTitle.font = [Config getMainFont];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    webV.alpha=0;
    [loading startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)Back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)More:(id)sender{
    [self ShareContent];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [LocalData addAFav:self.content];
    }
    else if (buttonIndex==1){
        [self ShareContent];
    }
}
-(void)ShareContent{
    sharing=nil;
    sharing = [[ShareTools alloc]init];
    [sharing ShowShareToolsInController:self withMessage:[NSString stringWithFormat:@"%@ %@",[Config getPhotoSharingMessage],[self.content objectForKey:@"title"]] andUrl:[self.content objectForKey:@"link"]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [loading stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [loading stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}

@end
