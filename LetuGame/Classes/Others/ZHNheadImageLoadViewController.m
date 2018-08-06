//
//  ZHNheadImageLoadViewController.m
//  zhnHeadImageLoadVC
//
//  Created by zhn on 16/4/8.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNheadImageLoadViewController.h"

@interface ZHNheadImageLoadViewController ()
@property (nonatomic,weak) UIImageView * chosedHeadImageView;
@property (nonatomic,weak) UIView * boardView;
@property (nonatomic,assign) CGRect headImageOldRect;
@end

static  CGFloat viewWeidth;
static  CGFloat viewHeight;
static  CGFloat newImageWeidth;
static  CGFloat newImageHeight;
static const CGFloat animationTime =  0.3f;
static const CGFloat maxScale = 2;
@implementation ZHNheadImageLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewWeidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    self.view.backgroundColor = [UIColor blackColor];
    
    // 初始化图片
    [self P_initSubImage];
    // 初始化手势
    [self P_initGestureRecognizer];
    // 初始化遮罩
    [self P_addmaskView];
    // 初始化按钮
    [self P_initSubBttons];
}



#pragma mark - 初始化控件
- (void)P_initSubImage{
    
    UIImageView * chosedHeadImageView = [[UIImageView alloc]initWithImage:self.oldImage];
    self.chosedHeadImageView = chosedHeadImageView;
    [self.view addSubview:chosedHeadImageView];
    chosedHeadImageView.center = self.view.center;
    
    CGFloat weidthScale = chosedHeadImageView.image.size.width / viewWeidth;
    CGFloat heightScale = chosedHeadImageView.image.size.height / viewHeight;

    
    // 长宽按照比例显示
    if (weidthScale > heightScale) {
        newImageWeidth = viewWeidth;
        newImageHeight = viewWeidth / (chosedHeadImageView.image.size.width / chosedHeadImageView.image.size.height);
    }else{
        newImageHeight = viewHeight;
        newImageWeidth = viewHeight / (chosedHeadImageView.image.size.height / chosedHeadImageView.image.size.width);
    }
    chosedHeadImageView.bounds = CGRectMake(0, 0, newImageWeidth, newImageHeight);
    
    self.headImageOldRect = chosedHeadImageView.frame;
}

- (void)P_initGestureRecognizer{
    
    UIPinchGestureRecognizer * pich = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pichHeadImage:)];
    [self.view addGestureRecognizer:pich];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHeadImage:)];
    [self.view addGestureRecognizer:pan];
}

- (void)P_addmaskView{
    
    UIView * maskView = [[UIView alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    maskView.frame = self.view.bounds;
    [self.view addSubview:maskView];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    
    // 遮罩
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectMake(0, 0, viewWeidth, (viewHeight - viewWeidth)/2));
    CGPathAddRect(path, nil, CGRectMake(0, (viewHeight + viewWeidth)/2, viewWeidth, (viewHeight - viewWeidth)/2));
    maskLayer.path = path;
    maskView.layer.mask = maskLayer;
    
    // 框
    UIView * boardView = [[UIView alloc]init];
    boardView.backgroundColor = [UIColor clearColor];
    boardView.layer.borderColor = [UIColor whiteColor].CGColor;
    boardView.layer.borderWidth = 1;
    [self.view addSubview:boardView];
    self.boardView = boardView;
    boardView.frame = CGRectMake(0, (viewHeight - viewWeidth)/2, viewWeidth, viewWeidth);
}

- (void)P_initSubBttons{
    
    UIButton * cancleButton = [[UIButton alloc]init];
    [self.view addSubview:cancleButton];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(30, viewHeight-60, 40, 40);
    [cancleButton addTarget:self action:@selector(P_clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * tureButton = [[UIButton alloc]init];
    [self.view addSubview:tureButton];
    [tureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tureButton setTitle:@"确定" forState:UIControlStateNormal];
    tureButton.frame = CGRectMake(viewWeidth -70, viewHeight-60, 40, 40);
    [tureButton addTarget:self action:@selector(P_clickTrueButton) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 事件处理
// 手势
- (void)pichHeadImage:(UIPinchGestureRecognizer *)pinch{
    
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        CGFloat newWidth = self.chosedHeadImageView.frame.size.width * pinch.scale;
        CGFloat newHeight = self.chosedHeadImageView.frame.size.height * pinch.scale;
        self.chosedHeadImageView.bounds = CGRectMake(0, 0, newWidth, newHeight);
        pinch.scale = 1;
    }else if(pinch.state == UIGestureRecognizerStateEnded){
        
        [self P_autoScale];
      
        [self P_autoTransLationUseRect:self.chosedHeadImageView.frame];
    }
}

- (void)panHeadImage:(UIPanGestureRecognizer *)pan{

    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint transLationPoint = [pan translationInView:self.view];
        CGFloat newCentX = self.chosedHeadImageView.center.x + transLationPoint.x;
        CGFloat newCentY = self.chosedHeadImageView.center.y + transLationPoint.y;
        self.chosedHeadImageView.center = CGPointMake(newCentX, newCentY);

        [pan setTranslation:CGPointZero inView:self.view.superview];
        
    }else if(pan.state == UIGestureRecognizerStateEnded){
        
        [self P_autoTransLationUseRect:self.chosedHeadImageView.frame];
    }
}

// 点击取消
- (void)P_clickCancleButton{
    self.chosedHeadImageView.frame = self.headImageOldRect;
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击确定
- (void)P_clickTrueButton{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(viewWeidth, viewWeidth), YES, [UIScreen mainScreen].scale);
            // 这时候的imagerect要相对这个上下文了
            CGRect imageRect = CGRectMake(self.chosedHeadImageView.frame.origin.x, self.chosedHeadImageView.frame.origin.y - (viewHeight-viewWeidth)/2, self.chosedHeadImageView.frame.size.width, self.chosedHeadImageView.frame.size.height);
            
            [self.chosedHeadImageView.image drawInRect:imageRect];
            UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // 不做这处理放大很多的情况下会有bug
            self.chosedHeadImageView.frame = self.headImageOldRect;
            
            if (self.ZHNheadImageBlock) {
                self.ZHNheadImageBlock(tempImage);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}



// 移动处理
- (void)P_autoTransLationUseRect:(CGRect)choseHeadRect{
    
    CGRect boardRect = self.boardView.frame;
    // 水平方向
    if (choseHeadRect.origin.x > boardRect.origin.x) {
        choseHeadRect.origin.x = boardRect.origin.x;
    }
    
    if (CGRectGetMaxX(choseHeadRect) <= boardRect.size.width) {
        choseHeadRect.origin.x  = boardRect.size.width - choseHeadRect.size.width;
    }

    // 垂直方向
    if (choseHeadRect.origin.y > boardRect.origin.y) {
        choseHeadRect.origin.y = boardRect.origin.y;
    }
    if (CGRectGetMaxY(choseHeadRect) <= CGRectGetMaxY(boardRect)) {
        choseHeadRect.origin.y = boardRect.origin.y + boardRect.size.height - choseHeadRect.size.height;
    }
    
   
    if (choseHeadRect.size.width < boardRect.size.width || choseHeadRect.size.height < boardRect.size.height) {// 特殊情况
       
        [UIView animateWithDuration:animationTime animations:^{
            self.chosedHeadImageView.center = self.boardView.center;
        }];
        
    }else{
        
        [UIView animateWithDuration:animationTime animations:^{
            self.chosedHeadImageView.frame = choseHeadRect;
        }];
    }
    
}

// 缩放处理
- (void)P_autoScale{
    
    CGFloat scale = self.chosedHeadImageView.frame.size.width / viewWeidth;
    if (scale < 1) {
        [UIView animateWithDuration:animationTime animations:^{
            self.chosedHeadImageView.bounds = CGRectMake(0, 0,newImageWeidth, newImageHeight);
        }];
    }else if(scale > maxScale){
        
        [UIView animateWithDuration:animationTime animations:^{
            self.chosedHeadImageView.bounds = CGRectMake(0, 0,newImageWeidth * maxScale, newImageHeight * maxScale);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
