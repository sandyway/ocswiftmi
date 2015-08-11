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
#import "WebViewController.h"

@interface PostDetailController()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *inputReply;
@property (weak, nonatomic) IBOutlet UIView *inputWrapView;
@property (nonatomic)NSInteger postId;
@property (nonatomic,copy)NSDictionary* postDetail;
@property (nonatomic)BOOL keyboardShow;

@end

@implementation PostDetailController
-(void) viewDidLoad{
    [super viewDidLoad];
    
     NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setViews];
    
    self.inputReply.layer.borderWidth = 1;
    self.inputReply.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.9].CGColor;
}
-(void) viewDidAppear:(BOOL)animated{
    self.userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.swiftmi.handoff.view-web"];
    self.userActivity.title = @"view article on mac";
    NSString* urlString = [NSString stringWithFormat:@"%@/topic/%d.html", [[DataManager manager] getBaseUrl], [[self.article objectForSafeKey:@"postId"] intValue]];
    NSURL* url = [NSURL URLWithString:urlString];
    self.userActivity.webpageURL = url;
    [self.userActivity becomeCurrent];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.userActivity invalidate];
}

-(void) keyboardWillShow:(NSNotification*)notification{
    NSDictionary* info = notification.userInfo;
    
    double duration = [[info objectForSafeKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginKeyboardRect = [[info objectForSafeKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForSafeKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    CGRect frame = self.view.frame;
    frame.origin.y = -endKeyboardRect.size.height;
    
    CGRect inputW = self.inputWrapView.frame;
    CGRect newFrame = CGRectMake(inputW.origin.x, inputW.origin.y-80, inputW.size.width, inputW.size.height+90);
    
    @weakify(self);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('body').css({'padding-top':'%fpx'});", endKeyboardRect.size.height]];
        
        for (NSLayoutConstraint* constraint in self.inputWrapView.constraints){
            if (constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = 80;
                break;
            }
        }
        self.view.frame = frame;
    } completion:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary* info = notification.userInfo;
    CGRect keyboardSize = [[info objectForSafeKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = keyboardSize.size.height;
    double duration = [[info objectForSafeKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.webView stringByEvaluatingJavaScriptFromString:@"$('body').css({'padding-top':'0px'});"];
        self.view.frame = frame;
        
        for (NSLayoutConstraint* constraint in self.inputWrapView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 50;
                break;
            }
        }
        
    } completion:nil];
}

-(id)GetLoadData{
    if (self.postDetail != nil) {
        return self.postDetail;
    }
    
    NSDictionary* json = @{@"comments":@[]};
    [json setValue:self.article forKey:@"topic"];
    return json;
}

-(void)loadData{
    @weakify(self);
    NSInteger topicId = [[_article objectForSafeKey:@"postId"] integerValue];
    [[DataManager manager] TopicDetail:topicId success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        NSDictionary* result = (NSDictionary*)responseObject;
        if ([[result objectForSafeKey:@"isSuc"] boolValue]) {
            self.postDetail = [result objectForSafeKey:@"result"];
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
            
            NSURL* url = [NSURL fileURLWithPath:path];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utility delayCallback:^{
                    @strongify(self);
                    //code to be executed on the main queue after delay
                    self.inputWrapView.hidden = FALSE;
                } forTotalSeconds:0.5];
                [self.webView loadRequest:request];
            });
        }
        
    } failure:^(NSError *error) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查网络设置" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:@"重试", nil];
        [alertView show];
    }];
}


-(void) setViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self.inputReply resignFirstResponder];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    
    [self startLoading];
    self.inputWrapView.hidden = TRUE;
    self.title = @"主题帖";
    [self loadData];
}


-(void)startLoading{
    [AppNotice wait];
    self.webView.hidden = TRUE;
}


-(void)stopLoading{
    self.webView.hidden = false;
    [AppNotice clear];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* reqUrl = request.URL.absoluteString;
    NSArray* params = [reqUrl componentsSeparatedByString:@"://"];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if(params.count>=2){
            NSLog(@"%@---%@",params[0],params[1]);
            if ([params[0] compare:@"html"] == NSOrderedSame&&[params[1] compare:@"docready"]==NSOrderedSame) {
                
                NSLog(@"%@---%@",params[0],params[1]);
                id data = [self GetLoadData];
                NSString* dataRawString = [Utility rawString:data encoding:NSUTF8StringEncoding opt:NSJSONWritingPrettyPrinted];
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"article.render(%@);", dataRawString]];
                
            }else if ([params[0] compare:@"html"] == NSOrderedSame&&[params[1] compare:@"contentready"]==NSOrderedSame) {
                
                [self stopLoading];
                
            } else if([params[0] compare:@"http"] == NSOrderedSame||[params[0] compare:@"https"]==NSOrderedSame){
                WebViewController* webViewController = (WebViewController*)[Utility GetViewController:@"webViewController"];
                webViewController.webUrl = reqUrl;
                [self presentViewController:webViewController animated: true completion: nil];

            }
        }
    });
    if([params[0] compare:@"http"] == NSOrderedSame||[params[0] compare:@"https"]==NSOrderedSame) {
        return FALSE;
    }
    return TRUE;
    
}
- (IBAction)shareClick:(id)sender {
    [self share];
}

-(void)share{
    id data = [self GetLoadData];
    NSString* title = [[data objectForSafeKey:@"topic"] objectForSafeKey:@"title"];
    NSInteger postId = [[[data objectForSafeKey:@"topic"] objectForSafeKey:@"postId"] integerValue];
    NSString* url = [NSString stringWithFormat:@"%@/topic/%ld.html", [[DataManager manager] getBaseUrl], postId];
    NSString* desc = [[data objectForSafeKey:@"topic"] objectForSafeKey:@"desc"];
    
    NSString* img = [self.webView stringByEvaluatingJavaScriptFromString:@"article.getShareImage()"];
    
    [Utility share:title desc:desc imgUrl:img linkUrl:url];
    
}

- (IBAction)replyClick:(id)sender {
    NSString* msg = _inputReply.text;
    _inputReply.text = @"";
    if (msg == nil) {
        return;
    }

    NSNumber *postId = @([[_article objectForSafeKey:@"postId"] integerValue]);
    NSDictionary* params = @{@"postId":postId,@"content":msg};
    @weakify(self);
    [[DataManager manager] TopicComment:params success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if ([[result objectForSafeKey:@"isSuc"] boolValue]){
            [AppNotice showNoticeWithText:NoticeTypeSuccess text:@"评论成功" autoClear:TRUE];
            NSString* resultRawString = [Utility rawString:[result objectForSafeKey:@"result"] encoding:NSUTF8StringEncoding opt:NSJSONWritingPrettyPrinted];
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"article.addComment(%@);", resultRawString]];
        }else{
            [AppNotice showNoticeWithText:NoticeTypeError text:@"评论失败" autoClear:TRUE];
        }
    } failure:^(NSError *error) {
        [AppNotice showNoticeWithText:NoticeTypeError text:@"网络异常" autoClear:TRUE];
        return;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [AppNotice clear];
}

@end
