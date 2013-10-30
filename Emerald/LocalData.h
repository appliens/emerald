//
//  LocalData.h
//  Emerald
//
//  Created by ColtBoys on 12/27/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject

#pragma mark Favourites
+(void)addAFav:(NSDictionary *)infos;
+(BOOL)isArticleFav:(NSString *)url;
+(NSMutableArray *)getFavArticles;
#pragma mark ArticleData
+(void)addArticleToMemory:(NSString *)url;
+(BOOL)isArticleHasBeenSeen:(NSString *)url;
@end
