//
//  PostDetailController.h
//  swiftmi_oc
//
//  Created by 李晓蒙 on 15/8/7.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, strong)id article;
@end
