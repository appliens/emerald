//
//  Config.m
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2012 coltboy. All rights reserved.
//

#import "Config.h"
#import "Tools.h"

// DO NOT EDIT
#define FeedCellSize 240;
#define PhotoCellSize 240;
#define VideoCellSize 240;
// END DO NOT EDIT




//Controllers

#define TabControllers @"feed/Articles,photo/Pictures,video/Videos,audio/Audio,more/More"


// Style
#define MainFont @"YourFontNameHere"
#define MainFontSize 20
#define MainColor @"#65ac9e"
//Feed
#define FeedSharingMessage @"You can change this text : "
#define FeedUrl @"http://coltboy.com/products/Emerald/news-demo.xml"
#define FeedTitleColor @"#000000"
#define FeedArticleFontSize 14
#define FeedTitleFontSize 14
#define FavouritesEnabled @"YES"
#define FeedRibbonEnabled @"YES"
#define FeedArticleTextColor @"#000000"
//Photo
#define PhotoSharingMessage @"You can change this text : "
#define PhotoUrl @"http://coltboy.com/products/Emerald/photos.xml"
#define PhotoTitleColor @"#000000"

#define PhotoRibbonEnabled @"YES"
//Video
#define VideoSharingMessage @"You can change this text : "
#define VideoUrl @"http://coltboy.com/products/Emerald/videos.xml"
#define VideoTitleColor @"#000000"

#define VideoRibbonEnabled @"YES"
//Audio
#define AudioUrl @"http://coltboy.com/products/Emerald/audio.xml"
#define AudioFontSize 19
#define AudioTextColor @"#ffffff"
#define AudioRibbonEnabled @"YES"
#define AudioColor @"#22967c"
#define AudioSharingMessage @"You can change this text : "
//More
#define MoreCells @"favorites#Reading list;text#\nAdd as much text as you want here.\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?#About Us;url#http://coltboy.com#Open an url;map#40.703056,-73.989444#ColtBoy#Find us;none#Plain text;none#Thanks for checking the demo!"
#define MoreFontSize 19
#define MoreTextColor @"#000000"
//Strings
#define StringLoading @"Loading..."
#define StringPublishOn @"Published on the "
#define StringRemoveFromList @"Remove from reading list"
#define StringReadItLater @"Read it later"
#define StringShare @"Share"
#define StringCancel @"Cancel"
#define StringOK @"OK"
#define StringTwitterAccountMissing @"Twitter Account missing"
#define StringTwitterAccountMissingMessage @"You did not configure your twitter account in settings. Please open the settings app to sign in with Twitter."
#define StringFacebookAppMissing @"Facebook App missing"
#define StringFacebookAppMissingMessage @"Please download the official facebook application to share this content."
#define StringError @"Error"
#define StringErrorMessage @"We are unable to refresh the content at this time. Please try again in a moment"
#define StringNetworkError @"No network connection"
#define StringNetworkErrorMessage @"It appears there is no avalaible network connection. Try to find a WiFi point or look at your device settings"
#define StringAudioStreamingError @"We can not load this song at the moment, please try again later"
//
@implementation Config
+(NSString *)getTabControllers{
    return TabControllers;
}

//Style
+(UIColor *)getMainColor{
    return [Tools colorWithHexString:MainColor];
}
+(UIFont *)getMainFont{
    return [UIFont fontWithName:MainFont size:MainFontSize];
}
//Feed
+(NSString *)getFeedSharingMessage{
    return FeedSharingMessage;
}
+(NSString *)getFeedUrl{
    return FeedUrl;
}
+(NSString *)getFeedFontString{
    return MainFont;
}
+(float)getFeedArticleSize{
    return FeedArticleFontSize;
}
+(UIFont *)getFeedFont{
    return [UIFont fontWithName:MainFont size:FeedTitleFontSize];
}
+(UIColor *)getFeedTitleColor{
    return [Tools colorWithHexString:FeedTitleColor];
}
+(CGFloat)getFeedCellSize{
    return FeedCellSize;
}
+(BOOL)isFavouritesEnabled{
    if ([FavouritesEnabled isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)isFeedRibbonEnabled{
    if ([FeedRibbonEnabled isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(UIColor *)getFeedArticleTextColor{
    return [Tools colorWithHexString:FeedArticleTextColor];
}
+(NSString *)getFeedArticleTextColorString{
    return FeedArticleTextColor;
}
//Photo
+(NSString *)getPhotoSharingMessage{
    return PhotoSharingMessage;
}
+(NSString *)getPhotoUrl{
    return PhotoUrl;
}
+(UIColor *)getPhotoTitleColor{
    return [Tools colorWithHexString:PhotoTitleColor];
}
+(CGFloat)getPhotoCellSize{
    return PhotoCellSize;
}
+(BOOL)isPhotoRibbonEnabled{
    if ([PhotoRibbonEnabled isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
//Video
+(NSString *)getVideoSharingMessage{
    return VideoSharingMessage;
}
+(NSString *)getVideoUrl{
    return VideoUrl;
}
+(UIColor *)getVideoTitleColor{
    return [Tools colorWithHexString:PhotoTitleColor];
}
+(CGFloat)getVideoCellSize{
    return VideoCellSize;
}
+(BOOL)isVideoRibbonEnabled{
    if ([VideoRibbonEnabled isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
//Audio
+(NSString *)getAudioUrl{
    return AudioUrl;
}
+(UIFont *)getAudioFont{
    return [UIFont fontWithName:MainFont size:AudioFontSize];
}
+(UIColor *)getAudioTextColor{
    return [Tools colorWithHexString:AudioTextColor];
}
+(BOOL)getAudioRibbonEnabled{
    if ([AudioRibbonEnabled isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(UIColor *)getAudioColor{
    return [Tools colorWithHexString:AudioColor];
}
+(NSString *)getAudioSharingMessage{
    return AudioSharingMessage;
}
//More
+(NSString *)getMoreCellString{
    return MoreCells;
}
+(UIFont *)getMoreFont{
    return [UIFont fontWithName:MainFont size:MoreFontSize];
}
+(UIColor *)getMoreTextColor{
    return [Tools colorWithHexString:MoreTextColor];
}
//Strings
+(NSString *)getStringPublishedOn{
    return StringPublishOn;
}
+(NSString *)getStringRemoveFromList{
    return StringRemoveFromList;
}
+(NSString *)getStringReadItLater{
    return StringReadItLater;
}
+(NSString *)getStringShare{
    return StringShare;
}
+(NSString *)getStringCancel{
    return StringCancel;
}
+(NSString *)getStringOK{
    return StringOK;
}
+(NSString *)getStringTwitterAccountMissing{
    return StringTwitterAccountMissing;
}
+(NSString *)getStringTwitterAccountMissingMessage{
    return StringTwitterAccountMissingMessage;
}
+(NSString *)getStringFacebookAppMissing{
    return StringFacebookAppMissing;
}
+(NSString *)getStringFacebookAppMissingMessage{
    return StringFacebookAppMissingMessage;
}
+(NSString *)getStringError{
    return StringError;
}
+(NSString *)getStringErrorMessage{
    return StringErrorMessage;
}
+(NSString *)getStringNetworkError{
    return StringNetworkError;
}
+(NSString *)getStringNetworkErrorMessage{
    return StringNetworkErrorMessage;
}
+(NSString *)getStringAudioError{
    return StringAudioStreamingError;
}
@end
