//
//  VipNewsViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/2.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "VipNewsViewController.h"
#import "NewsListDelegate.h"

@interface VipNewsViewController (){
    NewsListDelegate* newsListDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;
@property (weak, nonatomic) IBOutlet UILabel *lb_newsTitle;
@property (weak, nonatomic) IBOutlet UITableView *tv_news;

//action
- (IBAction)clickLogout:(UIButton *)sender;
@end

@implementation VipNewsViewController{
    LoadingViewController* loadingCtrl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadString];
    [self loadData];
    //用全域變數,不然螢幕旋轉會有問題
    loadingCtrl = [LoadingViewController createLoadingViewController:NSLocalizedString(@"loading",nil)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNews];
}

#pragma mark - ui
-(void)loadString{
    [self setCommonText:self.lb_title text:NSLocalizedString(@"vip", nil)];
    [self setCommonText:self.lb_newsTitle text:NSLocalizedString(@"vipMsg", nil)];
    [self setCommonButton:self.btn_logout text:NSLocalizedString(@"logout", nil)];
}

#pragma mark - other function
-(void)loadData{
    newsListDelegate = [[NewsListDelegate alloc]initWithController:self TableView:self.tv_news list:[[NSArray alloc]init]];
    self.tv_news.delegate = newsListDelegate;
    self.tv_news.dataSource = newsListDelegate;
    self.tv_news.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - action
- (IBAction)clickLogout:(UIButton *)sender {
    NSLog(@"clickLogout");
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:ISLOGIN];
    [userDefaults synchronize]; //馬上修改standardUserDefaults
    [self.mainCtrl changeViewCtrl:VIP_CELL];
}

#pragma mark - api
-(void) getNews{
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<NewsBusiness> newBiz = [BusinessGetter getNewsBusiness];
    [newBiz getVipNews:^(ApiOutNews *apiOut, NSError *error) {
        [loadingCtrl close];
        if(error==nil){
            if(![TextUtils isEmpty:apiOut.resultcode]){
                if ([apiOut.resultcode isEqualToString:@"200"]) {
                    if(apiOut.newsList!=nil){
                        [newsListDelegate reloadDataWithTableView:self.tv_news list:apiOut.newsList];
                    }else{
                        NSLog(@"NewsList is empty");
                    }
                } else {
                    NSLog(@"resultCode:%@", apiOut.resultcode);
                    [[[[iToast makeText:NSLocalizedString(@"toast_getNews_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                }
            }else{
                NSLog(@"getNews resultcode is isEmpty");
                [[[[iToast makeText:NSLocalizedString(@"toast_getNews_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"getNews error:%@", error.localizedDescription);
            [[[[iToast makeText:NSLocalizedString(@"toast_getNews_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
