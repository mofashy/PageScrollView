//
//  PageScrollView.h
//  PageScrollView
//
//  Created by Mac os x on 16/3/9.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageScrollView;

@protocol PageScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfPageInPageScrollView;
- (UIView *)pageScrollView:(PageScrollView *)pageScrollView viewForPageAtIndex:(NSInteger)index;

@optional
- (UIView *)emptyViewForPageInPageScrollView;
@end

@protocol PageScrollViewDelegate <NSObject>
@optional
- (void)pageScrollViewStopAtIndex:(NSInteger)index;
- (void)pageScrollView:(PageScrollView *)pageScrollView didSelectViewAtIndex:(NSInteger)index;
@end

@interface PageScrollView : UIView
@property (strong, nonatomic) id<PageScrollViewDataSource> dataSource;
@property (strong, nonatomic) id<PageScrollViewDelegate> delegate;

- (void)reloadData;
- (void)startAnimating;
- (void)stopAnimating;
@end
