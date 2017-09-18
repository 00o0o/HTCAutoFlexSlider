//
//  HTCAutoFlexSliderView.m
//  HTCAutoFlexSlider
//
//  Created by Clover on 9/15/17.
//  Copyright © 2017 Clover. All rights reserved.
//

#import "HTCAutoFlexSliderView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

@interface HTCAutoFlexSliderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图
@property (nonatomic, strong) UIVisualEffectView *blurEffectView; //模糊视图

@property (nonatomic, assign) CGFloat currentHeight; //当前元素的高度
@property (nonatomic, assign) CGFloat currentOffsetX; //当前x轴偏移
@property (nonatomic, assign) NSInteger currentIndex; //当前item索引
@property (nonatomic, assign) CGFloat distance; //两个相邻的item的高度差值
@end

@implementation HTCAutoFlexSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.blurEffectView];
        [self _layoutViews];
    }
    return self;
}

#pragma mark - Private methods
- (void)_layoutViews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)_initItemsWithSize:(CGSize)imageSize {
    [_scrollView removeAllSubviews];
    
    CGFloat ratio = kScreenWidth / imageSize.width;
    CGFloat itemHeight = imageSize.height * ratio;
    
    UIView *lastView = nil;
    for(int i=0; i<_imageUrls.count; i++) {
        NSString *imageUrl = _imageUrls[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:imageView];
        
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.mas_equalTo(self.scrollView.mas_height);
            make.bottom.equalTo(self.scrollView);
            if(lastView != nil) {
                make.left.mas_equalTo(lastView.mas_right);
            }else {
                make.left.mas_equalTo(0);
            }
        }];
        
        lastView = imageView;
    }
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastView.mas_right);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(itemHeight);
    }];
}

- (UIImageView *)_currentImageView {
    if((_scrollView.subviews.count > _currentIndex) && (_currentIndex >= 0)) {
        UIView *view = _scrollView.subviews[_currentIndex];
        if([view isKindOfClass:[UIImageView class]]) {
            return (UIImageView *)view;
        }
    }
    
    return nil;
}

- (CGFloat)_calcItemHeight {
    UIImageView *imageView = [self _currentImageView];

    if(imageView && imageView.image.size.width > 0) {
        CGFloat ratio = kScreenWidth / imageView.image.size.width;
        return imageView.image.size.height * ratio;
    }
    return _currentHeight;
}

- (CGFloat)_calcFlexHeight {
    CGFloat percent = fabs(_scrollView.contentOffset.x - _currentOffsetX) / kScreenWidth;
    return _distance * percent;
}


#pragma mark - Views
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.bouncesZoom = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIVisualEffectView *)blurEffectView {
    if(!_blurEffectView) {
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _blurEffectView.frame = CGRectZero;
        _blurEffectView.alpha = 0.f;
        _blurEffectView.userInteractionEnabled = NO;
    }
    return _blurEffectView;
}

#pragma mark - Getter/Setter
- (void)setImageUrls:(NSArray<NSString *> *)imageUrls {
    if(!imageUrls.count) {
        return;
    }
    
    _imageUrls = imageUrls;
    YYWebImageManager *imageManager = [YYWebImageManager sharedManager];
    @weakify(self);
    [imageManager requestImageWithURL:[NSURL URLWithString:_imageUrls.firstObject] options:YYWebImageOptionAvoidSetImage progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        if(!error) {
            CGSize imageSize = image.size;
            dispatch_async_on_main_queue(^{
                [self _initItemsWithSize:imageSize];
            });
        }
    }];
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    _blurRadius = blurRadius;
    _blurEffectView.alpha = _blurRadius;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x > _currentOffsetX) {
        self.currentIndex = ceil(scrollView.contentOffset.x / kScreenWidth);
    }else {
        self.currentIndex = floor(scrollView.contentOffset.x / kScreenWidth);
    }

    CGFloat itemHeight = [self _calcItemHeight];
    self.distance = itemHeight - _currentHeight;
    
    CGFloat flexHeight = 0.f;
    if(itemHeight > 0.f) {
        flexHeight = [self _calcFlexHeight];
    }
    
    CGFloat itemNewHeight = _currentHeight + flexHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(itemNewHeight);
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentHeight = scrollView.height;
    self.currentOffsetX = scrollView.contentOffset.x;
}

@end
