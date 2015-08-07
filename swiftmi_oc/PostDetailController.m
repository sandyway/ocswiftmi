//
//  PostDetailController.m
//  swiftmi_oc
//
//  Created by 李晓蒙 on 15/8/7.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "PostDetailController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppNotice.h"
#import "ServiceApi.h"
#import "Utility.h"

@interface PostDetailController()

@property NSDictionary* postDetail;
@property IBOutlet UIWebView* webView;
@property IBOutlet UITextView* inputReply;
@property IBOutlet UIView* inputWrapView;

@end

@implementation PostDetailController
-(void) viewDidLoad{
    [super viewDidLoad];
    [self setViews];
}
-(void) viewDidAppear:(BOOL)animated{
    self.userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.swiftmi.handoff.view-web"];
    self.userActivity.title = @"view article on mac";
    self.userActivity.webpageURL = [[NSURL alloc] initWithString:[ServiceApi getTopicShareDetail:(int)[self.article valueForKey:@"postId"]]];
    [self.userActivity becomeCurrent];
}
-(void) viewDidDisappear:(BOOL)animated{
    [self.userActivity invalidate];
}
-(void) setViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.inputReply resignFirstResponder];
    self.title = @"主题帖";
    self.inputWrapView.hidden = true;
    [AppNotice wait];
    [self loadData];
}
-(void) loadData{
    AFHTTPRequestOperationManager *afnetworking_manager = [[AFHTTPRequestOperationManager alloc] init];
    [afnetworking_manager GET:[ServiceApi getTopicDetail:[[self.article objectForSafeKey:@"postId"] intValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary*result = (NSDictionary*)responseObject;
        if (result[@"isSuc"]) {
            self.postDetail = result[@"result"];
        }
        NSBundle* boundle = [NSBundle mainBundle];
        NSString* path = [boundle pathForResource:@"article" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];
            self.inputWrapView.hidden = false;
        });
    }
                      failure:^(AFHTTPRequestOperation *operation, id responseObject){
                          UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查网络设置" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:@"重试", nil];
                          [alert show];
                      }];
    
    
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* req = request.URL.absoluteString;
    NSArray* params = [req componentsSeparatedByString:@"://"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(params.count>=2){
            NSLog(@"%@---%@",params[0],params[1]);
            if ([params[0] compare:@"html"] == NSOrderedSame&&[params[1] compare:@"docready"]==NSOrderedSame) {
                
                NSLog(@"%@---%@",params[0],params[1]);
                
            }else if ([params[0] compare:@"html"] == NSOrderedSame&&[params[1] compare:@"contentready"]==NSOrderedSame) {
                
                [self stopLoading];
                
            } else if([params[0] compare:@"http"] == NSOrderedSame||[params[0] compare:@"https"]==NSOrderedSame){
            }
        }
    });
    if([params[0] compare:@"http"] == NSOrderedSame||[params[0] compare:@"https"]==NSOrderedSame) {
        return FALSE;
    }
    return TRUE;
    
}
-(void)stopLoading{
    self.webView.hidden = false;
    [AppNotice clear];
}
-(NSDictionary*)GetLoadData {
    
    if (self.postDetail != nil) {
        return self.postDetail;
    }
    NSDictionary* dic = self.article;
    return dic;

}

@end
