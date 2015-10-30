//
//  UIScrollView+Loading.m
//  WoQu
//
//  Created by peter on 15/10/28.
//  Copyright © 2015年 WoQu. All rights reserved.
//

#import "LoadMoreFooter.h"
#import "UIScrollView+Loading.h"
#import <objc/runtime.h>


static char UIScrollViewLoadMoreFooterView;
static char UIScrollViewLoadingView;

@interface UIScrollView ()

@property (nonatomic, strong) LoadMoreFooter * footer;
@property (nonatomic, strong) UIActivityIndicatorView * loadingIndicator;

@end

@implementation UIScrollView (Loading)


#pragma mark - public
- (void)addLoadMoreFooterWithAction:(void(^)())loadMoreBlock{
    if (!self.footer) {
        LoadMoreFooter * footer = [[LoadMoreFooter alloc]initWithFrame:CGRectZero];//初始位置是在最底部
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        footer.loadMoreBlock = loadMoreBlock;
        [self addSubview:footer];
        self.contentInset = UIEdgeInsetsMake( 0, 0, kLoadMoreFooterHeight, 0);
        self.footer = footer;
    }
}

- (void)finishLoading{
    if (!self.footer) {
        NSAssert(NO, @"请先调用addLoadMoreFooterWithAction:方法");
    }
    [self.footer finishLoading];
}

- (void)didLoadAll{
    if (!self.footer) {
        NSAssert(NO, @"请先调用addLoadMoreFooterWithAction:方法");
    }
    [self.footer didLoadAll];
}

- (void)loadFailed:(NSString *)error{
    if (!self.footer) {
        NSAssert(NO, @"请先调用addLoadMoreFooterWithAction:方法");
    }
    [self.footer loadFailed:error];
}



#pragma mark - getter&setter

- (LoadMoreFooter *)footer{
    return objc_getAssociatedObject(self, &UIScrollViewLoadMoreFooterView);
}

-(void)setFooter:(LoadMoreFooter *)footer{
    objc_setAssociatedObject(self,
                             &UIScrollViewLoadMoreFooterView,
                             footer,
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView *)loadingIndicator{
    return objc_getAssociatedObject(self, &UIScrollViewLoadingView);
}

- (void)setLoadingIndicator:(UIActivityIndicatorView *)loadingIndicator{
    objc_setAssociatedObject(self,
                             &UIScrollViewLoadingView,
                             loadingIndicator,
                             OBJC_ASSOCIATION_RETAIN);
}

- (void)setRefreshing:(BOOL)isRefreshing{
    if (!self.loadingIndicator) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.center = self.center;
        [self.superview addSubview:self.loadingIndicator];
    }
    if (isRefreshing) {
        self.hidden = YES;
        [self.loadingIndicator startAnimating];
    }else{
        self.hidden = NO;
        [self.loadingIndicator stopAnimating];
    }
}



- (BOOL)refreshing{
    if (!self.loadingIndicator) {
        return NO;
    }
    return self.loadingIndicator.isAnimating;
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"contentOffset"]) {

        CGFloat lastOffset = self.contentSize.height - self.bounds.size.height ;
        if (!self.footer.isFinished && !self.footer.isLoading && lastOffset > 0 && self.contentOffset.y >= lastOffset) {
            
            [self.footer beginLoading];
            if (self.footer.loadMoreBlock) {
                self.footer.loadMoreBlock();
            }
        }
    }else if ([keyPath isEqualToString:@"contentSize"]){
        self.footer.frame = CGRectMake(0, self.contentSize.height, self.contentSize.width, kLoadMoreFooterHeight);

    }
}


@end
