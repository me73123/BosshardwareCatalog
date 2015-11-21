//
//  MainViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "MainViewController.h"
#import "ThumbnailViewController.h"
#import "DeleteAlbumViewController.h"
#import "MovieViewController.h"
#import "VipViewController.h"
#import "VipNewsViewController.h"
#import "MenuCollectionDelegate.h"
#import "UIAlertUtil.h"

@interface MainViewController (){
    UIViewController* currentViewCtrl;
    UIViewController* beforeCtrl;
    ThumbnailViewController* thumbnailViewCtrl;
    DeleteAlbumViewController* deleteAlbumCtrl;
    MovieViewController* movieCtrl;
    VipViewController* vipCtrl;
    VipNewsViewController* vipNewsCtrl;
    NSMutableArray* menuImgAry;
    NSMutableArray* menuStrAry;
    MenuCollectionDelegate* menuCollectionDelegate;
}
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet UIButton *btn_leftMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_menu;
@property (weak, nonatomic) IBOutlet UIButton *btn_rightMenu;
@property (weak, nonatomic) IBOutlet UIView *view_fullScreen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_menu;

//action
- (IBAction)clickLeftMenu:(UIButton *)sender;
- (IBAction)clickRightMenu:(UIButton *)sender;
@end

@implementation MainViewController

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
    
    menuImgAry = [[NSMutableArray alloc]init];
    menuStrAry = [[NSMutableArray alloc]init];
    for(int i=0; i<=VIP_CELL; i++){
        switch (i) {
            case UPDATE_CELL:
                [menuImgAry addObject:[UIImage imageNamed:@"update.png"]];
                [menuStrAry addObject:NSLocalizedString(@"updateAlbum", nil)];
                break;
                
            case DELETE_CELL:
                [menuImgAry addObject:[UIImage imageNamed:@"delete.png"]];
                [menuStrAry addObject:NSLocalizedString(@"deleteAlbum", nil)];
                break;
                
            case MOVIE_CELL:
                [menuImgAry addObject:[UIImage imageNamed:@"video.png"]];
                [menuStrAry addObject:NSLocalizedString(@"movie", nil)];
                break;
                
            case VIP_CELL:
                [menuImgAry addObject:[UIImage imageNamed:@"vip.png"]];
                [menuStrAry addObject:NSLocalizedString(@"vip", nil)];
                break;
                
            default:
                [menuImgAry addObject:[UIImage imageNamed:@"update.png"]];
                [menuStrAry addObject:NSLocalizedString(@"updateAlbum", nil)];
                break;
        }
    }
    
    //init subview
    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    thumbnailViewCtrl = [[app storyboardWithName:@"Catalog"] instantiateViewControllerWithIdentifier:@"ThumbnailViewController"];
    deleteAlbumCtrl = [[app storyboardWithName:@"Catalog"] instantiateViewControllerWithIdentifier:@"DeleteAlbumViewController"];
    movieCtrl =  [[app storyboardWithName:@"OtherFunctional"] instantiateViewControllerWithIdentifier:@"MovieViewController"];
    vipCtrl = [[app storyboardWithName:@"Vip"] instantiateViewControllerWithIdentifier:@"VipViewController"];
    vipCtrl.mainCtrl = self;
    vipNewsCtrl = [[app storyboardWithName:@"Vip"] instantiateViewControllerWithIdentifier:@"VipNewsViewController"];
    vipNewsCtrl.mainCtrl = self;
    
    //init delegate
    menuCollectionDelegate = [[MenuCollectionDelegate alloc]initWithController:self collectionView:self.cv_menu list:menuImgAry strList:menuStrAry];
    
    self.cv_menu.delegate = menuCollectionDelegate;
    self.cv_menu.dataSource = menuCollectionDelegate;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeViewCtrl:UPDATE_CELL];
}

#pragma mark - ui
-(void)changeViewCtrl:(int) index {
    UIViewController* viewCtrl;
    switch (index) {
            //更新目錄
        case UPDATE_CELL:
            viewCtrl = thumbnailViewCtrl;
            break;
            //刪除目錄
        case DELETE_CELL:
            viewCtrl = deleteAlbumCtrl;
            break;
            //影片
        case MOVIE_CELL:
            viewCtrl = movieCtrl;
            break;
            //vip
        case VIP_CELL:
        {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL isLogin = [userDefaults boolForKey:ISLOGIN];
            if (isLogin) {
                viewCtrl = vipNewsCtrl;
            }else{
                viewCtrl = vipCtrl;
            }
        }
            break;
        default:
            break;
    }
    
    if(currentViewCtrl != viewCtrl) {
        beforeCtrl = currentViewCtrl;
        [self closeViewCtrl:currentViewCtrl];
        currentViewCtrl = viewCtrl;
        [self addViewCtrl:currentViewCtrl];
    }
}

-(void)addViewCtrl:(UIViewController*) viewCtrl {
    if(viewCtrl != nil) {
        [self addChildViewController:viewCtrl];
        viewCtrl.view.frame = self.view_content.frame;
        [self.view_content addSubview:viewCtrl.view];
        [viewCtrl didMoveToParentViewController:self];
    }
}

-(void)closeViewCtrl:(UIViewController*) viewCtrl {
    if(viewCtrl != nil) {
        [viewCtrl willMoveToParentViewController:nil];
        [viewCtrl.view removeFromSuperview];
        [viewCtrl removeFromParentViewController];
    }
}

#pragma mark - action
- (IBAction)clickLeftMenu:(UIButton *)sender {
    CGPoint oldOffset = self.cv_menu.contentOffset;
    CGFloat width_menu = self.constraint_width_menu.constant;
    CGPoint newOffset = CGPointMake(oldOffset.x - width_menu, 0);
    
    if(newOffset.x<0){
        self.cv_menu.contentOffset = CGPointMake(0, 0);
    }else{
        self.cv_menu.contentOffset = CGPointMake(newOffset.x, 0);
    }
}

- (IBAction)clickRightMenu:(UIButton *)sender {
    CGPoint oldOffset = self.cv_menu.contentOffset;
    CGFloat width_menu = self.constraint_width_menu.constant;
    CGFloat content_menu_width = self.cv_menu.contentSize.width;
    CGPoint newOffset = CGPointMake(oldOffset.x + width_menu, 0);

    if(content_menu_width>newOffset.x){
        self.cv_menu.contentOffset = CGPointMake(newOffset.x, 0);
    }else{
        self.cv_menu.contentOffset = CGPointMake(oldOffset.x, 0);
    }
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
