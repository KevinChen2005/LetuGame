//
//  FJUserDetailModel.h
//  LetuGame
//
//  Created by admin on 2018/12/25.
//  Copyright © 2018 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FJUserDetailModel : NSObject

@property (nonatomic, copy)NSString* userId;         //用户id
@property (nonatomic, copy)NSString* realName;       //真实姓名
@property (nonatomic, copy)NSString* idNumber;       //身份证号
@property (nonatomic, copy)NSString* bankCardNumber; //银行卡号
@property (nonatomic, copy)NSString* openBank;       //银行卡开户行信息
@property (nonatomic, copy)NSString* other;          //扩展字段
@property (nonatomic, copy)NSString* idCardUrl1;     //身份证正面照片
@property (nonatomic, copy)NSString* idCardUrl2;     //身份证背面照片

@end

NS_ASSUME_NONNULL_END

/*
 bankCardNumber = "\U94f6\U884c\U5361\U53f7";
 idCardUrl1 = "";
 idCardUrl2 = "";
 idNumber = "\U8eab\U4efd\U8bc1\U53f7\U7801";
 openBank = "\U5f00\U6237\U884c";
 other = "";
 realName = "\U771f\U5b9e\U59d3\U540d";
 userId = 6b7f3d6b9f244719be2396e7ed898254;
 */
