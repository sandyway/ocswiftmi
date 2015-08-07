//
//  CodeDetailViewcontroller.m
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CodeDetailViewcontroller.h"

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

}

@end
