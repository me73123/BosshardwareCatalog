//
//  VipViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "VipViewController.h"
#import "UIAlertUtil.h"
#import "AlertViewController.h"

@interface VipViewController ()
@property (weak, nonatomic) IBOutlet UIView *view_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_id;
@property (weak, nonatomic) IBOutlet UITextField *tf_id;
@property (weak, nonatomic) IBOutlet UILabel *lb_passwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_passwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;

//action
- (IBAction)clickLogin:(id)sender;
@end

@implementation VipViewController{
    LoadingViewController* loadingCtrl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadString];
    
    //background tap 每個都要分開寫
    UITapGestureRecognizer* backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view_bg addGestureRecognizer:backgroundTap];
    //用全域變數,不然螢幕旋轉會有問題
    loadingCtrl = [LoadingViewController createLoadingViewController:NSLocalizedString(@"loading",nil)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - ui
-(void)loadString{
    [self setCommonText:self.lb_title text:NSLocalizedString(@"vip", nil)];
    [self setCommonText:self.lb_id text:NSLocalizedString(@"id", nil)];
    [self setCommonText:self.lb_passwd text:NSLocalizedString(@"pwd", nil)];
    [self setCommonButton:self.btn_login text:NSLocalizedString(@"login", nil)];
    
    self.tf_passwd.secureTextEntry = YES;
}

#pragma mark - action
-(void)backgroundTapped:(UITapGestureRecognizer*)recognizer {
    [self.tf_id resignFirstResponder];
    [self.tf_passwd resignFirstResponder];
}

- (IBAction)clickLogin:(id)sender {
    [self backgroundTapped:nil];
    NSString* userid = self.tf_id.text;
    NSString* pwd = self.tf_passwd.text;
    if([TextUtils isEmpty:userid]){
        [[[[iToast makeText:NSLocalizedString(@"toast_input_id",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        self.tf_id.text = @"";
        self.tf_passwd.text = @"";
    }else if ([TextUtils isEmpty:pwd]){
        [[[[iToast makeText:NSLocalizedString(@"toast_input_pwd",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        self.tf_id.text = @"";
        self.tf_passwd.text = @"";
    }else{
        [self login:userid pwd:pwd];
    }
}

#pragma mark - api
-(void)login:(NSString*)userid pwd:(NSString*)pwd{
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz login:userid passwd:pwd completionHandler:^(ApiOutLogin *apiOut, NSError *error) {
        [loadingCtrl close];
        if(error==nil){
            if(![TextUtils isEmpty:apiOut.resultcode]){
                // 登入成功
                if ([apiOut.resultcode isEqualToString:@"200"]) {
                    self.tf_id.text = @"";
                    self.tf_passwd.text = @"";
                    // 記錄登入資訊
                    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setBool:YES forKey:ISLOGIN];
                    [userDefaults synchronize]; //馬上修改standardUserDefaults
                    
                    // 顯示更新alert
                    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
                    AlertViewController* alertCtrl = [[app storyboardWithName:@"OtherFunctional"] instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    alertCtrl.configureCallback = ^() {
                        [self.mainCtrl changeViewCtrl:VIP_CELL];
                    };
                    alertCtrl.hiddenCancel = YES;
                    
                    //轉頁
                    [self presentViewController:alertCtrl animated:YES completion:^{
                        //顯示alert後再改變文字,避免被storyboard蓋過
                        alertCtrl.lb_title.text =  NSLocalizedString(@"prompt", nil);
                        alertCtrl.lb_msg.text = NSLocalizedString(@"alert_vip_refresh", nil);
                        //背景設重複影像遮罩
                        UIImage *image = [UIImage imageNamed:@"ok.png"];
                        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                        [alertCtrl.btn_configure setBackgroundImage:resizableImage forState:UIControlStateNormal];
                    }];
                } else if ([apiOut.resultcode isEqualToString:@"1003"]) {
                    [[[[iToast makeText:NSLocalizedString(@"toast_pwd_error",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                } else if ([apiOut.resultcode isEqualToString:@"1006"]) {
                    [[[[iToast makeText:NSLocalizedString(@"toast_id_error",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                } else {
                    NSLog(@"resultCode:%@", apiOut.resultcode);
                    [[[[iToast makeText:NSLocalizedString(@"toast_login_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                }
            }else{
                NSLog(@"login resultcode is isEmpty");
                [[[[iToast makeText:NSLocalizedString(@"toast_login_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"login error:%@", error.localizedDescription);
            [[[[iToast makeText:NSLocalizedString(@"toast_login_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
