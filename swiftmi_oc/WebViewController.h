//
//  WebViewController.h
//  swiftmi_oc
//
//  Created by swing on 15/8/8.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)NSString* webUrl;
@property (nonatomic)BOOL isPop;
@end
