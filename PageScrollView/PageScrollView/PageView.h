//
//  PageView.h
//  PageScrollView
//
//  Created by Mac os x on 16/4/25.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
