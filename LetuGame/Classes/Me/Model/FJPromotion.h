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

@property (nonatomic, assign)CGFloat agentMoney;

@property (nonatomic, copy)NSString* radio;//分成比

@property (nonatomic, strong)NSArray<FJDownloadBean*>* downloadBean;

@property (nonatomic, strong)NSDate* startDate;

@property (nonatomic, strong)NSDate* endDate;

@end


