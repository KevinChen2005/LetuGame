//
//  FJGameDetail.h
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameInfo.h"
#import "FJGamePic.h"

@interface FJGameDetail : NSObject

@property (nonatomic, strong)FJGameInfo* gameInfo;
@property (nonatomic, strong)NSArray<FJGamePic*>* picArray;

@end


