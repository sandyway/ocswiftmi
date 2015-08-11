//
//  ProfileHeaderView.h
//  swiftmi_oc
//
//  Created by wings on 8/10/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface ProfileHeaderView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) BOOL (^tapLoginCallBack)(void);
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *follower;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *profileBg;

+(ProfileHeaderView*)viewFromNib;
-(void)setData:(Users*)user;
-(void)resetData;
-(void)scrollViewDidScroll:(UIScrollView*)scrollView;
@end
