//
//  FJAppVerServer.m
//  LetuGame
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJAppVerServer.h"

@implementation FJAppVerServer

- (void)setVersion:(NSString *)version
{
    _version = version;
    
    self.appVersion = version;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    self.appUpdateUrl = url;
}

- (void)setIsforce:(BOOL)isforce
{
    _isforce = isforce;
    
    self.isForceUpdate = isforce;
}

- (void)setCreatetime:(NSString *)createtime
{
    _createtime = createtime;
    
    self.appReleaseTime = createtime;
}
@end
