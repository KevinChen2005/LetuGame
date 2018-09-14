//
//  FJNewsTitleView.h
//  LetuGame
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJNewsDetail;

@interface FJNewsTitleView : UIView

@property (nonatomic, strong)FJNewsDetail* newsDetail;

+ (instancetype)titleView;

- (CGFloat)height;

@end
