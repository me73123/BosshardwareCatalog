//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewPicutreView : UIScrollView <UIScrollViewDelegate>{
//	UIImage *image;
	UIImageView *imageView;
//    float value;
}
//@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIImage *image;

/**
 *	取得原圖縮放比例(縮放成適合螢幕大小)
 *
 *	@return	zoomSize
 */
- (float)getZoomScale;

- (UIImageView*)getImgV;

///**
// *	初始化progressView
// */
//-(void) showProgressView;
//
///**
// * 移除progressView
// */
//-(void) closeProgressView;
@end
