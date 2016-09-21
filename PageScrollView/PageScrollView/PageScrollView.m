//
//  PageScrollView.m
//  PageScrollView
//
//  Created by Mac os x on 16/3/9.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import "PageScrollView.h"

/** 滑动方向 */
typedef NS_ENUM(NSUInteger, PageScrollViewDirection) {
    PageScrollViewDirectionLeft = 0,    // 向左滑动
    PageScrollViewDirectionRight        // 向右滑动
};

static const NSTimeInterval kTimeInterval = 4.0;

@interface PageScrollView () <UIScrollViewDelegate>
@property (assign, nonatomic) BOOL                    isTimeUp;
@property (assign, nonatomic) BOOL                    shouldReloadView;
@property (assign, nonatomic) NSInteger               index;
@property (assign, nonatomic) PageScrollViewDirection direction;

@property (strong, nonatomic) NSTimer                 *timer;

@property (strong, nonatomic) UIView                  *leftPage;
@property (strong, nonatomic) UIView                  *centerPage;
@property (strong, nonatomic) UIView                  *rightPage;
@property (strong, nonatomic) UIScrollView            *scrollView;

@property (strong, nonatomic) UITapGestureRecognizer  *tapGestureRecognizer;
@end

@implementation PageScrollView

#pragma mark - Getter   |   Setter

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:kTimeInterval target:self selector:@selector(animateScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

- (UIView *)leftPage
{
    if (!_leftPage) {
        _leftPage = ({UIView *leftPage = [[UIView alloc] init];
            leftPage.backgroundColor = self.backgroundColor;
            leftPage.frame = self.bounds;
            leftPage;});
    }
    
    return _leftPage;
}

- (UIView *)centerPage
{
    if (!_centerPage) {
        _centerPage = ({UIView *centerView = [[UIView alloc] init];
            CGRect frame = self.bounds;
            frame.origin.x += self.bounds.size.width;
            centerView.frame = frame;
            centerView.backgroundColor = self.backgroundColor;
            centerView;});
    }
    
    return _centerPage;
}

- (UIView *)rightPage
{
    if (!_rightPage) {
        _rightPage = ({UIView *rightView = [[UIView alloc] init];
            rightView.backgroundColor = self.backgroundColor;
            CGRect frame = self.bounds;
            frame.origin.x += self.bounds.size.width * 2;
            rightView.frame = frame;
            rightView;});
    }
    
    return _rightPage;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.frame = self.bounds;
            scrollView.bounces = NO;
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView.backgroundColor = self.backgroundColor;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 3, scrollView.bounds.size.height);
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
            scrollView;});
    }
    
    return _scrollView;
}

- (void)setDataSource:(id<PageScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadData];
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectPage)];
    }
    
    return _tapGestureRecognizer;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.index = 0;
        self.direction = PageScrollViewDirectionLeft;
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.leftPage];
        [self.scrollView addSubview:self.centerPage];
        [self.scrollView addSubview:self.rightPage];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.frame.size.width;
    
    if (x > width * 1.5 || x < width * 0.5) {
        
        self.shouldReloadView = YES;
    } else  {
        
        self.shouldReloadView = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseAnimating];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.shouldReloadView) {
        
        if (self.scrollView.contentOffset.x == 0) {
            
            self.index = [self configIndex:--self.index];
            self.direction = PageScrollViewDirectionLeft;
        } else {
            
            self.index = [self configIndex:++self.index];
            self.direction = PageScrollViewDirectionRight;
        }
        
        [self noticeUpdateIndex];
        
        [self initPageWithIndex:self.index];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
    }
    
    if (!self.isTimeUp) {
        
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeInterval]];
    }
    
    self.isTimeUp = NO;
}

#pragma mark - Action

- (void)animateScroll
{
    self.isTimeUp = YES;
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

- (void)didSelectPage
{
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didSelectViewAtIndex:)]) {
        
        [self.delegate pageScrollView:self didSelectViewAtIndex:self.index];
    }
}

#pragma mark - Private method

- (NSInteger)configIndex:(NSInteger)index
{
    NSInteger pages = [self totalPages];
    NSInteger realIndex = index;
    
    if (realIndex < 0) {
        
        realIndex += pages;
    }
    
    if (realIndex >= pages) {
        
        realIndex -= pages;
    }
    
    return realIndex;
}

- (NSInteger)totalPages
{
    if ([self.dataSource respondsToSelector:@selector(numberOfPageInPageScrollView)]) {
        
        return [self.dataSource numberOfPageInPageScrollView];
    } else {
        
        return 0;
    }
}

- (void)noticeUpdateIndex
{
    if ([self.delegate respondsToSelector:@selector(pageScrollViewStopAtIndex:)]) {
        
        [self.delegate pageScrollViewStopAtIndex:self.index];
    }
}

- (UIView *)viewForPageWithIndex:(NSInteger)index
{
    NSInteger pages = [self totalPages];
    if (pages <= 1) {
        [self pauseAnimating];
        self.scrollView.scrollEnabled = NO;
    } else {
        
        [self resumeAnimating];
        self.scrollView.scrollEnabled = YES;
    }
    
    if (pages == 0) {
        
        return [self emptyViewForPage];
    }
    
    UIView *view = nil;
    
    if ([self.dataSource respondsToSelector:@selector(pageScrollView:viewForPageAtIndex:)]) {
        
        view = [self.dataSource pageScrollView:self viewForPageAtIndex:index];
        view.tag = index;
    }
    
    [self addTapGestureRecognizer];
    return view;
}

- (UIView *)emptyViewForPage
{
    if ([self.dataSource respondsToSelector:@selector(emptyViewForPageInPageScrollView:)]) {
        
        return [self.dataSource emptyViewForPageInPageScrollView:self];
    } else {
        
        return nil;
    }
}

- (void)initPageWithIndex:(NSInteger)index
{
    if (self.direction == PageScrollViewDirectionLeft) {    // 左滑
        
        [self moveViewsToRight];
        [self.leftPage addSubview:[self viewForPageWithIndex:[self configIndex:self.index - 1]]];
    } else if (self.direction == PageScrollViewDirectionRight) {    // 右滑
        
        [self moveViewsToLeft];
        [self.rightPage addSubview:[self viewForPageWithIndex:[self configIndex:self.index + 1]]];
    }
}

- (void)removeAllSubviewsFromSuperview:(UIView *)superview
{
    if ([superview subviews].count > 0) {
        
        [[superview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)moveSubviewFromView:(UIView *)aView toView:(UIView *)anotherView
{
    [self removeAllSubviewsFromSuperview:anotherView];
    
    if ([aView subviews].count > 0) {
        
        [anotherView addSubview:[[aView subviews] firstObject]];
    }
}

- (void)moveViewsToLeft
{
    [self moveSubviewFromView:self.centerPage toView:self.leftPage];
    [self moveSubviewFromView:self.rightPage toView:self.centerPage];
}

- (void)moveViewsToRight
{
    [self moveSubviewFromView:self.centerPage toView:self.rightPage];
    [self moveSubviewFromView:self.leftPage toView:self.centerPage];
}

- (void)reloadContentViewsWithIndexes:(NSArray *)indexes
{
    [self removeAllSubviewsFromSuperview:self.leftPage];
    [self removeAllSubviewsFromSuperview:self.centerPage];
    [self removeAllSubviewsFromSuperview:self.rightPage];
    
    UIView *view = nil;
    for (int idx = 0; idx < indexes.count; idx++) {
        
        NSInteger index = [[indexes objectAtIndex:idx] integerValue];
        
        view = [self viewForPageWithIndex:index];
        
        switch (idx) {
            case 0:
                [self.leftPage addSubview:view];
                break;
            case 1:
                [self.centerPage addSubview:view];
                break;
            case 2:
                [self.rightPage addSubview:view];
                break;
            default:
                break;
        }
    }
}

- (void)clearTapGestureRecognizer
{
    [[[self.centerPage subviews] firstObject] removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)addTapGestureRecognizer
{
    [[[self.centerPage subviews] firstObject] addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Utilites

- (void)reloadData
{
    self.index = 0;
    NSInteger lastIndex = [self configIndex:self.index - 1];
    NSInteger nextIndex = [self configIndex:self.index + 1];
    [self reloadContentViewsWithIndexes:@[@(lastIndex), @(self.index), @(nextIndex)]];
    
    [self noticeUpdateIndex];
}

- (void)startAnimating
{
    if ([self totalPages] > 1) {
        
        [self resumeAnimating];
    }
}

- (void)stopAnimating
{
    [_timer invalidate];
    _timer = nil;
}

- (void)pauseAnimating
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeAnimating
{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeInterval]];
}
@end
