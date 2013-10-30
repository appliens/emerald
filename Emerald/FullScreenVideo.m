//
//  FullScreenVideo.m
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "FullScreenVideo.h"

@interface FullScreenVideo ()

@end

@implementation FullScreenVideo
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
    isTabBarHidden=NO;
    isVideoControllerLaunched=NO;
    deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [LocalData addArticleToMemory:[content objectForKey:@"link"]];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        webV.frame = CGRectMake(webV.frame.origin.x, webV.frame.origin.y, webV.frame.size.width, self.view.frame.size.height-webV.frame.origin.y);
    }
    else
    {
        webV.frame = CGRectMake(webV.frame.origin.x, webV.frame.origin.y, webV.frame.size.width, self.view.frame.size.height-webV.frame.origin.y-88);
    }
    loading.center = webV.center;
    webVLandscape = [[UIWebView alloc]init];
    webVLandscape.alpha=0;
    [self.view addSubview:webVLandscape];
    if([UIScreen mainScreen].bounds.size.height < 568){
        webVLandscape.frame = CGRectMake(0, 0, 480, 320);
    }
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        webVLandscape.frame = CGRectMake(0, 0, 568, 320);
    }
    webVLandscape.delegate=self;
    webVLandscape.hidden=YES;
    
    [loading setColor:[Config getMainColor]];
    if ([[self.content objectForKey:@"type"]isEqualToString:@"vimeo"]) {
        [webV loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> <iframe src=\"http://player.vimeo.com/video/%@?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1\" width=\"%f\" height=\"%f\" frameborder=\"0\"> </body></html>",[self.content objectForKey:@"embed"],webV.frame.size.width,webV.frame.size.height] baseURL:nil];
        [webVLandscape loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> <iframe src=\"http://player.vimeo.com/video/%@?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1\" width=\"%f\" height=\"%f\" frameborder=\"0\"> </body></html>",[self.content objectForKey:@"embed"],webVLandscape.frame.size.width,webVLandscape.frame.size.height] baseURL:nil];
        
    } else if ([[self.content objectForKey:@"type"]isEqualToString:@"youtube"]){
        [webV loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> <iframe width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen></iframe> </body></html>",webV.frame.size.width,webV.frame.size.height,[self.content objectForKey:@"embed"]] baseURL:nil];
        [webVLandscape loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> <iframe width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen></iframe> </body></html>",webVLandscape.frame.size.width,webVLandscape.frame.size.height,[self.content objectForKey:@"embed"]] baseURL:nil];
    } else{
        [webV loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              iframe {\
                              width:%f;\
                              height:%f;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> %@ </body></html>",webV.frame.size.width,webV.frame.size.height,[self.content objectForKey:@"embed"]] baseURL:nil];
        [webVLandscape loadHTMLString:[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              body {\
                              background-color: black;\
                              color: black;\
                              }\
                              iframe {\
                              width:%f;\
                              height:%f;\
                              }\
                              </style>\
                              </head><body style=\"margin:0\"> %@ </body></html>",webVLandscape.frame.size.width,webVLandscape.frame.size.height,[self.content objectForKey:@"embed"]] baseURL:nil];
    }
    lblTitle.text = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:self.tabBarController.selectedIndex]componentsSeparatedByString:@"/"]objectAtIndex:1];
    lblTitle.font = [Config getMainFont];
    webV.alpha=0;
    [loading startAnimating];
    //Landscape
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieIsPlaying:)
												 name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieStopedPlaying:)
												 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    deleg.isVideoPlaying=YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    if (!isVideoControllerLaunched) {
        deleg.isVideoPlaying=NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)Back:(id)sender{
    deleg.isVideoPlaying=NO;
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
    [sharing ShowShareToolsInController:self withMessage:[NSString stringWithFormat:@"%@ %@",[Config getVideoSharingMessage],[self.content objectForKey:@"title"]] andUrl:[self.content objectForKey:@"link"]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webV==webView) {
        [loading stopAnimating];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (webV==webView) {
        [loading stopAnimating];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}
#pragma mark Autorotation implementation
- (void)movieIsPlaying:(NSNotification *)notification
{
    isVideoControllerLaunched=YES;
    needAudioBack = deleg.streamer.isPlaying;
    if (needAudioBack) {
        [deleg.streamer pause];
    }
}
- (void)movieStopedPlaying:(NSNotification *)notification
{
    isVideoControllerLaunched=NO;
    if (needAudioBack) {
        [deleg.streamer start];
        needAudioBack=NO;
    }
}
- (void)didRotate:(NSNotification *)notification {
    if (deleg.isVideoPlaying) {
        UIDeviceOrientation orientation = [[notification object] orientation];
        if (orientation==3 || orientation==4) {
            webVLandscape.hidden=NO;
            [self HideTabBar];
        }
        else if (orientation==1){
            webVLandscape.hidden=YES;
            [self ShowTabBar];
        }
    }
}
-(void)HideTabBar{
    if (!isTabBarHidden) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        for(UIView *view in self.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                if ([UIScreen mainScreen].bounds.size.height == 568) {
                    [view setFrame:CGRectMake(view.frame.origin.x, 568, view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
                }

            }
            else
            {
                if ([UIScreen mainScreen].bounds.size.height == 568) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 568)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
                }
                
            }
        }
        
        [UIView commitAnimations];
        isTabBarHidden=YES;
    }
}
-(void)ShowTabBar{
    if (isTabBarHidden) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        for(UIView *view in self.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                if ([UIScreen mainScreen].bounds.size.height == 568) {
                    [view setFrame:CGRectMake(view.frame.origin.x, 519, view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
                }
                
                
            }
            else
            {
                if ([UIScreen mainScreen].bounds.size.height == 568) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 519)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
                }
            }
        }
        
        [UIView commitAnimations];
        isTabBarHidden=NO;
    }
    
}
@end
