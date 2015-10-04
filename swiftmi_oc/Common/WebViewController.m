//
//  WebViewController.m
//  swiftmi_oc
//
//  Created by swing on 15/8/8.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPop = FALSE;
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    if (self.webUrl != nil) {
        [AppNotice wait];
        
        NSURL* url = [[NSURL alloc] initWithString:self.webUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    if (self.title == nil) {
        self.title = @"内容";
    }
    
    [self setWebViewTop];
}

-(void)setWebViewTop{
    if (self.isPop) {
        for (NSLayoutConstraint* constraint in self.view.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeTop) {
                constraint.constant = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
                break;
            }
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setWebViewTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stopAndClose:(id)sender {
    [self.webView stopLoading];
    
    [AppNotice clear];
    if (self.isPop) {
        [self.navigationController popViewControllerAnimated:true];
        
    }else {
        [self dismissViewControllerAnimated:true completion: nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [AppNotice clear];
}

- (IBAction)refreshWebView:(id)sender {
    [_webView reload];
}

- (IBAction)rewindWebView:(id)sender {
    [_webView goBack];
}

- (IBAction)forwardWebView:(id)sender {
    [_webView goForward];
}

- (IBAction)shareClick:(id)sender {
    NSURL* url = [NSURL fileURLWithPath:self.webView.request.URL.absoluteString];
    
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (url != nil) {
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[title,url] applicationActivities: nil];
        [self presentViewController:activityViewController animated: true completion:nil];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [AppNotice clear];
    [AppNotice wait];
    return TRUE;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [AppNotice clear];
    self.title =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [AppNotice clear];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [AppNotice clear];
}

@end
