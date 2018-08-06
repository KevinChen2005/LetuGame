//
//  ZHNheadImageLoadViewController.h
//  zhnHeadImageLoadVC
//
//  Created by zhn on 16/4/8.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHNheadImageLoadBlock)(UIImage *);

@interface ZHNheadImageLoadViewController : UIViewController
/**
 *  裁剪完的回调处理
 */
@property (nonatomic,copy) ZHNheadImageLoadBlock ZHNheadImageBlock;
/**
 *  需要裁剪的图片
 */
@property (nonatomic,strong) UIImage * oldImage;
@end
