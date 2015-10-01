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

-(NSString*)getBaseUrl{
    return _manager.baseURL.absoluteString;
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
//    [self.manager.requestSerializer setValue:@"com.swiftmi.demo" forHTTPHeaderField:@"clientid"];
//    [self.manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"appversion"];
    
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


- (NSURLSessionDataTask *)BookList:(NSInteger)type maxId:(NSInteger)maxId count:(NSInteger)count
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    NSString* url = [NSString stringWithFormat:@"/api/books/%ld/%ld/%ld", (long)type, (long)maxId, (long)count];
    return [self requestWithMethod:RequestMethodJSONGET URLString:url parameters:nil success:success failure:failure];
    
}

- (NSURLSessionDataTask *)TopicDetail:(NSInteger)topicId
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSError *error))failure{
    NSString* url = [NSString stringWithFormat:@"/api/topic/%ld", (long)topicId];
    return [self requestWithMethod:RequestMethodJSONGET URLString:url parameters:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)TopicComment:(NSDictionary*)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString* url = @"/api/topic/comment";
    return [self requestWithMethod:RequestMethodHTTPPOST URLString:url parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)UserRegister:(NSDictionary*)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString* url = @"/api/user/reg";
    return [self requestWithMethod:RequestMethodHTTPPOST URLString:url parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)requestHttpsWithMethod:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSError *error))failure  {
    RequestMethod method = RequestMethodHTTPPOST;
    NSString* URLString = @"/httpstest/FunkServlet";
    NSDictionary * parameters = @{@"params":@"asdftest"};
    
    //policyWithPinningMode默认为AFSSLPinningModeNone,选择AFSSLPinningModeCertificate将返回错误-1012
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证；
    securityPolicy.validatesCertificateChain = NO;
    self.manager.securityPolicy = securityPolicy;

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



@end
