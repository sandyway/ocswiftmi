//
//  RegisterController.m
//  swiftmi_oc
//
//  Created by swing on 15/8/12.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "RegisterController.h"
#import "FXKeychain.h"
#import "UserDal.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.password.secureTextEntry = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)recoverState{
    self.btnReg.enabled = true;
    [self.btnReg setTitle:@"注册" forState:UIControlStateNormal];
    [AppNotice clear];
}

- (IBAction)regClick:(id)sender {
    if ([_username.text length] == 0) {
        [Utility showMessage:@"用户名不能为空"];
        return;
    }
    if ([_password.text length] < 6) {
        [Utility showMessage:@"密码不能为空且长度需要大于6位数"];
        return;
    }
    if ([_email.text length] == 0) {
        [Utility showMessage:@"email不能为空"];
        return;
    }
    
    NSDictionary* params = @{@"username":_username.text, @"password":_password.text, @"email":_email.text};
    
    self.btnReg.enabled = false;
    [self.btnReg setTitle:@"注册ing..." forState:UIControlStateNormal];
    
    [AppNotice wait];
    
    [[DataManager manager] UserRegister:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self recoverState];
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];

        if ([[result objectForSafeKey:@"isSuc"] boolValue]){
            id user = [result objectForSafeKey:@"result"];
            NSString* token = [user objectForSafeKey:@"token"];
            
            [[FXKeychain defaultKeychain] setObject:token forKey:@"token"];
            
            [DataManager manager].token = token;
            
            UserDal* dalUser = [UserDal new];
            [dalUser deleteAll];
            [dalUser addUser:user save:TRUE];
            Log(@"%@",[NSString stringWithFormat:@"%lu", (unsigned long)[self.navigationController.viewControllers count]]);
            UIViewController* toView = (UIViewController*)self.navigationController.viewControllers[[self.navigationController.viewControllers count]-3];
            if (toView != nil){
                [self.navigationController popToViewController:toView animated:TRUE];
            }else{
                [self.navigationController popViewControllerAnimated:TRUE];
            }
        }else{
            NSString* errMsg = [result objectForSafeKey:@"msg"];
            [Utility showMessageWithTitle:errMsg title:@"登录失败"];
        }
    } failure:^(NSError *error) {
        [self recoverState];
        [Utility showMessageWithTitle:@"请检查网络设置" title:@"网络异常"];
    }];
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
