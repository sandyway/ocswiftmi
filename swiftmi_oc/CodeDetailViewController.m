//
//  CodeDetailViewcontroller.m
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CodeDetailViewcontroller.h"
#import "WebViewController.h"

@interface CodeDetailViewController ()
@property (nonatomic, strong)id theNewShareCode;
@end

@implementation CodeDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setViews];
}

-(void)setViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    [self startLoading];
    
    [self loadData];
}

-(void)startLoading{
    [AppNotice wait];
    self.webView.hidden = TRUE;
}

-(void)stopLoading{
    self.webView.hidden = FALSE;
    [AppNotice clear];
}

-(NSDictionary*)GetLoadData{
    if (_theNewShareCode != nil) {
        return self.theNewShareCode;
    }
    NSDictionary* dic = @{@"comments":@{}};
    [dic setValue:self.shareCode forKey:@"code"];
    return dic;
}

-(void)loadData{
    @weakify(self);
    int codeId = [[_shareCode objectForSafeKey:@"codeId"] intValue];
    [[DataManager manager] getCodeDetail:codeId success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        
        NSDictionary* result = (NSDictionary*)responseObject;
        
        if ([[result objectForSafeKey:@"isSuc"] boolValue]) {
            self.theNewShareCode =  [result objectForSafeKey:@"result"];
        }
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"html"];
        
        NSURL* url = [NSURL fileURLWithPath:path];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];
        });
    } failure:^(NSError *error) {
        [AppNotice showNoticeWithText:NoticeTypeError text:@"网络异常" autoClear:TRUE];
    }];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    var reqUrl=request.URL!.absoluteString
    NSString* reqUrl = request.URL.absoluteString;
//    var params = reqUrl!.componentsSeparatedByString("://")
    NSArray* params = [reqUrl componentsSeparatedByString:@"://"];
    
//    dispatch_async(dispatch_get_main_queue(),{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        if(params.count>=2){
            if ([params[0] compare:@"html"] == NSOrderedSame && [params[1] compare:@"docready"] == NSOrderedSame) {
                NSDictionary* data = [self GetLoadData];
                
                NSString* articleContent =  [Utility rawString:data encoding:NSUTF8StringEncoding opt:NSJSONWritingPrettyPrinted];
                NSString* js = [NSString stringWithFormat:@"article.render(%@);",articleContent];
                [self.webView stringByEvaluatingJavaScriptFromString:js];
                
                
            }
            else if ([params[0] compare:@"html"] == NSOrderedSame && [params[1] compare:@"contentready"] == NSOrderedSame) {
                //doc content ok
                [self stopLoading];
            }
            else if ([params[0] compare:@"http"] == NSOrderedSame || [params[0] compare:@"https"] == NSOrderedSame) {
                WebViewController* webViewController = (WebViewController*)[Utility GetViewController:@"webViewController"];
                webViewController.webUrl = reqUrl;
                [self presentViewController:webViewController animated: true completion: nil];
            }
            
        }
    });
    
    if ([params[0] compare:@"http"] == NSOrderedSame || [params[0] compare:@"https"] == NSOrderedSame) {
        return FALSE;
    }
    return TRUE;
}

-(void)viewDidDisappear:(BOOL)animated{
    [AppNotice clear];
    [self.userActivity invalidate];
    [super viewDidDisappear:animated];
}

@end
