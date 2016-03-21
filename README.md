# PageScrollView（无限循环轮播器）

特性
======
>1、参考UITablView，通过数据源方法为轮播器设置内容，通过代理方法处理轮播器页面的点击

效果演示
======

![image](https://raw.githubusercontent.com/mofashy/PageScrollView/master/PageScrollView/Resources/demo.gif)<br/>

使用说明
======

#### 1、请拖拽PageScrollView目录到您的项目中<br />
#### 2、使用控件
```objc
// 添加无限循环轮播器
self.pageScrollView = [[PageScrollView alloc] initWithFrame:(CGRect){{15, 20}, {290, 140}}];
[self.view addSubview:self.pageScrollView];
self.pageScrollView.dataSource = self;
self.pageScrollView.delegate = self;
```

#### 3、数据源方法
```objc
// 轮播器页数
- (NSInteger)numberOfPageInPageScrollView
{
}

// 轮播器每一页的内容
- (UIView *)pageScrollView:(PageScrollView *)pageScrollView viewForPageAtIndex:(NSInteger)index
{
}

// 当轮播器没有内容时默认显示的视图（可选）
- (UIView *)emptyViewForPageInPageScrollView
{
}
```

#### 4、代理方法
```objc
// 轮播器当前指示的页码
- (void)pageScrollViewStopAtIndex:(NSInteger)index
{
}

// 轮播器每一页的点击
- (void)pageScrollView:(PageScrollView *)pageScrollView didSelectViewAtIndex:(NSInteger)index
{
}
```

#### 5、开始自动轮播
```objc
[self.pageScrollView startAnimating];
```

注
======
>1、Demo中的UIPageControl没有封装到轮播器中
