//
//  PageView.m
//  PageScrollView
//
//  Created by Mac os x on 16/4/25.
//  Copyright © 2016年 YCS. All rights reserved.
//

#import "PageView.h"

static const CGFloat KTextLabelHeight = 27.0;

@implementation PageView

#pragma mark - Getter   |   Setter

- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = ({
            UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
            contentView.backgroundColor = self.backgroundColor;
            contentView;});
    }
    
    return _contentView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.backgroundColor = self.backgroundColor;
            imageView;});
    }
    
    return _imageView;
}

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        _textLabel = ({
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), KTextLabelHeight);
            textLabel.center = self.center;
            textLabel;});
    }
    
    return _textLabel;
}

#pragma mark - Life cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super init];
    if (self) {
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
    }
    
    return self;
}


@end
