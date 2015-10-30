//
//  LoadMoreFooter.h
//  oyfj
//
//  Created by oyfj on 14-8-7.
//  Copyright (c) 2014年 WoQu. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kLoadMoreFooterHeight = 45.f;

@interface LoadMoreFooter : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView * loadingView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, copy) void (^loadMoreBlock)();


- (void)beginLoading;


- (void)finishLoading;


- (void)reset;


/**
 *  已加载完全部
 */
- (void)didLoadAll;


/**
 *  加载失败
 *
 *  @param error
 */
- (void)loadFailed:(NSString *)error;

@end
