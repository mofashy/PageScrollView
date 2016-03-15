//
//  ViewController.m
//  PageScrollView
//
//  Created by Mac os x on 16/3/9.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import "ViewController.h"
#import "PageScrollView.h"

@interface ViewController () <PageScrollViewDelegate, PageScrollViewDataSource>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) PageScrollView *pageScrollView;
@property (strong, nonatomic) NSArray *array;
@property (assign, nonatomic) NSInteger count;
@end

@implementation ViewController

#pragma mark - Getter   |   Setter

- (NSArray *)array
{
    if (!_array) {
        _array = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor],
                   [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor],
                   [UIColor purpleColor]];
    }
    
    return _array;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pageScrollView = [[PageScrollView alloc] initWithFrame:(CGRect){{15, 20}, {290, 140}}];
    self.pageScrollView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.dataSource = self;
    self.pageScrollView.delegate = self;
    
    self.pageControl.numberOfPages = self.array.count;
    self.pageControl.userInteractionEnabled = NO;
    
    self.count = 0;
    self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count++;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count++;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count++;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count--;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count--;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count--;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(34 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count += self.array.count;
        self.label.text = [NSString stringWithFormat:@"Total page: %ld", (long)self.count];
        [self.pageScrollView reloadData];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pageScrollView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page scroll view data source

- (NSInteger)numberOfPageInPageScrollView
{
    return self.count;
}

- (UIView *)pageScrollView:(PageScrollView *)pageScrollView viewForPageAtIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:self.pageScrollView.bounds];
    view.backgroundColor = self.array[index];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 20)];
    label.text = [NSString stringWithFormat:@"Page %02ld", (long)(index + 1)];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

- (UIView *)emptyViewForPageInPageScrollView
{
    UIView *view = [[UIView alloc] initWithFrame:self.pageScrollView.bounds];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"^_^";
    [view addSubview:label];
    
    return view;
}

#pragma mark - Page scroll view delegate

- (void)pageScrollViewStopAtIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

- (void)pageScrollView:(PageScrollView *)pageScrollView didSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"Did select page index: %ld", (long)index);
}
@end
