//
//  RegisterController.h
//  swiftmi_oc
//
//  Created by swing on 15/8/12.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *btnReg;

@end
