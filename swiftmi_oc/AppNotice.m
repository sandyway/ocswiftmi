//
//  AppNotice.m
//  swiftmi_oc
//
//  Created by wings on 8/5/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "AppNotice.h"

@interface AppNotice()

@end

@implementation AppNotice
static UIView* rv = nil;
static NSMutableArray* mainViews = nil;

+(void)CheckInit{
    if (rv == nil){
        rv = (UIView*)[UIApplication sharedApplication].keyWindow.subviews.firstObject;
        mainViews = [NSMutableArray new];
    }
}


+(void)clear{
    [self CheckInit];
    for (UIView* i in mainViews) {
        [i removeFromSuperview];
    }
}

+(void)wait{
    UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    mainView.layer.cornerRadius = 12;
    mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIActivityIndicatorView* ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.frame = CGRectMake(21, 21, 36, 36);
    [ai startAnimating];
    [mainView addSubview:ai];
    
    mainView.center = rv.center;
    [rv addSubview:mainView];
}

+(void)showText:(NSString*)text{
    CGRect frame = CGRectMake(0, 0, 200, 60);
    UIView* mainView = [[UIView alloc] initWithFrame:frame];
    mainView.layer.cornerRadius = 12;
    mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [mainView addSubview:label];
    
    mainView.center = rv.center;
    [rv addSubview:mainView];
    
    [mainViews addObject:mainView];
}

+(void)showNoticeWithText:(NoticeType)type text:(NSString*)text autoClear:(BOOL)autoClear{
    UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    mainView.layer.cornerRadius = 10;
    mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

    UIImage* image = [[UIImage alloc] init];
    switch (type) {
        case NoticeTypeSuccess:
            image = NoticeSDK.imageOfCheckmark;
            break;
        case NoticeTypeError:
            image = NoticeSDK.imageOfCross;
            break;
        case NoticeTypeInfo:
            image = NoticeSDK.imageOfInfo;
            break;
        default:
            break;
    }
    UIImageView* checkmarkView = [[UIImageView alloc] initWithImage:image];
    checkmarkView.frame = CGRectMake(27, 15, 36, 36);
    [mainView addSubview:checkmarkView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 90, 16)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:label];
    
    mainView.center = rv.center;
    [rv addSubview:mainView];
    
    [mainViews addObject:mainView];
    
    if (autoClear) {
        [self performSelector:@selector(hideNotice:) withObject:mainView afterDelay:2];
    }
}

+(void)hideNotice:(id)sender{
    if ([sender isKindOfClass:[UIView class]]) {
        [sender removeFromSuperview];
    }
}

@end


@implementation NoticeSDK

+(void)draw:(NoticeType)type{
     UIBezierPath* checkmarkShapePath = [UIBezierPath  bezierPath];
    
    // draw circle
    [checkmarkShapePath moveToPoint:CGPointMake(36, 18)];
    [checkmarkShapePath addArcWithCenter:CGPointMake(18, 18) radius:17.5 startAngle:0 endAngle:(CGFloat)(M_PI*2) clockwise:TRUE];
    
    [checkmarkShapePath closePath];
    
    switch (type) {
        case NoticeTypeSuccess: // draw checkmark
            [checkmarkShapePath moveToPoint:CGPointMake(10, 18)];
            [checkmarkShapePath addLineToPoint:CGPointMake(16, 24)];
            [checkmarkShapePath addLineToPoint:CGPointMake(27, 13)];
            [checkmarkShapePath moveToPoint:CGPointMake(10, 18)];
            [checkmarkShapePath closePath];
            break;
        case NoticeTypeError: // draw X
            [checkmarkShapePath moveToPoint:CGPointMake(10, 10)];
            [checkmarkShapePath addLineToPoint:CGPointMake(26, 26)];
            [checkmarkShapePath moveToPoint:CGPointMake(10, 26)];
            [checkmarkShapePath addLineToPoint:CGPointMake(26, 10)];
            [checkmarkShapePath moveToPoint:CGPointMake(10, 10)];
            [checkmarkShapePath closePath];
            break;
        case NoticeTypeInfo:
        {
            [checkmarkShapePath moveToPoint:CGPointMake(18, 6)];
            [checkmarkShapePath addLineToPoint:CGPointMake(18, 22)];
            [checkmarkShapePath moveToPoint:CGPointMake(18, 6)];
            [checkmarkShapePath closePath];
            
            [[UIColor whiteColor] setStroke];
            [checkmarkShapePath stroke];
            
            UIBezierPath* checkmarkShapePath = [UIBezierPath  bezierPath];
            [checkmarkShapePath moveToPoint:CGPointMake(18, 27)];
            [checkmarkShapePath addArcWithCenter:CGPointMake(18, 27) radius:1 startAngle:0 endAngle:(CGFloat)(M_PI*2) clockwise:TRUE];
            [checkmarkShapePath closePath];
            
            [[UIColor whiteColor] setFill];
            [checkmarkShapePath fill];
        }
            break;
        default:
            break;
    }
    [[UIColor whiteColor] setStroke];
    [checkmarkShapePath stroke];
}

+(UIImage*)imageOfCheckmark{
    static UIImage* imageOfCheckmark = nil;
    if (imageOfCheckmark != nil) {
        return imageOfCheckmark;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), FALSE, 0);
    [NoticeSDK draw:NoticeTypeSuccess];
    
    imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOfCheckmark;
}
+(UIImage*)imageOfCross{
    static UIImage* imageOfCross = nil;
    
    if (imageOfCross != nil) {
        return imageOfCross;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), FALSE, 0);
    [NoticeSDK draw:NoticeTypeError];
    
    imageOfCross = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOfCross;
}
+(UIImage*)imageOfInfo{
    static UIImage* imageOfInfo = nil;
    
    if (imageOfInfo != nil) {
        return imageOfInfo;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), FALSE, 0);
    [NoticeSDK draw:NoticeTypeInfo];
    
    imageOfInfo = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOfInfo;
}

@end