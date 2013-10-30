//
//  Video.m
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Video.h"

@interface Video ()

@end

@implementation Video
@synthesize XMLsource;
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
    tableV.hidden=YES;
    feedLoader = [[VideoDataManager alloc]init];
    feedLoader.UrlSource=self.XMLsource;
    feedLoader.delegate=self;
    isHeaderHidden=NO;
    lblTitleNav.font = [Config getMainFont];
    lblTitleNav.text = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:self.tabBarController.selectedIndex]componentsSeparatedByString:@"/"]objectAtIndex:1];
    
    
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
    if ([Config isVideoRibbonEnabled]) {
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
                viewHeader.frame = CGRectMake(viewHeader.frame.origin.x,0, viewHeader.frame.size.width, viewHeader.frame.size.height);
                loading.center=tableV.center;
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
                viewHeader.frame = CGRectMake(viewHeader.frame.origin.x, -viewHeader.frame.size.height, viewHeader.frame.size.width, viewHeader.frame.size.height);
                loading.center=tableV.center;
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
        
        //Background
        UIButton *background = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-294)/2, ([Config getVideoCellSize]-201)/2, 294, 201)];
        background.contentMode = UIViewContentModeScaleAspectFill;
        [background setBackgroundImage:[UIImage imageNamed:@"Bubble.png"] forState:UIControlStateNormal];
        background.userInteractionEnabled=NO;
        [cell.contentView addSubview:background];
        
        //Main image
        
        UIView *mainImageSuperView = [[UIView alloc]initWithFrame:CGRectMake(background.frame.origin.x+10, background.frame.origin.y+10, background.frame.size.width-20, 140)];
        mainImageSuperView.tag=9999;
        mainImageSuperView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:mainImageSuperView];
        
        
        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mainImageSuperView.frame.size.width, mainImageSuperView.frame.size.height)];
        webview.tag=1;
        webview.delegate=self;
        webview.alpha=0;
        if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"]!=nil) {
            NSString *extension=@"";
            if ([[[dataTable objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"youtube"]){
                extension = @"margin-top:-50px;";
            }
            [webview loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                      <style type=\"text/css\">\
                                      body {\
                                      background-color: white;\
                                      color: white;\
                                      margin: 0;\
                                      margin-top:0;\
                                      }\
                                      </style>\
                                      </head><body> \
                                      <img src=\"%@\" width=\"%f\" style=\"%@\">\
                                      </body></html>",[[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"],webview.frame.size.width,extension] baseURL:nil];
        }
        
        webview.userInteractionEnabled=NO;
        [mainImageSuperView addSubview:webview];
        
        UIActivityIndicatorView *loadingT = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingT.hidesWhenStopped=YES;
        loadingT.tag=2;
        loadingT.center = webview.center;
        [loadingT startAnimating];
        [mainImageSuperView addSubview:loadingT];
        
        UIButton *btnAction = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mainImageSuperView.frame.size.width, mainImageSuperView.frame.size.height)];
        [btnAction addTarget:self action:@selector(UserTouchedImage:) forControlEvents:UIControlEventTouchUpInside];
        [btnAction setBackgroundColor:[UIColor clearColor]];
        btnAction.tag=indexPath.row+1;
        [mainImageSuperView addSubview:btnAction];
        
        //Title
        UIView *mainLabelSuperView = [[UIView alloc]initWithFrame:CGRectMake(mainImageSuperView.frame.origin.x, mainImageSuperView.frame.origin.y+mainImageSuperView.frame.size.height+6, mainImageSuperView.frame.size.width-110, 40)];
        mainLabelSuperView.tag=9998;
        mainLabelSuperView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:mainLabelSuperView];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainLabelSuperView.frame.size.width, mainLabelSuperView.frame.size.height)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [Config getVideoTitleColor];
        lblTitle.font= [Config getFeedFont];
        lblTitle.numberOfLines=2;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.tag=1;
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=6) {
            lblTitle.adjustsFontSizeToFitWidth=YES;
            lblTitle.adjustsLetterSpacingToFitWidth=YES;
        }
        else
        {
            lblTitle.minimumFontSize = 10;
        }
        lblTitle.text = [[dataTable objectAtIndex:indexPath.row]objectForKey:@"title"];
        [mainLabelSuperView addSubview:lblTitle];
        
        //Share Button
        UIView *mainShareButtonSuperView = [[UIView alloc]initWithFrame:CGRectMake(mainLabelSuperView.frame.origin.x+mainLabelSuperView.frame.size.width+9, mainLabelSuperView.frame.origin.y-6, self.view.frame.size.width-mainLabelSuperView.frame.size.width-20, 44)];
        mainShareButtonSuperView.tag=9997;
        mainShareButtonSuperView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:mainShareButtonSuperView];
        
        UIButton *btnShare = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mainShareButtonSuperView.frame.size.width, mainShareButtonSuperView.frame.size.height)];
        btnShare.backgroundColor = [UIColor clearColor];
        btnShare.tag=indexPath.row+1;
        [btnShare addTarget:self action:@selector(UserTouchedShare:) forControlEvents:UIControlEventTouchUpInside];
        [btnShare setImage:[UIImage imageNamed:@"ShareBtn.png"] forState:UIControlStateNormal];
        [mainShareButtonSuperView addSubview:btnShare];
        
        //Ribbon View
        if ([Config isVideoRibbonEnabled]) {
            UIView *mainRibbonView = [[UIView alloc]initWithFrame:CGRectMake(background.frame.size.width-46, background.frame.origin.y-3, 61, 61)];
            mainRibbonView.tag=9996;
            mainRibbonView.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:mainRibbonView];
            
            UIImageView *imgRibbon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 61)];
            imgRibbon.image = [UIImage imageNamed:@"NewRibbon.png"];
            [mainRibbonView addSubview:imgRibbon];
            imgRibbon.hidden=NO;
            imgRibbon.tag=1;
            
            
            if ([LocalData isArticleHasBeenSeen:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"link"]]) {
                imgRibbon.hidden=YES;
            }
            
        }
        
        
    }
    else
    {
        UIWebView *webVTemp = (UIWebView *)[[cell.contentView viewWithTag:9999]viewWithTag:1];
        webVTemp.delegate=self;
        webVTemp.alpha=0;
        if ([[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"]!=nil) {
            NSString *extension=@"";
            if ([[[dataTable objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"youtube"]){
                extension = @"margin-top:-50px;";
            }
            [webVTemp loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                     <style type=\"text/css\">\
                                     body {\
                                     background-color: white;\
                                     color: white;\
                                     margin: 0;\
                                     margin-top:0;\
                                     }\
                                     </style>\
                                     </head><body> \
                                     <img src=\"%@\" width=\"%f\" style=\"%@\">\
                                     </body></html>",[[dataTable objectAtIndex:indexPath.row]objectForKey:@"thumb"],webVTemp.frame.size.width,extension] baseURL:nil];
        }
        
        
        UIActivityIndicatorView *loadingTemp = (UIActivityIndicatorView *)[[cell.contentView viewWithTag:9999]viewWithTag:2];
        [loadingTemp startAnimating];
        
        UILabel *lblTitle = (UILabel *)[[cell.contentView viewWithTag:9998]viewWithTag:1];
        lblTitle.text = [[dataTable objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        UIButton *btnTouchImgTmep = (UIButton *)[[[cell.contentView viewWithTag:9999]subviews]objectAtIndex:2];
        [btnTouchImgTmep setTag:indexPath.row+1];
        
        UIButton *btnShareTemp = (UIButton *)[[[cell.contentView viewWithTag:9997]subviews]objectAtIndex:0];
        [btnShareTemp setTag:indexPath.row+1];
        
        if ([Config isVideoRibbonEnabled]) {
            UIImageView *imgRibbontTemp = (UIImageView *)[[cell.contentView viewWithTag:9996]viewWithTag:1];
            if ([LocalData isArticleHasBeenSeen:[[dataTable objectAtIndex:indexPath.row]objectForKey:@"link"]]) {
                
                imgRibbontTemp.hidden=YES;
            }
            else
            {
                imgRibbontTemp.hidden=NO;
            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Config getVideoCellSize];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataTable count];
}
-(void)UserTouchedShare:(id)sender{
    if ([sender tag]-1>=0 && [sender tag]-1<[dataTable count]) {
        sharing=nil;
        sharing = [[ShareTools alloc]init];
        [sharing ShowShareToolsInController:self withMessage:[NSString stringWithFormat:@"%@ %@",[Config getVideoSharingMessage],[[dataTable objectAtIndex:[sender tag]-1]objectForKey:@"title"]] andUrl:[[dataTable objectAtIndex:[sender tag]-1]objectForKey:@"link"]];
        
    }
}
-(void)UserTouchedImage:(id)sender{
    if ([sender tag]-1<[dataTable count]) {
        FullScreenVideo *fl = [[FullScreenVideo alloc]init];
        fl.content = [dataTable objectAtIndex:[sender tag]-1];
        [self.navigationController pushViewController:fl animated:YES];
    }
}
#pragma mark WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIActivityIndicatorView *loadingT = (UIActivityIndicatorView *)[webView.superview viewWithTag:2];
    [loadingT stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIActivityIndicatorView *loadingT = (UIActivityIndicatorView *)[webView.superview viewWithTag:2];
    [loadingT stopAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    webView.alpha=1;
    [UIView commitAnimations];
    
}
#pragma mark Classic Feed delegate
-(void)VideoDataManagerDidLoadInfo:(NSMutableArray *)data{
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
-(void)VideoDataManagerFailedToLoadInfo:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[Config getStringError] message:[Config getStringErrorMessage] delegate:nil cancelButtonTitle:[Config getStringOK] otherButtonTitles:nil];
    [alert show];
    [self ShouldDisplayNetworkErrorView:NO];
    
}
-(void)VideoDataManagerDidReceivedNetWorkError{
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
@end

