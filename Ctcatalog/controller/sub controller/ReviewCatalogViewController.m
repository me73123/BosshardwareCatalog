//
//  ReviewCatalogViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/9/13.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "ReviewCatalogViewController.h"
#import "FileUtil.h"
#import "ReviewPicutreView.h"

@interface ReviewCatalogViewController ()<UIScrollViewDelegate>{
    CGFloat height;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSInteger lastPage;
}
@property (weak, nonatomic) IBOutlet UIView *view_topbar;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIScrollView *sv_allPage;

//action
- (IBAction)clickBack:(UIButton *)sender;

/**
 *	儲存 imagevo
 */
@property (strong, nonatomic) NSMutableArray *imageList;
/**
 *	儲存 ReviewPicutreView
 */
@property (strong, nonatomic) NSMutableArray *scrollViewList;
@end

@implementation ReviewCatalogViewController

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
    self.imageList = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //螢幕旋轉會導致資料無法顯示
    [self setCommonText:self.lb_title text:self.albumTitle];
    [self initImage];
}

#pragma mark - ui
- (void) initImage {
    NSLog(@"self.imagevo.withuuid:%@",self.albumuuid);
    
    if(![TextUtils isEmpty:self.albumuuid]) {
        NSString* pageDir = [self.albumuuid stringByAppendingPathComponent:@"content_page"];
        NSString* photoSaveDir = [[FileUtil getDocumentPath] stringByAppendingPathComponent:pageDir];
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray* fileList = [fileManager contentsOfDirectoryAtPath:photoSaveDir error:&error];

        for(NSString* filename in fileList) {
            NSLog(@"filename:%@", filename);
            NSString* imgPath = [photoSaveDir stringByAppendingPathComponent:filename];
            NSLog(@"imgPath:%@", imgPath);
            UIImage* img = [[UIImage alloc] initWithContentsOfFile:imgPath];
            [self.imageList addObject:img];
        }
    }else{
        NSLog(@"self.albumuuid is null");
    }
    
    NSUInteger imageCount = self.imageList.count;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    //手動計算最外曾scrollView大小
    height = screenHeight - 20 - self.view_topbar.frame.size.height;
    self.sv_allPage.contentSize = CGSizeMake(screenWidth*imageCount, height);
	self.sv_allPage.showsHorizontalScrollIndicator = NO;
	self.sv_allPage.delegate = self;
    
    int i=0;
    //載入圖片
	for (UIImage* img in self.imageList)
	{
        lastPage = i;
        
        ReviewPicutreView *ascrView = [[ReviewPicutreView alloc] initWithFrame:CGRectMake(screenWidth*lastPage, 0, screenWidth, height)];
        ascrView.image = img;
        ascrView.tag = 100+lastPage;
        [self.sv_allPage addSubview:ascrView];
        
        i++;
    }
    //設定scroll到所選的圖片
    CGPoint bottomOffset = CGPointMake(screenWidth*0, 0);
    [self.sv_allPage setContentOffset:bottomOffset animated:NO];
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (lastPage != page)  //沒有換頁
	{
        //image換頁後把前一張還原
		ReviewPicutreView *aView = (ReviewPicutreView*)[self.sv_allPage viewWithTag:100+lastPage];
        UIImageView *imageView = [aView getImgV];
        float minZoom = MIN(aView.frame.size.width / imageView.image.size.width,
                            (aView.frame.size.height-10) / imageView.image.size.height);
        aView.zoomScale = minZoom;
		lastPage = page;
	}
}

#pragma mark - action
- (IBAction)clickBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
