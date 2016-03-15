//
//  ProgressHud.m
//  PageScrollView
//
//  Created by Mac os x on 16/3/11.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import "ProgressHud.h"

static const CGFloat kWidth = 96.0;
static const CGFloat kHeight = kWidth;
static const CGFloat kCornerRadius = 3.0;
static const CGFloat kStatusFont = 14;

static const float kShadowOpacity = 0.8;

@interface ProgressHud ()
@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UILabel *statusLabel;
@end

@implementation ProgressHud

#pragma mark - Getter   |   Setter

- (UIWindow *)overlayWindow
{
    if (!_overlayWindow) {
        _overlayWindow = ({UIWindow *overlayWindow = [[UIWindow alloc] init];
            overlayWindow.frame = [UIScreen mainScreen].bounds;
            overlayWindow.userInteractionEnabled = NO;
            overlayWindow.backgroundColor = [UIColor clearColor];
            overlayWindow;});
    }
    
    return _overlayWindow;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = ({UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            indicatorView.hidesWhenStopped = NO;
            indicatorView;});
    }
    
    return _indicatorView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = ({UILabel *statusLabel = [[UILabel alloc] init];
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.font = [UIFont systemFontOfSize:kStatusFont];
            statusLabel;});
    }
    
    return _statusLabel;
}

#pragma mark - Life cycle

+ (instancetype)shareHud
{
    static ProgressHud *shareObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[self alloc] init];
    });
    
    return shareObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.center = self.overlayWindow.center;
        self.layer.cornerRadius = kCornerRadius;
        self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        self.layer.shadowColor = [[UIColor grayColor] CGColor];
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = kShadowOpacity;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Public method

#pragma mark - Class method

+ (void)loading
{
    [ProgressHud loadingWithStatus:nil];
}

+ (void)loadingWithStatus:(NSString *)status
{
    
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [ProgressHud showErrorWithStatus:status duration:1.0];
}

+ (void)showErrorWithStatus:(NSString *)status duration:(NSTimeInterval)duration
{
    
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [ProgressHud showSuccessWithStatus:status duration:1.0];
}

+ (void)showSuccessWithStatus:(NSString *)status duration:(NSTimeInterval)duration
{
    
}

+ (void)dimiss
{
    
}

#pragma mark - Instance method

- (void)loading
{
    [self loadingWithStatus:nil];
}

- (void)loadingWithStatus:(NSString *)status
{
    
}

- (void)showErrorWithStatus:(NSString *)status
{
    [self showErrorWithStatus:status duration:1.0];
}

- (void)showErrorWithStatus:(NSString *)status duration:(NSTimeInterval)duration
{
    
}

- (void)showSuccessWithStatus:(NSString *)status
{
    [self showSuccessWithStatus:status duration:1.0];
}

- (void)showSuccessWithStatus:(NSString *)status duration:(NSTimeInterval)duration
{
    
}

- (void)dimiss
{
    
}
@end
