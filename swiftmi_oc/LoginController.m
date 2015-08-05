//
//  LoginController.m
//  swiftmi_oc
//
//  Created by wings on 8/3/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
@property (nonatomic, strong)UIActivityIndicatorView* loadingView;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self setView];
}

-(void) setView{
    self.password.secureTextEntry = TRUE;
}

-(void)showMsg:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)login{
    if (_username.text.length == 0) {
        [self showMsg:@"用户名不能为空"];
        return;
    }
    if (_password.text.length == 0 || _password.text.length < 6) {
        [self showMsg:@"密码不能为空且长度需要大于6位数"];
        return;
    }
    
    NSString* loginname = _username.text;
    NSString* loginpass = _password.text;
    
    NSDictionary* params = @{@"username":loginname, @"password":loginpass};
    
    [self pleaseWait];
    
    self.loginBtn.enabled = false;
    [self.loginBtn setTitle:@"登录ing" forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogin:(UIButton *)sender {
}


- (IBAction)regAction:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
