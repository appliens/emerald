//
//  More.m
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2012 coltboy. All rights reserved.
//

#import "More.h"
#import "MoreDetails-General.h"
@interface More ()

@end

@implementation More

@synthesize DataSource;
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
    isHeaderHidden=NO;
    lblTitleNav.font = [Config getMainFont];
    lblTitleNav.text = [[[[[Config getTabControllers]componentsSeparatedByString:@","]objectAtIndex:self.tabBarController.selectedIndex]componentsSeparatedByString:@"/"]objectAtIndex:1];
    dataTable = [[NSMutableArray alloc]initWithArray:[self.DataSource componentsSeparatedByString:@";"]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [tableV reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Data Source & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellFeed"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.textColor = [Config getMoreTextColor];
        cell.textLabel.font = [Config getMoreFont];
        cell.textLabel.numberOfLines=0;
    }
    cell.textLabel.text = [[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]lastObject];
    if ([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"none"]||[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"].count<2) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"none"]||[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"].count<2)) {
        if ([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"url"]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:1]]];
            
        } else if([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"text"]){
            MoreDetails_General *details = [[MoreDetails_General alloc]initWithNibName:@"MoreDetails-General" bundle:nil];
            details.infos = [dataTable objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:details animated:YES];
        } else if([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"map"]){
            MoreDetails_General *details = [[MoreDetails_General alloc]initWithNibName:@"MoreDetails-General" bundle:nil];
            details.infos = [dataTable objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:details animated:YES];
        } else if([[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]objectAtIndex:0]isEqualToString:@"favorites"]){
            More_Favorites *fav = [[More_Favorites alloc]initWithNibName:@"More-Favorites" bundle:nil];
            fav.stringTitle = [[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]lastObject];
            [self.navigationController pushViewController:fav animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize constraintSize = CGSizeMake(320.0f, MAXFLOAT);
    CGSize labelSize = [[[[dataTable objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"]lastObject] sizeWithFont:[Config getMoreFont] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataTable count];
}

@end
