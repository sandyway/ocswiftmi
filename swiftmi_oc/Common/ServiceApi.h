//
//  ServiceApi.h
//  swiftmi_oc
//
//  Created by 李晓蒙 on 15/8/7.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceApi : NSObject
+(NSString*) getTopicShareDetail:(int)topicId;
+(NSString*) getTopicDetail:(int)topicId;
@end
