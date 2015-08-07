//
//  CodeDetailViewcontroller.h
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeDetailViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)id shareCode;
@end
