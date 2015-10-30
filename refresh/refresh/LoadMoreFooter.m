//
//  WQLoadMoreFooter.m
//  WoQu
//
//  Created by 林湧顷 on 14-8-7.
//  Copyright (c) 2014年 WoQu. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isLoading = NO;
        
        CGFloat titleWidth = 150.0f;
        CGFloat titleHeight = 20.0f;
        CGRect titleFrame = CGRectMake((self.bounds.size.width - titleWidth - 10)/2, (self.bounds.size.height-titleHeight)/2, titleWidth, titleHeight);
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.text = NSLocalizedString(@"",nil);
        [self addSubview:self.titleLabel];
        
        CGFloat loadingViewOriginX = self.bounds.size.width - titleFrame.origin.x - 5;
        CGPoint loadingViewCenter = CGPointMake(loadingViewOriginX, CGRectGetMidY(self.bounds));
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingView setCenter: loadingViewCenter];
        self.loadingView.autoresizingMask = self.titleLabel.autoresizingMask;
        [self.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingView setColor:[UIColor lightGrayColor]];
        [self addSubview:self.loadingView];
    }
    
    return self;
}


#pragma mark - Setter

- (void)setContentInsets:(UIEdgeInsets)insets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_contentInsets, insets)) {
        return;
    }
    
    _contentInsets = insets;
    
    CGFloat titleWidth = self.frame.size.width - insets.left - insets.right;
    if (titleWidth > self.titleLabel.frame.size.width) {
        titleWidth = self.titleLabel.frame.size.width;
    }
    
    CGFloat titleHeight = self.frame.size.height - insets.top - insets.bottom;
    CGFloat originX = (self.bounds.size.width - titleWidth - 30)/2;
    CGFloat originY = insets.top;
    
    
    CGRect titleFrame = CGRectMake(originX, originY, titleWidth, titleHeight);
    self.titleLabel.frame = titleFrame;
    
    CGFloat loadingViewOriginX = self.bounds.size.width - titleFrame.origin.x - 5;
    CGPoint loadingViewCenter = CGPointMake(loadingViewOriginX, CGRectGetMidY(self.bounds));
    [self.loadingView setCenter:loadingViewCenter];
}


#pragma mark - Public


- (void)beginLoading
{
    if (self.isLoading == NO) {
        self.isLoading = YES;
        self.isFinished = NO;
        [self.titleLabel setText:NSLocalizedString(@"努力加载中...",nil)];
        [self.loadingView startAnimating];
    }
}


- (void)finishLoading
{
    self.isLoading = NO;
    [self.titleLabel setText:NSLocalizedString(@"加载更多",nil)];
    [self.loadingView stopAnimating];
}

- (void)reset
{
    self.isLoading = NO;
    [self.titleLabel setText:nil];
    [self.loadingView stopAnimating];
}


- (void)didLoadAll
{
    self.isLoading = NO;
    self.isFinished = YES;
    [self.titleLabel setText:NSLocalizedString(@"全部加载完成",nil)];
    [self.loadingView stopAnimating];

}


- (void)loadFailed:(NSString *)error
{
    
    self.isLoading = NO;
    [self.titleLabel setText:[NSString stringWithFormat:@"%@",@"点击重试"]];
    if (self.gestureRecognizers.count == 0) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retryLoadMore:)]];
    }
    [self.loadingView stopAnimating];
}


- (void)retryLoadMore:(id)sender{
    [self beginLoading];
    self.loadMoreBlock();
}


@end
