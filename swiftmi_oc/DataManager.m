//
//  DataManager.m
//  swiftmi_oc
//
//  Created by wings on 7/31/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "DataManager.h"
#import <AFNetworking.h>
#import "FXKeychain.h"

@interface DataManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy) NSString *userAgentMobile;
@property (nonatomic, copy) NSString *userAgentPC;

@end

@implementation DataManager

-(instancetype)init{
    if (self = [super init]) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        self.userAgentMobile = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        self.userAgentPC = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14";
        
        self.preferHttps = kSetting.preferHttps;
        self.token = [[FXKeychain defaultKeychain] objectForKey:tokenName];
    }
    return self;
}

- (void)setPreferHttps:(BOOL)preferHttps {
    _preferHttps = preferHttps;
    
    NSURL *baseUrl;
    
    if (preferHttps) {
        baseUrl = [NSURL URLWithString:@"https://demo.swiftmi.com"];
    } else {
        baseUrl = [NSURL URLWithString:@"http://demo.swiftmi.com"];
    }
    
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer = serializer;
}

+ (instancetype)manager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

- (NSURLSessionDataTask *)requestWithMethod:(RequestMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSError *error))failure  {
    // stateBar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // Any common handler for Response
        
        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        
        
        success(task, responseObject);
        
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
//    [self.manager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    
    if (self.token != nil) {
        [self.manager.requestSerializer setValue:self.token forHTTPHeaderField:@"token"];
    }
    [self.manager.requestSerializer setValue:@"com.swiftmi.demo" forHTTPHeaderField:@"clientid"];
    [self.manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"appversion"];
    
    if (method == RequestMethodJSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            Log(@"Error: \n%@", [error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == RequestMethodHTTPGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == RequestMethodHTTPPOST) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    if (method == RequestMethodHTTPGETPC) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        [self.manager.requestSerializer setValue:self.userAgentPC forHTTPHeaderField:@"User-Agent"];
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    return task;
}

- (NSURLSessionDataTask *)getTopicList:(int)maxId count:(int)count
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString* url = [NSString stringWithFormat:@"/api/topic/list2/%d/%d", maxId, count];
    return [self requestWithMethod:RequestMethodJSONGET URLString:url parameters:nil success:success failure:failure];    
}

- (NSURLSessionDataTask *)UserLogin:(NSDictionary *)parameters
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSString* url = @"/api/user/login";
    return [self requestWithMethod:RequestMethodHTTPPOST URLString:url parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)getCodeList:(int)maxId count:(int)count
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString* url = [NSString stringWithFormat:@"/api/sharecode/list/%d/%d", maxId, count];
    return [self requestWithMethod:RequestMethodJSONGET URLString:url parameters:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)getCodeDetail:(int)codeId
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSString* url = [NSString stringWithFormat:@"/api/sharecode/%d", codeId];
    return [self requestWithMethod:RequestMethodJSONGET URLString:url parameters:nil success:success failure:failure];
}


@end
