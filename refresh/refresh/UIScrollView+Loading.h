//
//  UIScrollView+Loading.h
//  WoQu
//
//  Created by peter on 15/10/28.
//  Copyright © 2015年 WoQu. All rights reserved.
//

@class LoadMoreFooter;
#import <UIKit/UIKit.h>

@interface UIScrollView (Loading)

@property (nonatomic,assign) BOOL refreshing;

/**
 *  添加LoadMore功能
 *
 *  @param loadMoreBlock 回调
 */
- (void)addLoadMoreFooterWithAction:(void(^)())loadMoreBlock;


/**
 *  读取完下一页
 */
- (void)finishLoading;

/**
 *  没有下一页了
 */
- (void)didLoadAll;

/**
 *  加载失败
 *  (有重试功能)
 *  @param error 失败的信息
 */
- (void)loadFailed:(NSString *)error;



@end
