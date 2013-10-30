//
//  Config.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2012 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+(NSString *)getTabControllers;
//Style
+(UIColor *)getMainColor;
+(UIFont *)getMainFont;
//Feed
+(NSString *)getFeedSharingMessage;
+(NSString *)getFeedUrl;
+(NSString *)getFeedFontString;
+(float)getFeedArticleSize;
+(UIFont *)getFeedFont;
+(UIColor *)getFeedTitleColor;
+(CGFloat)getFeedCellSize;
+(BOOL)isFavouritesEnabled;
+(BOOL)isFeedRibbonEnabled;
+(UIColor *)getFeedArticleTextColor;
+(NSString *)getFeedArticleTextColorString;
//Photo
+(NSString *)getPhotoSharingMessage;
+(NSString *)getPhotoUrl;
+(UIColor *)getPhotoTitleColor;
+(CGFloat)getPhotoCellSize;
+(BOOL)isPhotoRibbonEnabled;
//Video
+(NSString *)getVideoSharingMessage;
+(NSString *)getVideoUrl;
+(UIColor *)getVideoTitleColor;
+(CGFloat)getVideoCellSize;
+(BOOL)isVideoRibbonEnabled;
//Audio
+(NSString *)getAudioUrl;
+(UIFont *)getAudioFont;
+(UIColor *)getAudioTextColor;
+(BOOL)getAudioRibbonEnabled;
+(UIColor *)getAudioColor;
+(NSString *)getAudioSharingMessage;
//More
+(NSString *)getMoreCellString;
+(UIFont *)getMoreFont;
+(UIColor *)getMoreTextColor;
//Strings
+(NSString *)getStringPublishedOn;
+(NSString *)getStringRemoveFromList;
+(NSString *)getStringReadItLater;
+(NSString *)getStringShare;
+(NSString *)getStringCancel;
+(NSString *)getStringOK;
+(NSString *)getStringTwitterAccountMissing;
+(NSString *)getStringTwitterAccountMissingMessage;
+(NSString *)getStringFacebookAppMissing;
+(NSString *)getStringFacebookAppMissingMessage;
+(NSString *)getStringError;
+(NSString *)getStringErrorMessage;
+(NSString *)getStringNetworkError;
+(NSString *)getStringNetworkErrorMessage;
+(NSString *)getStringAudioError;
@end
