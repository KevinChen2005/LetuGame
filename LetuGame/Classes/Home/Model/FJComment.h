//
//  FJComment.h
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJComment : NSObject

@property (nonatomic, copy) NSString* ID;

@property (nonatomic, copy) NSString* kind_id;

@property (nonatomic, copy) NSString* content;

@property (nonatomic, copy) NSString* createtime;

@property (nonatomic, copy) NSString* avatarUrl;

@property (nonatomic, copy) NSString* nickName;

@property (nonatomic, assign) BOOL isLiked;

@property (nonatomic, assign) BOOL isMe;

@property (nonatomic, assign) CGFloat score;


@end

/*
 {
 avatarUrl = "";
 content = 1312441433243;
 createtime = "2018-07-16 20:59:07";
 id = 27;
 isLiked = 0;
 isMe = 0;
 "kind_id" = ae3a62e21b3747c1b7ac5854325b490d;
 nickName = "yk_gtiwkwll";
 score = 0;
 }

 */
