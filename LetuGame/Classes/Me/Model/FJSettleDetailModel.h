//
//  FJSettleDetailModel.h
//  LetuGame
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJSettleDetailModel : NSObject

@property (nonatomic, copy)NSString* gameid;

@property (nonatomic, copy)NSString* userid;

@property (nonatomic, copy)NSString* week; //周次

@property (nonatomic, assign)CGFloat rechargeMoney;  //充值

@property (nonatomic, assign)CGFloat agentMoney; //收入

@property (nonatomic, assign)BOOL isPay;  //是否结算

@end

/*
 {
 "id": null,
 "gameid": "847230a624e34b239fa1b17632efbd47",
 "month": "2018-08",
 "week": 1,
 "userid": "31e17375cd9e4f25a92a90cbdb048949",
 "rechargeMoney": 16405,
 "rate": 0.22,
 "agentMoney": 3609.1,
 "isPay": 0,
 "payTime": null,
 "startTime": null,
 "endTime": null,
 "isThisMon": true
 }

 */
