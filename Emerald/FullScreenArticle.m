//
//  FullScreenArticle.m
//  Emerald
//
//  Created by ColtBoys on 12/27/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "FullScreenArticle.h"
#import "Config.h"
@interface FullScreenArticle ()

@end

@implementation FullScreenArticle
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
    NSString * htmlString;
    if ([[self.content objectForKey:@"image"]length]!=0 && [self.content objectForKey:@"cover-not-active"]==nil) {
        htmlString = [NSString stringWithFormat:@" <html><head>\
                                 <style type=\"text/css\">\
                                 body {\
                                 background-color: white;\
                                 color: %@;\
                                 font-family:%@;\
                                 font-size:%f;\
                                 width:%fpx;\
                                 }\
                                 img {\
                                 max-width:%fpx;\
                                 margin-top:3px;\
                                 height: auto;\
                                 }\
                                 iframe{\
                                 max-width:%fpx;\
                                 }\
                                 h2{\
                                 max-width:%fpx;\
                                 margin-left:5px;\
                                 }\
                                 </style>\
                                 </head><body style=\"margin:3;max-width:%f\"> \
                                 <br>\
                                 <h2>%@</h2><center><img src=\"%@\" border=\"1\"><p style=\"margin-bottom:10px;font-size:10;font-color:grey;\">%@</p></center>\
                                 %@<br>\
                                 </body></html>",[Config getFeedArticleTextColorString],[Config getFeedFontString],[Config getFeedArticleSize],webV.frame.size.width,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-6,[self.content objectForKey:@"title"],[self.content objectForKey:@"image"],[[Config getStringPublishedOn] stringByAppendingString:[self.content objectForKey:@"date"]],[self.content objectForKey:@"description"]];
    }
    else
    {
        htmlString = [NSString stringWithFormat:@" <html><head>\
                      <style type=\"text/css\">\
                      body {\
                      background-color: white;\
                      color: %@;\
                      font-family:%@;\
                      font-size:%f;\
                      width:%fpx;\
                      }\
                      img {\
                      max-width:%fpx;\
                      margin-top:3px;\
                      height: auto;\
                      }\
                      iframe{\
                      max-width:%fpx;\
                      }\
                      h2{\
                      max-width:%fpx;\
                      margin-left:5px;\
                      }\
                      p{\
                      max-width:%fpx;\
                      }\
                      </style>\
                      </head><body style=\"margin:3;max-width:%f\"> \
                      <br>\
                      <h2>%@</h2>\
                      <center></center>\
                      <br>%@<br><p style=\"margin-bottom:10px;font-size:10;font-color:grey;\">%@</p><br>\
                      </body></html>",[Config getFeedArticleTextColorString],[Config getFeedFontString],[Config getFeedArticleSize],webV.frame.size.width,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-6,webV.frame.size.width-6,[self.content objectForKey:@"title"],[self.content objectForKey:@"description"],[[Config getStringPublishedOn] stringByAppendingString:[self.content objectForKey:@"date"]]];
    }
    if (![Tools isNetWorkConnectionAvailable]) {
        htmlString= [NSString stringWithFormat:@" <html><head>\
                     <style type=\"text/css\">\
                     body {\
                     background-color: white;\
                     color: %@;\
                     font-family:%@;\
                     font-size:%f;\
                     width:%fpx;\
                     }\
                     img {\
                     max-width:%fpx;\
                     margin-top:3px;\
                     height: auto;\
                     }\
                     iframe{\
                     max-width:%fpx;\
                     }\
                     h2{\
                     max-width:%fpx;\
                     margin-left:5px;\
                     }\
                     p{\
                     max-width:%fpx;\
                     }\
                     </style>\
                     </head><body style=\"margin:3;max-width:%f\"> \
                     <br>\
                     <h2>%@</h2>\
                     <center></center>\
                     <br>%@<br><p style=\"margin-bottom:10px;font-size:10;font-color:grey;\">%@</p><br>\
                     </body></html>",[Config getFeedArticleTextColorString],[Config getFeedFontString],[Config getFeedArticleSize],webV.frame.size.width,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-10,webV.frame.size.width-6,webV.frame.size.width-6,[self.content objectForKey:@"title"],[Tools flattenHTML:[self.content objectForKey:@"description"]],[[Config getStringPublishedOn] stringByAppendingString:[self.content objectForKey:@"date"]]];
    }
    [webV loadHTMLString:htmlString baseURL:nil];
    lblTitle.text = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:self.tabBarController.selectedIndex]componentsSeparatedByString:@"/"]objectAtIndex:1];
    lblTitle.font = [Config getMainFont];
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
    if ([Config isFavouritesEnabled]) {
        NSString *favStr;
        if ([LocalData isArticleFav:[self.content objectForKey:@"link"]]) {
            favStr = [Config getStringRemoveFromList];
        }
        else
        {
            favStr = [Config getStringReadItLater];
        }
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:[Config getStringCancel] destructiveButtonTitle:nil otherButtonTitles:favStr,[Config getStringShare], nil];
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        [self ShareContent];
    }
    
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
    [sharing ShowShareToolsInController:self withMessage:[NSString stringWithFormat:@"%@ %@",[Config getFeedSharingMessage],[self.content objectForKey:@"title"]] andUrl:[self.content objectForKey:@"link"]];
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
