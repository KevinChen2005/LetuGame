//
//  FJConfirmPwdViewController.h
//  LetuGame
//
//  Created by admin on 2018/12/26.
//  Copyright © 2018 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FJConfirmPwdDelegate;

@interface FJConfirmPwdViewController : UIViewController

@property (nonatomic, weak) id<FJConfirmPwdDelegate> delegate;

@end

@protocol FJConfirmPwdDelegate <NSObject>

- (void)confirmPwdCallback:(NSString*)password;

@end

NS_ASSUME_NONNULL_END
