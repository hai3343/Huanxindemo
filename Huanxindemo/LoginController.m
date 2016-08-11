//
//  LoginController.m
//  Huanxindemo
//
//  Created by happying on 16/8/9.
//  Copyright © 2016年 jzg. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
@property (nonatomic,strong) UITextField *username;
@property (nonatomic,strong) UITextField *password;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _username = [[UITextField alloc] init];
    _username.backgroundColor = [UIColor grayColor];
    _username.placeholder = @"账号";
    [self.view addSubview:_username];
    
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
        make.size.equalTo(CGSizeMake(200, 50));
    }];
    
    _password = [[UITextField alloc] init];
    _password.backgroundColor = [UIColor grayColor];
    _password.placeholder = @"密码";
    [self.view addSubview:_password];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_username.mas_bottom).offset(20);
        make.size.equalTo(CGSizeMake(200, 50));
    }];
    
    
    UIButton *loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.tag = 1001;
    [loginbtn setTitle:@"登录" forState:0];
    [loginbtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:loginbtn];
    [loginbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_password).offset(-35);
        make.top.equalTo(_password.mas_bottom).offset(20);
        make.size.equalTo(CGSizeMake(60, 40));
    }];
    
    UIButton *registbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [registbtn setTitle:@"注册" forState:0];
    [registbtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    registbtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:registbtn];
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_password).offset(35);
        make.top.equalTo(_password.mas_bottom).offset(20);
        make.size.equalTo(CGSizeMake(60, 40));
    }];
    
    // Do any additional setup after loading the view.
}


- (void)btnclick:(UIButton*)btn
{

    if (btn.tag == 1001) {
        //异步登陆账号
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] loginWithUsername:_username.text password:_password.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                if (!error) {
                    //设置是否自动登录
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    
                    //获取数据库中数据
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[EMClient sharedClient] dataMigrationTo3];
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [[ChatDemoHelper shareHelper] asyncGroupFromServer];
//                            [[ChatDemoHelper shareHelper] asyncConversationFromDB];
//                            [[ChatDemoHelper shareHelper] asyncPushOptions];
//                            [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                            //发送自动登陆状态通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                            
                            //保存最近一次登录用户名
                            [weakself saveLastLoginUsername];
                        });
                    });
                }
                else {
                    NSLog(@"登录失败");
                }
            });
        });
    }else{
    
        
        [self  regist];
     
    }


}
- (void)regist
{

    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] registerWithUsername:weakself.username.text password:weakself.password.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                NSLog(@"注册成功");
            }else{
            
            NSLog(@"注册失败");
            }
        });
    });



}
#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
