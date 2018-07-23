//
//  FJGameInfo.h
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJGameInfo : NSObject

@property (nonatomic, copy)NSString* ID;
@property (nonatomic, copy)NSString* gameName;
@property (nonatomic, copy)NSString* gameTarget;
@property (nonatomic, copy)NSString* openTime;
@property (nonatomic, copy)NSString* policy;
@property (nonatomic, copy)NSString* state;
@property (nonatomic, copy)NSString* typeId;
@property (nonatomic, copy)NSString* desc;
@property (nonatomic, copy)NSString* company;
@property (nonatomic, assign)CGFloat discount;

@end

/*
 gameInfo =
 {
 company = "\U66b4\U96ea";
 description = "\U4ed6\U5f88\U61a8\U539a\U3002\U53c2\U52a0\U7530\U5f84\U6bd4\U8d5b\U7684\U4ed6\U8eab\U624b\U654f\U6377\Uff0c\U662f\U4e2a\U7530\U5f84\U597d\U624b\U3002";
 discount = "0.2";
 gameName = "\U76d8\U9f99";
 gameTarget = "\U7384\U5e7b";
 id = 847230a624e34b239fa1b17632efbd47;
 openTime = "2018-07-16";
 policy = "<null>";
 state = "\U8fd0\U8425";
 typeId = "\U5373\U65f6\U6218\U6597";
 };
 */
