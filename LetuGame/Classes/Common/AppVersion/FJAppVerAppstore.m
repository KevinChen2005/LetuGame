//
//  FJAppVerAppstore.m
//  LetuGame
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJAppVerAppstore.h"

@implementation FJAppVerAppstore

- (void)setVersion:(NSString *)version
{
    _version = version;
    
    self.appVersion = version;
}

- (void)setTrackViewUrl:(NSString *)trackViewUrl
{
    _trackViewUrl = trackViewUrl;
    
    self.appUpdateUrl = trackViewUrl;
}

- (void)setReleaseDate:(NSString *)releaseDate
{
    _releaseDate = releaseDate;
    
    self.appReleaseTime = releaseDate;
}
@end
