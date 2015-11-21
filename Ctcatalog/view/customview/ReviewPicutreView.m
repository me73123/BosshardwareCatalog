//
//  MyScrollView.m
//  PhotoBrowserEx
//
//  Created by on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ReviewPicutreView.h"
#import "AppDelegate.h"

@interface ReviewPicutreView ()

@end

@implementation ReviewPicutreView

@synthesize image;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		self.minimumZoomScale = 0.1;
		self.maximumZoomScale = 2;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
        
        imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		[self addSubview:imageView];
        
//        //init progressView
//        CGFloat widthSpace_iPhone = 20;
//        CGFloat widthSpace_iPad = 50;
//        CGFloat widthSpace;
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//            widthSpace = widthSpace_iPad;
//        }else{
//            widthSpace = widthSpace_iPhone;
//        }
//        
//        //設定loading進度條
//        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-10)/2, self.frame.size.width-widthSpace, 30)];
//        self.progressView.progressViewStyle = UIProgressViewStyleDefault;
//        self.progressView.progress = 0;  //初始化進度
//        
//        //將progressView縮放改變其高度
//        if(app.isPad){
//            CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
//            self.progressView.transform = transform;
//        }
    }
    return self;
}

- (void)setImage:(UIImage *)img
{
	imageView.image = img;
    
    //將原圖縮小符合螢幕大小
    imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    self.zoomScale = [self getZoomScale];
    self.minimumZoomScale = self.zoomScale;
}

- (UIImageView*)getImgV
{
	return imageView;
}

/**
 *	取得原圖縮放比例(縮放成適合螢幕大小)
 *
 *	@return	zoomSize
 */
- (float)getZoomScale
{
    float minZoom = MIN(self.frame.size.width / imageView.image.size.width,
                        (self.frame.size.height-10) / imageView.image.size.height);
    return minZoom;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{	
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(double)scale
{
    //縮放完觸發
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, self.minimumZoomScale);
	zs = MIN(zs, self.maximumZoomScale);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = zs;	
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) //兩指click時觸發
	{
		CGFloat zs = self.zoomScale;
		zs = (zs == 1.0) ? self.maximumZoomScale : self.minimumZoomScale;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];			
		self.zoomScale = zs;	
		[UIView commitAnimations];
	}
}
//image置中
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView* v = [self.delegate viewForZoomingInScrollView:self];
    CGFloat svw = self.frame.size.width;
    CGFloat svh = self.frame.size.height;
    CGFloat vw = v.frame.size.width;
    CGFloat vh = v.frame.size.height;
    CGRect f = v.frame;
    if (vw < svw)
        f.origin.x = (svw - vw) / 2.0;
    else
        f.origin.x = 0;
    if (vh < svh)
        f.origin.y = (svh - vh) / 2.0;
    else
        f.origin.y = 0;
    v.frame = f;
}

///**
// *	初始化progressView
// */
//-(void) showProgressView
//{
//    [self addSubview:self.progressView];
//}
//
///**
// * 移除progressView
// */
//-(void) closeProgressView
//{
//    [self.progressView removeFromSuperview];
//}
@end
