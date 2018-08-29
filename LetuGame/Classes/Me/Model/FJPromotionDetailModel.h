//
//  FJPromotionDetailModel.h
//  LetuGame
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  记录玩家充值情况

#import <Foundation/Foundation.h>

@interface FJPromotionDetailModel : NSObject

@property (nonatomic, copy)NSString* channelUserName; //用户名

@property (nonatomic, copy)NSString* channelUserId; //用户id

@property (nonatomic, copy)NSString* channelCpId; //用户id

@property (nonatomic, assign)CGFloat payMoney;  //充值金额

@end
