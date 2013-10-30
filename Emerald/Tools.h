//
//  Tools.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface Tools : NSObject
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (BOOL)isNetWorkConnectionAvailable;
+ (void)DisplayNetworkAlert;
+ (NSString *)flattenHTML:(NSString *)html;
@end
