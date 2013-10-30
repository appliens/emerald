//
//  Audio.m
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Audio.h"
#import "Tools.h"
@interface Audio ()

@end

@implementation Audio
@synthesize XMLsource;
@synthesize CurrentPlayingView;
@synthesize IndexPlaying;
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
    tableV.frame = CGRectMake(tableV.frame.origin.x, tableV.frame.origin.y, tableV.frame.size.width,self.view.frame.size.height-tableV.frame.origin.y );
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.hidesWhenStopped=YES;
    [loading startAnimating];
    [loading setColor:[Config getMainColor]];
    [self.view addSubview:loading];
    loading.center=tableV.center;
    if([UIScreen mainScreen].bounds.size.height < 568){
        loading.center = CGPointMake(tableV.center.x, tableV.center.y-44);
    }
    self.IndexPlaying=-1;
    tableV.hidden=YES;
    feedLoader = [[AudioDataManager alloc]init];
    feedLoader.UrlSource=self.XMLsource;
    feedLoader.delegate=self;
    isHeaderHidden=NO;
    lblTitleNav.font = [Config getMainFont];
    lblTitleNav.text = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:self.tabBarController.selectedIndex]componentsSeparatedByString:@"/"]objectAtIndex:1];
    deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(void)ShouldDisplayNetworkErrorView:(BOOL)val{
    if (viewNetworkError==nil) {
        viewNetworkError = [[UIView alloc]init];
        viewNetworkError.backgroundColor=[UIColor clearColor];
        UIImageView *viewImg = [[UIImageView alloc]init];
        viewImg.backgroundColor=[UIColor clearColor];
        if([UIScreen mainScreen].bounds.size.height == 568){
            viewNetworkError.frame = CGRectMake(0, viewHeader.frame.size.height, tableV.frame.size.width, 473);
            [viewImg setImage:[UIImage imageNamed:@"NetworkErrori5.png"]];
        }
        else
        {
            viewNetworkError.frame = CGRectMake(0, viewHeader.frame.size.height, tableV.frame.size.width, 385);
            [viewImg setImage:[UIImage imageNamed:@"NetworkError.png"]];
        }
        viewImg.frame = CGRectMake(0, 0, viewNetworkError.frame.size.width, viewNetworkError.frame.size.height);
        [viewNetworkError addSubview:viewImg];
        UIButton *btnAction = [[UIButton alloc]initWithFrame:viewImg.frame];
        [btnAction addTarget:self action:@selector(RefreshInfoTable) forControlEvents:UIControlEventTouchUpInside];
        [viewNetworkError addSubview:btnAction];
        [self.view addSubview:viewNetworkError];
        viewNetworkError.hidden=YES;
    }
    if (val && dataTable.count==0) {
        viewNetworkError.hidden=NO;
        [self.view bringSubviewToFront:viewNetworkError];
    }
    else
    {
        viewNetworkError.hidden=YES;
    }
}
-(void)RefreshInfoTable{
     [self.view bringSubviewToFront:loading];
    [loading startAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    tableV.alpha=0;
    loading.alpha=1;
    [UIView commitAnimations];
    [feedLoader RefreshInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([Config getAudioRibbonEnabled]) {
        [tableV reloadData];
    }
    if (dataTable.count==0) {
        [loading startAnimating];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        tableV.alpha=0;
        loading.alpha=1;
        [UIView commitAnimations];
        [feedLoader RefreshInfo];
        [self.view bringSubviewToFront:loading];
    }
    if (self.IndexPlaying!=-1 && deleg.streamer.isPlaying) {
        [tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.IndexPlaying inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Data Source & Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==tableV) {
        if (scrollView.contentOffset.y<=10) {
            if (isHeaderHidden) {
                //Animate (add)
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                tableV.frame = CGRectMake(tableV.frame.origin.x,viewHeader.frame.size.height , tableV.frame.size.width, self.view.frame.size.height-tableV.frame.origin.y);
                loading.center=tableV.center;
                viewHeader.frame = CGRectMake(viewHeader.frame.origin.x,0, viewHeader.frame.size.width, viewHeader.frame.size.height);
                [UIView commitAnimations];
                isHeaderHidden=NO;
            }
        }
        else
        {
            if (!isHeaderHidden) {
                //Animate (close)
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                tableV.frame = CGRectMake(tableV.frame.origin.x,viewHeader.frame.origin.y , tableV.frame.size.width, self.view.frame.size.height);
                loading.center=tableV.center;
                viewHeader.frame = CGRectMake(viewHeader.frame.origin.x, -viewHeader.frame.size.height, viewHeader.frame.size.width, viewHeader.frame.size.height);
                [UIView commitAnimations];
                isHeaderHidden=YES;
            }
        }
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellFeed"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //Main Img
        UIView *superViewImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [[[dataTable objectAtIndex:indexPath.row]objectForKey:@"height"]intValue])];
        superViewImg.backgroundColor = [UIColor blackColor];
        superViewImg.clipsToBounds=YES;
        superViewImg.tag=1;
        [cell.contentView addSubview:superViewImg];
        
        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, superViewImg.frame.size.width, superViewImg.frame.size.height)];
        webview.tag=2;
        webview.delegate=self;
        webview.alpha=0;
        if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"]!=nil) {
            [webview loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                     <style type=\"text/css\">\
                                     body {\
                                     background-color: black;\
                                     color: black;\
                                     margin: 0;\
                                     margin-top:0;\
                                     }\
                                     </style>\
                                     </head><body> \
                                     <img src=\"%@\" width=\"%f\">\
                                     </body></html>",[[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"],webview.frame.size.width] baseURL:nil];
        }
        
        webview.userInteractionEnabled=NO;
        [superViewImg addSubview:webview];
        
        UIActivityIndicatorView *loadingT = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingT.hidesWhenStopped=YES;
        loadingT.tag=3;
        loadingT.center = webview.center;
        [loadingT startAnimating];
        [superViewImg addSubview:loadingT];
        
        //Music Control View
        UIView *superControlView = [[UIView alloc]initWithFrame:CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath], tableView.frame.size.width, 60)];
        superControlView.backgroundColor = [UIColor clearColor];
        superControlView.tag=4;
        [cell.contentView addSubview:superControlView];
        
        UIView *superControlViewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, superControlView.frame.size.width, superControlView.frame.size.height)];
        superControlViewBackground.backgroundColor = [UIColor blackColor];
        superControlViewBackground.alpha=0.6;
        [superControlView addSubview:superControlViewBackground];
        
        UIProgressView *slider = [[UIProgressView alloc]initWithFrame:CGRectMake((superControlView.frame.size.width-190)/2, (superControlView.frame.size.height-9)/2, 190, 9)];
        slider.progress=0;
        slider.trackTintColor = [UIColor lightGrayColor];
        slider.progressTintColor = [Config getAudioColor];
        slider.tag=5;
        [superControlView addSubview:slider];
        
        UILabel *lblTimeElapsed = [[UILabel alloc]initWithFrame:CGRectMake(slider.frame.origin.x-50, 0, 50, 60)];
        lblTimeElapsed.text = @"0:00";
        lblTimeElapsed.backgroundColor = [UIColor clearColor];
        lblTimeElapsed.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        lblTimeElapsed.shadowColor = [UIColor blackColor];
        lblTimeElapsed.shadowOffset = CGSizeMake(0, -1);
        lblTimeElapsed.textAlignment = NSTextAlignmentCenter;
        lblTimeElapsed.textColor = [UIColor lightGrayColor];
        lblTimeElapsed.tag=6;
        [superControlView addSubview:lblTimeElapsed];
        
        UILabel *lblTimeLeft = [[UILabel alloc]initWithFrame:CGRectMake(slider.frame.origin.x+slider.frame.size.width, 0, 50, 60)];
        lblTimeLeft.text = @"-4:29";
        lblTimeLeft.backgroundColor = [UIColor clearColor];
        lblTimeLeft.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        lblTimeLeft.shadowColor = [UIColor blackColor];
        lblTimeLeft.shadowOffset = CGSizeMake(0, -1);
        lblTimeLeft.textAlignment = NSTextAlignmentCenter;
        lblTimeLeft.textColor = [UIColor lightGrayColor];
        lblTimeLeft.tag=7;
        [superControlView addSubview:lblTimeLeft];
        
        UIActivityIndicatorView *loadingSong = [[UIActivityIndicatorView alloc]init];
        loadingSong.color = [Config getMainColor];
        loadingT.hidesWhenStopped=YES;
        loadingSong.center = superControlViewBackground.center;
        loadingSong.tag = 14;
        [superControlView addSubview:loadingSong];
        [loadingSong stopAnimating];
        
        
        //Btn Play
        UIView *ViewButtonPlay = [[UIView alloc]initWithFrame:CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath]-60, 80, 44)];
        ViewButtonPlay.backgroundColor = [UIColor clearColor];
        ViewButtonPlay.tag = 8;
        [cell.contentView addSubview:ViewButtonPlay];
        
        UIButton *btnPlay = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewButtonPlay.frame.size.width, ViewButtonPlay.frame.size.height)];
        btnPlay.backgroundColor=[UIColor clearColor];
        btnPlay.tag = 1000+indexPath.row;
        [btnPlay setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [btnPlay addTarget:self action:@selector(UserTouchedPlay:) forControlEvents:UIControlEventTouchUpInside];
        [ViewButtonPlay addSubview:btnPlay];
        
        //Btn Share
        UIView *ViewButtonShare = [[UIView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-87, [self tableView:tableView heightForRowAtIndexPath:indexPath]-60, 70, 44)];
        ViewButtonShare.backgroundColor = [UIColor clearColor];
        ViewButtonShare.tag = 9;
        [cell.contentView addSubview:ViewButtonShare];
        
        UIButton *btnShare = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewButtonPlay.frame.size.width, ViewButtonPlay.frame.size.height)];
        btnShare.backgroundColor=[UIColor clearColor];
        btnShare.tag = 2000+indexPath.row;
        [btnShare setImage:[UIImage imageNamed:@"ShareBtn.png"] forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(UserTouchedShare:) forControlEvents:UIControlEventTouchUpInside];
        [ViewButtonShare addSubview:btnShare];
        
        //Header View
        UIView *ViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
        ViewHeader.backgroundColor = [UIColor clearColor];
        ViewHeader.tag = 10;
        [cell.contentView addSubview:ViewHeader];
        
        UIView *HeaderViewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewHeader.frame.size.width, ViewHeader.frame.size.height)];
        HeaderViewBackground.backgroundColor = [UIColor blackColor];
        HeaderViewBackground.alpha=0.6;
        [ViewHeader addSubview:HeaderViewBackground];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 280, 60)];
        lblTitle.text = [[dataTable objectAtIndex:indexPath.row]objectForKey:@"title"];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [Config getAudioFont];
        lblTitle.numberOfLines=2;
        lblTitle.shadowColor = [UIColor blackColor];
        lblTitle.shadowOffset = CGSizeMake(0, -1);
        lblTitle.textColor = [Config getMainColor];
        lblTitle.tag=11;
        [ViewHeader addSubview:lblTitle];
        
       /* UIView *ViewButtonPrice = [[UIView alloc]initWithFrame:CGRectMake(ViewHeader.frame.size.width-70, 0, 60, 60)];
        ViewButtonPrice.backgroundColor = [UIColor clearColor];
        ViewButtonPrice.tag = 12;
        [ViewHeader addSubview:ViewButtonPrice];
        
        UIButton *btnPrice = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 30)];
        [btnPrice setBackgroundImage:[UIImage imageNamed:@"PriceButton.png"] forState:UIControlStateNormal];
        btnPrice.tag = 3000 +indexPath.row;
        [ViewButtonPrice addSubview:btnPrice];
        [btnPrice addTarget:self action:@selector(UserTouchedButtonPrice:) forControlEvents:UIControlEventTouchUpInside];
        btnPrice.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        btnPrice.titleLabel.shadowColor = [UIColor whiteColor];
        btnPrice.titleLabel.shadowOffset = CGSizeMake(0, -1);
        btnPrice.titleLabel.lineBreakMode = UILineBreakModeClip;
        [btnPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        btnPrice.titleLabel.textAlignment = NSTextAlignmentRight;
        [btnPrice setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btnPrice.hidden=YES;
        if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"]!=nil) {
            if ([[[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"] length]!=0) {
                
                [btnPrice setTitle:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"] forState:UIControlStateNormal];
                btnPrice.hidden=NO;
            }
        }*/
        
        //Ribbon View
        if ([Config getAudioRibbonEnabled]) {
            UIView *mainRibbonView = [[UIView alloc]initWithFrame:CGRectMake(tableV.frame.size.width-57, -3, 61, 61)];
            mainRibbonView.tag=12;
            mainRibbonView.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:mainRibbonView];
            
            UIImageView *imgRibbon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 61)];
            imgRibbon.image = [UIImage imageNamed:@"NewRibbon.png"];
            [mainRibbonView addSubview:imgRibbon];
            imgRibbon.hidden=NO;
            imgRibbon.tag=13;
            
            
            if ([LocalData isArticleHasBeenSeen:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"link"]]) {
                imgRibbon.hidden=YES;
            }
            
            
        }

    }
    else
    {
        UIView *superViewImg = (UIView *)[cell.contentView viewWithTag:1];
        superViewImg.frame= CGRectMake(0, 0, tableView.frame.size.width, [[[dataTable objectAtIndex:indexPath.row]objectForKey:@"height"]intValue]);
        
        UIWebView *webVTemp = (UIWebView *)[[cell.contentView viewWithTag:1] viewWithTag:2];
            webVTemp.frame = CGRectMake(0, 0, superViewImg.frame.size.width, superViewImg.frame.size.height);
            webVTemp.alpha=0;
            if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"]!=nil) {
                [webVTemp loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                          <style type=\"text/css\">\
                                          body {\
                                          background-color: black;\
                                          color: black;\
                                          margin: 0;\
                                          margin-top:0;\
                                          }\
                                          </style>\
                                          </head><body> \
                                          <img src=\"%@\" width=\"%f\">\
                                          </body></html>",[[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"],webVTemp.frame.size.width] baseURL:nil];
    
            }
        
        UIActivityIndicatorView *loadingTemp = (UIActivityIndicatorView *)[[cell.contentView viewWithTag:1]viewWithTag:3];
        loadingTemp.center = webVTemp.center;
        [loadingTemp startAnimating];
        
        UIView *superControlView = (UIView *)[cell.contentView viewWithTag:4];
        UIView *ViewButtonPlay = (UIView *)[cell.contentView viewWithTag:8];
        
        UIButton *btnPlay = (UIButton *)[ViewButtonPlay.subviews objectAtIndex:0];
        [btnPlay setTag:1000+indexPath.row];
        UIView *ViewShare= (UIView *)[cell.contentView viewWithTag:9];
        if (self.IndexPlaying==indexPath.row) {
            [superControlView removeFromSuperview];
            [cell.contentView addSubview:deleg.streamerView];
            superControlView.frame = CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath]-60, tableView.frame.size.width, 60);
             ViewButtonPlay.frame = CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath]-120, 80, 44);
            ViewShare.frame = CGRectMake(tableView.frame.size.width-87, [self tableView:tableView heightForRowAtIndexPath:indexPath]-120, 70, 44);
            if (isCurrentViewPlaying) {
                [btnPlay setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [btnPlay setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
            }
           
        }
        else
        {
            
            superControlView.frame= CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath], tableView.frame.size.width, 60);
            [btnPlay setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
            ViewButtonPlay.frame = CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath]-60, 80, 44);
            ViewShare.frame = CGRectMake(tableView.frame.size.width-87, [self tableView:tableView heightForRowAtIndexPath:indexPath]-60, 70, 44);
        }
        
        
        
                
        
        
        UIButton *btnShare = (UIButton *)[ViewShare.subviews objectAtIndex:0];
        [btnShare setTag:2000+indexPath.row];
        
        UILabel *lblTitle =(UILabel *)[[cell.contentView viewWithTag:10]viewWithTag:11];
        lblTitle.text = [[dataTable objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        if ([Config getAudioRibbonEnabled]) {
            UIImageView *imgRibbontTemp = (UIImageView *)[[cell.contentView viewWithTag:12]viewWithTag:13];
            if ([LocalData isArticleHasBeenSeen:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"link"]]) {
                
                imgRibbontTemp.hidden=YES;
            }
            else
            {
                imgRibbontTemp.hidden=NO;
            }
        }
        /*UIButton *btnPrice = (UIButton *)[[[cell.contentView viewWithTag:10]viewWithTag:12].subviews objectAtIndex:0];
        btnPrice.hidden=YES;
        if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"]!=nil) {
            if ([[[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"] length]!=0) {
                
                [btnPrice setTitle:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"price"] forState:UIControlStateNormal];
                btnPrice.hidden=NO;
            }
        }*/
        
    }
    cell.clipsToBounds=YES;
    cell.contentView.clipsToBounds=YES;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<[dataTable count]) {
        if ([[[dataTable objectAtIndex:indexPath.row]objectForKey:@"height"]floatValue]<180) {
            return 180;
        }
        else
        {
            return ([[[dataTable objectAtIndex:indexPath.row]objectForKey:@"height"]floatValue]);
        }
    }
    else
    {
        return 180;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataTable count];
}
#pragma mark User Interaction 
-(void)UserTouchedPlay:(id)sender{
    if ([sender tag]-1000!=self.IndexPlaying) {
        //New Song played
        self.IndexPlaying = [sender tag]-1000;
        UIButton *btnTemp = (UIButton *)sender;
        if (self.CurrentPlayingView) {
            //Close and Stop Playing
            UIView *viewPlay = [self.CurrentPlayingView.superview viewWithTag:8];
            UIView *viewShare = [self.CurrentPlayingView.superview viewWithTag:9];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.7];
            viewPlay.frame = CGRectMake(0, self.CurrentPlayingView.frame.origin.y, 80, 44);
            viewShare.frame = CGRectMake(tableV.frame.size.width-87, self.CurrentPlayingView.frame.origin.y, 70, 44);
            self.CurrentPlayingView.frame = CGRectMake(CurrentPlayingView.frame.origin.x, CurrentPlayingView.frame.origin.y+CurrentPlayingView.frame.size.height, CurrentPlayingView.frame.size.width, CurrentPlayingView.frame.size.height);
            [UIView commitAnimations];
            [self performSelector:@selector(OpenViewDelayed:) withObject:[btnTemp.superview.superview viewWithTag:4] afterDelay:0.75];
            [btnTemp setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
            UIButton *oldButton = (UIButton *)[[self.CurrentPlayingView.superview viewWithTag:8].subviews objectAtIndex:0];
            [oldButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            
            self.CurrentPlayingView = [btnTemp.superview.superview viewWithTag:4];
            [self OpenViewDelayed:self.CurrentPlayingView];
            [btnTemp setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        }
        [deleg AudioStreamContent:[dataTable objectAtIndex:self.IndexPlaying] withView:[btnTemp.superview.superview viewWithTag:4] andControllerIndex:self.tabBarController.selectedIndex andController:self];
        isCurrentViewPlaying=YES;
    }
    else
    {
        //Pause Play
        UIButton *btnTemp = (UIButton *)sender;

        if (isCurrentViewPlaying) {
            [btnTemp setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
            isCurrentViewPlaying=NO;
            [deleg.streamer pause];
        }
        else
        {
            [btnTemp setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
            isCurrentViewPlaying=YES;
            //Resume Song
            [deleg.streamer start];
        }
                
    }
   
}
-(void)OpenViewDelayed:(UIView *)view{
    self.CurrentPlayingView=view;
    UIView *viewPlay = [view.superview viewWithTag:8];
    UIView *viewShare = [view.superview viewWithTag:9];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.IndexPlaying inSection:0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    view.frame = CGRectMake(view.frame.origin.x, [self tableView:tableV heightForRowAtIndexPath:indexPath]-view.frame.size.height, view.frame.size.width, view.frame.size.height);
    viewPlay.frame = CGRectMake(0, [self tableView:tableV heightForRowAtIndexPath:indexPath]-120, 80, 44);
    viewShare.frame = CGRectMake(tableV.frame.size.width-87, [self tableView:tableV heightForRowAtIndexPath:indexPath]-120, 70, 44);

    [UIView commitAnimations];
}
-(void)UserTouchedShare:(id)sender{
    if ([sender tag]-2000>=0 && [sender tag]-2000<[dataTable count]) {
        sharing=nil;
        sharing = [[ShareTools alloc]init];
        [sharing ShowShareToolsInController:self withMessage:[NSString stringWithFormat:@"%@ %@",[Config getAudioSharingMessage],[[dataTable objectAtIndex:[sender tag]-2000]objectForKey:@"title"]] andUrl:[[dataTable objectAtIndex:[sender tag]-2000]objectForKey:@"link"]];
        
    }
}
-(void)UserTouchedButtonPrice:(id)sender{
    
}
#pragma mark WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIActivityIndicatorView *loadingT = (UIActivityIndicatorView *)[webView.superview viewWithTag:3];
    [loadingT stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIActivityIndicatorView *loadingT = (UIActivityIndicatorView *)[webView.superview viewWithTag:3];
    [loadingT stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
    
}
#pragma mark Classic Feed delegate
-(void)AudioDataManagerDidLoadInfo:(NSMutableArray *)data{
    dataTable = nil;
    dataTable = data;
    if (refreshControl==nil) {
        refreshControl = [[ODRefreshControl alloc] initInScrollView:tableV];
        [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
        refreshControl.tintColor = [Config getMainColor];
    }
    else
    {
        [refreshControl endRefreshing];
    }
    tableV.alpha=0;
    tableV.hidden=NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    tableV.alpha=1;
    loading.alpha=0;
    [UIView commitAnimations];
    [self performSelector:@selector(FinishAnimation) withObject:nil afterDelay:0.7];
    tableV.dataSource=self;
    tableV.delegate=self;
    
    if (!isCurrentViewPlaying) {
        isCurrentViewPlaying=NO;
        self.IndexPlaying=-1;
    }
    else
    {
        //Modif to do : Need to check if current element playing is in Array
    }
    
    [tableV reloadData];
    [self ShouldDisplayNetworkErrorView:NO];
    
    
}
- (void)FinishAnimation{
    [loading stopAnimating];
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [loading startAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    tableV.alpha=0;
    loading.alpha=1;
    [UIView commitAnimations];
    [feedLoader RefreshInfo];
}
-(void)AudioDataManagerFailedToLoadInfo:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[Config getStringError] message:[Config getStringErrorMessage] delegate:nil cancelButtonTitle:[Config getStringOK] otherButtonTitles:nil];
    [alert show];
    [self ShouldDisplayNetworkErrorView:NO];
    
}
-(void)AudioDataManagerDidReceivedNetWorkError{
    if (refreshControl!=nil) {
        [refreshControl endRefreshing];
    }
    tableV.alpha=0;
    tableV.hidden=NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    tableV.alpha=1;
    loading.alpha=0;
    [UIView commitAnimations];
    [self performSelector:@selector(FinishAnimation) withObject:nil afterDelay:0.7];
    [self ShouldDisplayNetworkErrorView:YES];
}
-(void)ReloadData{
    [tableV reloadData];
}
@end
