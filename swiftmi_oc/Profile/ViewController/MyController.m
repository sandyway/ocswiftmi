//
//  MyController.m
//  swiftmi_oc
//
//  Created by wings on 8/10/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "MyController.h"
#import "ProfileHeaderView.h"
#import "Users.h"
#import "FXKeychain.h"
#import "UserDal.h"
#import "LoginController.h"

@interface MyController ()
@property (nonatomic,strong)ProfileHeaderView* profileHeaderView;
@property (nonatomic, strong)Users* currentUser;
@end

@implementation MyController

-(void)viewDidAppear:(BOOL)animated{
    [self loadCurrentUser];
    [AppNotice clear];
}

-(void)loadCurrentUser{
    if (_currentUser == nil) {
        id token = [[FXKeychain defaultKeychain] objectForKey:tokenName];
        if (token != nil) {
            UserDal* dalUser = [UserDal new];
            _currentUser = [dalUser getCurrentUser];
        }
        
        if (_currentUser != nil) {
            [_profileHeaderView setData:self.currentUser];
            self.emailLabel.text = self.currentUser.email;
            self.signatureLabel.text = self.currentUser.signature;
            self.logoutCell.hidden = FALSE;
        }else{
            self.logoutCell.hidden = true;
        }
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setView];
}

-(void)setView{
    _profileHeaderView = [ProfileHeaderView viewFromNib];
    _profileHeaderView.frame = CGRectMake(0,0,self.view.frame.size.width, 280);
    self.tableView.tableHeaderView = _profileHeaderView;
    @weakify(self)
    _profileHeaderView.tapLoginCallBack = ^(void){
        @strongify(self);
        LoginController* toViewController = (LoginController*)[Utility GetViewController:@"loginController"];
        [self.navigationController pushViewController:toViewController animated:TRUE];
        return  (BOOL)TRUE;
    };
}

-(void)logout{
    if ([[FXKeychain defaultKeychain] objectForKey:tokenName] != nil){
        [[FXKeychain defaultKeychain] removeObjectForKey:tokenName];
        self.currentUser = nil;
        [DataManager manager].token = nil;
    }
    self.emailLabel.text = @"";
    self.signatureLabel.text = @"";
    [self.profileHeaderView resetData];
    [self.tableView reloadData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.profileHeaderView scrollViewDidScroll:scrollView];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self logout];
    } else if (indexPath.section == 1 && indexPath.row == 0){
        NSURL* url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=993402332"];
        [[UIApplication sharedApplication] openURL:url];
    }
}







@end
