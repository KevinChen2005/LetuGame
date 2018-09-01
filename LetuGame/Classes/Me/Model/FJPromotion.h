//
//  FJPromotion.h
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FJDownloadBean.h"

@interface FJPromotion : NSObject

@property (nonatomic, copy)NSString* ID;      //推广ID

@property (nonatomic, copy)NSString* gameId;  //游戏ID

@property (nonatomic, copy)NSString* clientUserId;

@property (nonatomic, copy)NSString* state;

@property (nonatomic, copy)NSString* code;

@property (nonatomic, copy)NSString* gameName;

@property (nonatomic, assign)NSInteger registNum;

@property (nonatomic, assign)CGFloat payMoney;

@property (nonatomic, assign)BOOL isChecked; //是否结算

@property (nonatomic, assign)CGFloat agentMoney;

@property (nonatomic, copy)NSString* radio;//分成比

@property (nonatomic, strong)NSArray<FJDownloadBean*>* downloadBean;

@property (nonatomic, strong)NSDate* startDate; //起始时间（起始时间和结束时间为一个月）

@property (nonatomic, strong)NSDate* endDate; //结束时间

@property (nonatomic, strong)NSString* promotionMonth; //推广月份，2018-08

@end


