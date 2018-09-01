//
//  FJBanner.h
//  LetuGame
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJBanner : NSObject

@property (nonatomic, copy)NSString* ID;     // id

@property (nonatomic, copy)NSString* href;   // 跳转的文章ID或Game

@property (nonatomic, copy)NSString* image;  // 图片地址

@property (nonatomic, assign)NSInteger type; // 类型

@end


/*
 {
 href = 2e903dd52d6e4fd79bbb6fdd19bfb6c2;
 id = 4;
 image = "http://59.111.103.96:8001/image/banner/banner_news_1.jpg";
 type = 1;
 },
 */


