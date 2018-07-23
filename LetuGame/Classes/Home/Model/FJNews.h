//
//  FJNews.h
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJNews : NSObject

@property (nonatomic, copy)NSString* ID;

@property (nonatomic, copy)NSString* title;

@property (nonatomic, copy)NSString* creattime;

@property (nonatomic, copy)NSString* creatUser;

@property (nonatomic, copy)NSString* content;

@property (nonatomic, copy)NSString* game;

@property (nonatomic, copy)NSString* gameId;

@property (nonatomic, assign)NSInteger score;

@property (nonatomic, copy)NSString* source;

@property (nonatomic, copy)NSString* typeOne;

@property (nonatomic, copy)NSString* typeTwo;


@end


/*
 {
 content = "<null>";
 creatUser = 6578fc6f748548bdbe83c09cefc3e4aa;
 creattime = 1531281097000;
 game = "<null>";
 gameId = 0;
 id = ae3a62e21b3747c1b7ac5854325b490d;
 score = 0;
 source = "<null>";
 title = gg;
 typeOne = "<null>";
 typeTwo = "<null>";
 },
 */
