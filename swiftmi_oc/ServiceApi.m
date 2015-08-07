//
//  ServiceApi.m
//  swiftmi_oc
//
//  Created by 李晓蒙 on 15/8/7.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "ServiceApi.h"

@implementation ServiceApi
static NSString* host = @"http://demo.swiftmi.com";
+(NSString*) getTopicShareDetail:(int)topicId {
    return [NSString stringWithFormat:@"%@/topic/%d",host,topicId];
}
+(NSString*) getTopicDetail:(int)topicId {
    return [NSString stringWithFormat:@"%@/api/topic/%d",host,topicId];
}
@end
