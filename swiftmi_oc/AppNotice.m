//
//  AppNotice.m
//  swiftmi_oc
//
//  Created by wings on 8/5/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "AppNotice.h"

@interface AppNotice()
@property(nonatomic, strong)NSArray* mainViews;

@end

@implementation AppNotice

+(void)clear{
[UIApplication sharedApplication].keyWindow.subviews.firstObject
}

+(void)wait{
    
}

+(void)showText:(NSString*)text{
    
}

+(void)showNoticeWithText:(NoticeType)type text:(NSString*)text autoClear:(BOOL)autoClear{
    
}



@end
