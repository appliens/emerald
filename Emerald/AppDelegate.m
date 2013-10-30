//
//  AppDelegate.m
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "AppDelegate.h"
#import "News.h"
#import "Photo.h"
#import "Video.h"
#import "More.h"
#import "Config.h"
@implementation AppDelegate
@synthesize streamer;
@synthesize isVideoPlaying;
@synthesize streamerView;
@synthesize CurrentAudioControllerIndex;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.isVideoPlaying=NO;
    self.CurrentAudioControllerIndex=-1;
    feed=pic=vid=more=audio=0;
    //Controllers
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
    
    NSMutableArray *arrayControllers = [[NSMutableArray alloc]init];
    int max=5;
    if ([[[Config getTabControllers]componentsSeparatedByString:@","]count]<5) {
        max=[[[Config getTabControllers]componentsSeparatedByString:@","]count];
    }
    for (int i=0; i<max; i++) {
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[self getControllerForIndex:i]];
        navController.navigationBarHidden=YES;
        [arrayControllers addObject:navController];
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [[NSArray alloc] initWithArray:arrayControllers];
    //NSLog(@"Count : %d",self.tabBarController.viewControllers.count);
    
    for (int i=0; i<self.tabBarController.tabBar.items.count; i++) {
        [(UITabBarItem*)[self.tabBarController.tabBar.items objectAtIndex:i] setTitle:[self getTabBarTitleAtIndex:i]];
        [(UITabBarItem*)[self.tabBarController.tabBar.items objectAtIndex:i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d.png",i+1]]];
    }
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (NSString *)getTabBarTitleAtIndex:(int)index{
    NSString *result = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:index]componentsSeparatedByString:@"/"]objectAtIndex:1];
    return result;
}
- (UIViewController *)getControllerForIndex:(int)index{
    UIViewController *result;
    NSString *currentStr = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:index]componentsSeparatedByString:@"/"]objectAtIndex:0];
    if ([currentStr isEqualToString:@"feed"]) {
        News *tempC = [[News alloc]init];
        if (feed>=[[[Config getFeedUrl]componentsSeparatedByString:@","]count]) {
            tempC.XMLsource = [[[Config getFeedUrl]componentsSeparatedByString:@","]lastObject];
        }
        else
        {
            tempC.XMLsource = [[[Config getFeedUrl]componentsSeparatedByString:@","]objectAtIndex:feed];
        }
        result = tempC;
        feed=feed+1;
    } else if ([currentStr isEqualToString:@"photo"]){
        Photo *tempC = [[Photo alloc]init];
        if (pic>=[[[Config getPhotoUrl]componentsSeparatedByString:@","]count]) {
            tempC.XMLsource = [[[Config getPhotoUrl]componentsSeparatedByString:@","]lastObject];
        }
        else
        {
            tempC.XMLsource = [[[Config getPhotoUrl]componentsSeparatedByString:@","]objectAtIndex:pic];
        }
        result = tempC;
        pic=pic+1;
    } else if ([currentStr isEqualToString:@"video"]){
        Video *tempC = [[Video alloc]init];
        if (vid>=[[[Config getVideoUrl]componentsSeparatedByString:@","]count]) {
            tempC.XMLsource = [[[Config getVideoUrl]componentsSeparatedByString:@","]lastObject];
        }
        else
        {
            tempC.XMLsource = [[[Config getVideoUrl]componentsSeparatedByString:@","]objectAtIndex:vid];
        }
        result = tempC;
        vid=vid+1;
    } else if ([currentStr isEqualToString:@"more"]){
        More *tempC = [[More alloc]init];
        if (more>=[[[Config getMoreCellString]componentsSeparatedByString:@"|"]count]) {
            tempC.DataSource = [[[Config getMoreCellString]componentsSeparatedByString:@"|"]lastObject];
        }
        else
        {
            tempC.DataSource = [[[Config getMoreCellString]componentsSeparatedByString:@"|"]objectAtIndex:more];
        }
        result = tempC;
        more=more+1;
    } else if ([currentStr isEqualToString:@"audio"]){
        Audio *tempC = [[Audio alloc]init];
        if (audio>=[[[Config getAudioUrl]componentsSeparatedByString:@","]count]) {
            tempC.XMLsource = [[[Config getAudioUrl]componentsSeparatedByString:@","]lastObject];
        }
        else
        {
            tempC.XMLsource = [[[Config getAudioUrl]componentsSeparatedByString:@","]objectAtIndex:audio];
        }
        result = tempC;
        audio=audio+1;
    }
    return result;
}
#pragma mark Audio Streaming Implementation
- (void)AudioStreamContent:(NSDictionary *)infos withView:(UIView *)StreamingView andControllerIndex:(int)index andController:(Audio *)controller{
    if (streamer!=nil) {
        [streamer stop];
        streamer = nil;
    }
    if ([timerPlayer isValid]) {
        [timerPlayer invalidate];
    }
    self.streamerView=StreamingView;
    if (self.CurrentAudioControllerIndex!=-1 && self.CurrentAudioControllerIndex!=index) {
        CurrentController.IndexPlaying=-1;
        [CurrentController ReloadData];
    }
    self.CurrentAudioControllerIndex=index;
    CurrentController=controller;
    streamerDict = infos;
    
    streamer = [[AudioStreamer alloc]initWithURL:[NSURL URLWithString:[[[streamerDict objectForKey:@"urlSource"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    
    loading = (UIActivityIndicatorView *)[self.streamerView viewWithTag:14];
    lblTimeLeft = (UILabel *)[self.streamerView viewWithTag:7];
    lblTimeLeft.text=@"";
    lblTimeEllasped = (UILabel *)[self.streamerView viewWithTag:6];
    lblTimeEllasped.text=@"";
    slider = (UIProgressView *)[self.streamerView viewWithTag:5];
    slider.progress = 0;
    [streamer start];
}
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
        [loading startAnimating];
        lblTimeLeft.hidden=YES;
        lblTimeEllasped.hidden=YES;
        slider.hidden=YES;
        if ([timerPlayer isValid]) {
            [timerPlayer invalidate];
        }
	}
	else if ([streamer isPlaying])
	{
        lblTimeLeft.hidden=NO;
        lblTimeEllasped.hidden=NO;
        slider.hidden=NO;
        
        if (streamer.duration==0) {
            slider.alpha=0;
            lblTimeLeft.alpha=0;
            lblTimeEllasped.alpha=0;
            [loading startAnimating];
        }
        else
        {
            [loading stopAnimating];
            slider.alpha=1;
            lblTimeLeft.alpha=1;
            lblTimeEllasped.alpha=1;
            if (![timerPlayer isValid]) {
                timerPlayer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(TimerUpdateSong) userInfo:nil repeats:YES];
            }
        }
        if (![LocalData isArticleHasBeenSeen:[streamerDict objectForKey:@"link"]]) {
            [LocalData addArticleToMemory:[streamerDict objectForKey:@"link"]];
        }
		
	} else if ([streamer isPaused]){
        if ([timerPlayer isValid]) {
            [timerPlayer invalidate];
        }
        [loading stopAnimating];
        
    } else if ([streamer isIdle]){
        CurrentController.IndexPlaying=-1;
        [CurrentController ReloadData];
    }
}
-(void)TimerUpdateSong{
    int minute = 0;
    int seconds = 0;
    int minuteLeft = 0;
    int secondsLeft = 0;
    if (streamer.progress>60) {
        minute=streamer.progress/60;
    }
    seconds = streamer.progress-minute*60;
    if (streamer.duration>60) {
        minuteLeft = (streamer.duration-streamer.progress)/60;
    }
    secondsLeft = (streamer.duration-streamer.progress)-minuteLeft*60;
    NSString *add = @"";
    NSString *add2 = @"";
    if (seconds<10) {
        add=@"0";
    }
    if (secondsLeft<10) {
        add2=@"0";
    }
    slider.progress = streamer.progress/streamer.duration;
    //NSLog(@"Streamer Duration : %f",streamer.duration);
    lblTimeEllasped.text = [NSString stringWithFormat:@"%d:%@%d",minute,add,seconds];
    lblTimeLeft.text = [NSString stringWithFormat:@"%d:%@%d",minuteLeft,add2,secondsLeft];
}
#pragma mark Application events
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.isVideoPlaying) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
