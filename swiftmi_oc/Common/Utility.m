//
//  Utility.m
//  swiftmi_oc
//
//  Created by wings on 7/31/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "Utility.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@implementation Utility

+(NSString*) formatDate:(NSDate*)date{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
   return [fmt stringFromDate:date];
}

+(id) GetViewController:(NSString*)controllerName{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [mainStoryboard instantiateViewControllerWithIdentifier:controllerName];
}

+(NSData*)rawData:(id)object opt:(NSJSONWritingOptions)opt error:(NSError**)error{
    return [NSJSONSerialization dataWithJSONObject:object options:opt error:error];
}

+(NSString*)rawString:(id)object encoding:(int)encoding opt:(NSJSONWritingOptions)opt{
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        NSData* data = [self rawData:object opt:opt error:nil];
        if (data == nil) {
            return nil;
        }else {
            return [[NSString alloc] initWithData:data encoding:encoding];
        }
    }else if ([object isKindOfClass:[NSString class]]){
        return object;
    }else if ([object isKindOfClass:[NSNumber class]]){
        return [object stringValue];
    }else if([object isKindOfClass:[NSNull class]]){
        return @"null";
    }else{
        return nil;
    }
}

+(void)share:(NSString*)title desc:(NSString*)desc imgUrl:(NSString*)imgUrl linkUrl:(NSString*)linkUrl{
    if (imgUrl == nil) {
        imgUrl = @"http://swiftmi.qiniudn.com/swiftmi180icon.png";
    }
    
    NSMutableDictionary* shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imgUrl
                                        url:[NSURL URLWithString:linkUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"分享成功"
                                                                delegate:self
                                                       cancelButtonTitle:@"ok"
                                                       otherButtonTitles:nil];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }];    
}

+(void)delayCallback: (void(^)(void))callback forTotalSeconds: (double)delayInSeconds{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if(callback){
            callback();
        }
        
    });
    
}

+(void)showMessage:(NSString*)msg{
    [self showMessageWithTitle:msg title:@"提醒"];
}

+(void)showMessageWithTitle:(NSString *)msg title:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
