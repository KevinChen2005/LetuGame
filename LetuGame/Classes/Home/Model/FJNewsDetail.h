//
//  FJNewsDetail.h
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJComment.h"
#import "FJGame.h"

@interface FJNewsDetail : NSObject

@property (nonatomic, copy)NSString* ID;

@property (nonatomic, copy)NSString* gameId;

@property (nonatomic, copy)NSString* title;

@property (nonatomic, copy)NSString* creattime;

@property (nonatomic, copy)NSString* creatUser;

@property (nonatomic, copy)NSString* content;

@property (nonatomic, assign)NSInteger score;

@property (nonatomic, copy)NSString* source;

@property (nonatomic, copy)NSString* typeOne;

@property (nonatomic, copy)NSString* typeTwo;

@property (nonatomic, assign)BOOL isCollected;

@property (nonatomic, assign)BOOL isLiked;

@property (nonatomic, strong)FJGame* game;
@property (nonatomic, strong)NSArray<FJComment*>* commets;

@end

/*
 {
 comments =         (
 {
 avatarUrl = "";
 content = "Test add comment";
 createtime = "2018-07-16 20:26:05";
 id = 21;
 isLiked = 0;
 isMe = 0;
 "kind_id" = a5e3106a88094cb68251ef80816f4813;
 nickName = "yk_gtiwkwll";
 score = 0;
 userid = 456fa894941a41588319f3111d96fcf7;
 },
 );
 
 content = "";
 creatUser = "<null>";
 creattime = 1522314879000;
 
 game =         {
 company = "\U817e\U8baf";
 description = "\U8fce\U8fce\U662f\U4e00\U53ea\U673a\U654f\U7075\U6d3b\U9a70\U9a8b\U5982\U98de\U7684\U85cf\U7f9a\U7f8a\Uff0c\U4ed6\U6765\U81ea\U4e2d\U56fd\U8fbd\U9614\U7684\U897f\U90e8\U5927\U5730\Uff0c\U4ed6\U5c06\U5065\U5eb7\U7684\U7f8e\U597d\U795d\U798f\U4f20\U5411\U4e16\U754c\U3002\U8fce\U8fce\U662f\U9752\U85cf\U9ad8\U539f\U7279\U6709\U7684\U4fdd\U62a4\U52a8\U7269-----\U85cf\U7f9a\U7f8a\Uff0c\U662f\U7eff\U8272\U5965\U8fd0\U7684\U5c55\U73b0,\U4ed6\U4ee3\U8868\U5965\U6797\U5339\U514b\U4e94\U73af\U4e2d\U9ec4\U8272\U4e00\U73af.\U3002
 \n\U4ed6\U7684\U6027\U683c\U4e2d\U4e5f\U6709\U7740\U897f\U90e8\U9ec4\U571f\U5730\U4e0a\U7279\U6709\U7684\U8e0f\U5b9e\U548c\U672c\U5206\Uff0c\U662f\U6807\U51c6\U7684\U91d1\U725b\U5ea7\U3002\U4ed6\U5f88\U61a8\U539a\U3002\U53c2\U52a0\U7530\U5f84\U6bd4\U8d5b\U7684\U4ed6\U8eab\U624b\U654f\U6377\Uff0c\U662f\U4e2a\U7530\U5f84\U597d\U624b\U3002\U4ed6\U7684\U6027\U683c\U4e2d\U4e5f\U6709\U7740\U897f\U90e8\U9ec4\U571f\U5730\U4e0a\U7279\U6709\U7684\U8e0f\U5b9e\U548c\U672c\U5206\Uff0c\U662f\U6807\U51c6\U7684\U91d1\U725b\U5ea7\U3002\U4ed6\U5f88\U61a8\U539a\U3002\U53c2\U52a0\U7530\U5f84\U6bd4\U8d5b\U7684\U4ed6\U8eab\U624b\U654f\U6377\Uff0c\U662f\U4e2a\U7530\U5f84\U597d\U624b\U3002";
 discount = "0.1";
 gameName = "\U6d4b\U8bd5";
 gameTarget = "\U6d4b\U8bd5";
 id = 7492d11081b140b8baf41f960c95fc2f;
 openTime = "2018-07-16";
 policy = "<null>";
 state = "\U6d4b\U8bd5";
 typeId = "\U5373\U65f6\U6218\U6597";
 };
 
 gameId = 7492d11081b140b8baf41f960c95fc2f;
 id = a5e3106a88094cb68251ef80816f4813;
 isCollected = 0;
 isLiked = 0;
 score = 35;
 source = "\U5bf9\U5bf9\U5bf9";
 title = "\U5bf9\U5bf9\U5bf9";
 typeOne = "\U73a9\U5bb6\U653b\U7565";
 typeTwo = "<null>";
 };
 
 */
