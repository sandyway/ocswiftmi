//
//  Utility.h
//  swiftmi_oc
//
//  Created by wings on 7/31/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString*) formatDate:(NSDate*)date;
+(id) GetViewController:(NSString*)controllerName;
+(NSString*)rawString:(id)object encoding:(int)encoding opt:(NSJSONWritingOptions)opt;
+(void)share:(NSString*)title desc:(NSString*)desc imgUrl:(NSString*)imgUrl linkUrl:(NSString*)linkUrl;
@end
