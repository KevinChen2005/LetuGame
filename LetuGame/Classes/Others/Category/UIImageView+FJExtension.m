//
//  UIImageView+FJExtension.m
//  LetuGame
//
//  Created by  admin on 18/5/30.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "UIImageView+FJExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (FJExtension)

- (void)setIcon:(NSString *)url {
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ?  [image circleImage] : placeholder;
    }];
}

@end
