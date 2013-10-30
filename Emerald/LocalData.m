//
//  LocalData.m
//  Emerald
//
//  Created by ColtBoys on 12/27/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "LocalData.h"
@implementation LocalData
#pragma mark Favourites
+(void)addAFav:(NSDictionary *)infos{
    NSUserDefaults *dataAccess = [[NSUserDefaults alloc]init];
    NSMutableArray *tempAr = [[NSMutableArray alloc]initWithArray:[dataAccess objectForKey:@"fav"]];
    BOOL stop=NO;int i=0;
    while (!stop && i<tempAr.count) {
        if ([[[tempAr objectAtIndex:i]objectForKey:@"link"]isEqualToString:[infos objectForKey:@"link"]]) {
            stop=YES;
        }
        else
        {
            i=i+1;
        }
    }
    if (stop) {
        [tempAr removeObjectAtIndex:i];
    }
    else
    {
        [tempAr insertObject:infos atIndex:0];
    }
    [dataAccess setObject:tempAr forKey:@"fav"];
}
+(BOOL)isArticleFav:(NSString *)url{
    NSUserDefaults *dataAccess = [[NSUserDefaults alloc]init];
    NSMutableArray *tempAr = [[NSMutableArray alloc]initWithArray:[dataAccess objectForKey:@"fav"]];
    BOOL result=NO;int i=0;
    while (!result && i<tempAr.count) {
        if ([[[tempAr objectAtIndex:i]objectForKey:@"link"]isEqualToString:url]) {
            result=YES;
        }
        else
        {
            i=i+1;
        }
    }
    return result;
}
+(NSMutableArray *)getFavArticles{
    NSUserDefaults *dataAccess = [[NSUserDefaults alloc]init];
    return [[NSMutableArray alloc]initWithArray:[dataAccess objectForKey:@"fav"]];
}
#pragma mark ArticleData
+(void)addArticleToMemory:(NSString *)url{
    NSUserDefaults *dataAccess = [[NSUserDefaults alloc]init];
    NSMutableArray *tempAr = [[NSMutableArray alloc]initWithArray:[dataAccess objectForKey:@"mem"]];
    if (![tempAr containsObject:url]) {
        [tempAr addObject:url];
    }
    [dataAccess setObject:tempAr forKey:@"mem"];
}
+(BOOL)isArticleHasBeenSeen:(NSString *)url{
    BOOL result=NO;
    NSUserDefaults *dataAccess = [[NSUserDefaults alloc]init];
    NSMutableArray *tempAr = [[NSMutableArray alloc]initWithArray:[dataAccess objectForKey:@"mem"]];
    if ([tempAr containsObject:url]) {
        result=YES;
    }

    return result;
}
@end
