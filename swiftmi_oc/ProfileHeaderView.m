//
//  ProfileHeaderView.m
//  swiftmi_oc
//
//  Created by wings on 8/10/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "ProfileHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileHeaderView()

@property (nonatomic) BOOL hasLogin;
@property (nonatomic)CGRect initialFrame;
@property (nonatomic)CGFloat initialHeight;
@end

@implementation ProfileHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _avatar.layer.cornerRadius = 50;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.masksToBounds = TRUE;
    
    self.follower.text = @"0";
    self.following.text = @"0";
    self.userName.text = @"未登录";
    self.score.text = @"0";
    
    _initialFrame = _profileBg.frame;
    _initialHeight = _initialFrame.size.height;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogin:)];
    
    self.avatar.userInteractionEnabled = true;
    [self.avatar addGestureRecognizer:tap];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogin:)];
    
    _userName.userInteractionEnabled = TRUE;
    [_userName addGestureRecognizer:tap2];
}

-(void) tapLogin:(UITapGestureRecognizer*)recognizer{
    if (_tapLoginCallBack != nil && _hasLogin == FALSE) {
        _tapLoginCallBack();
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return TRUE;
}

-(void)setData:(Users*)user{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:nil];

    self.follower.text = [user.follower_count stringValue];
    self.following.text = [user.following_count stringValue];
    self.userName.text = user.username;
    self.score.text = [user.points stringValue];
    _hasLogin = TRUE;
}

-(void)resetData{
    _avatar.image = nil;
    _follower.text = @"0";
    _following.text = @"0";
    _userName.text = @"点击登录";
    self.score.text = @"0";
    _hasLogin = FALSE;
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    Log(@"scrolling contentOffset.y:%f, scrollView.contentInset.top:%f",scrollView.contentOffset.y, scrollView.contentInset.top);
    if (scrollView.contentOffset.y < 0) {
        CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
        _initialFrame.origin.y = offsetY;
        _initialFrame.size.height = _initialHeight - offsetY;
        Log(@"_initialFrame.origin.y:%f,_initialFrame.size.height:%f", _initialFrame.origin.y, _initialFrame.size.height);
        
        _profileBg.frame = _initialFrame;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(ProfileHeaderView*)viewFromNib{
    NSArray* views = [[UINib nibWithNibName:@"ProfileHeaderView" bundle:nil] instantiateWithOwner:nil options:nil];
    for (id view in views) {
        if ([view isKindOfClass:self]) {
            return (ProfileHeaderView*)view;
        }
    }
    return nil;
}

@end
