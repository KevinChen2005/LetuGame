//
//  FJDetailCell.m
//  LetuGame
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJDetailHeader.h"
#import "IMYWebView.h"
#import "HZPhotoBrowser.h"

#define kMargin 20

@interface FJDetailHeader() <IMYWebViewDelegate, HZPhotoBrowserDelegate>

@property(nonatomic, strong)IMYWebView *htmlWebView;
@property(nonatomic, copy)completeBlock complete;
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property(nonatomic, strong)UIButton *likeBtn;//HTML中的图片个数

@end

@implementation FJDetailHeader

- (instancetype)initWithLoadHtmlString:(NSString *)htmlString CompleteBlock:(completeBlock)complete
{
    if (self = [super init]) {
        // 从下往上布局
//        // 构建底部分割线
//        UIView* seperateLine = [[UIView alloc] init];
//        seperateLine.backgroundColor = FJGlobalBG;
//        [self addSubview:seperateLine];
//        [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.equalTo(@1);
//        }];
        self.backgroundColor = [UIColor whiteColor];
        
        // 构建点赞按钮
        UIButton* likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.layer.borderWidth = 1;
        likeBtn.layer.borderColor = [UIColor redColor].CGColor;
        likeBtn.layer.cornerRadius = 18;
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        likeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [likeBtn setTitle:@"0人喜欢" forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [likeBtn setImage:[UIImage imageNamed:@"ic_quanzi_zan_light"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"ic_quanzi_zan"] forState:UIControlStateSelected];
        [likeBtn addTarget:self action:@selector(clickLike:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBtn];
        self.likeBtn = likeBtn;
        
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(@120);
            make.height.mas_equalTo(likeBtn.mas_width).multipliedBy(0.3);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kMargin);
        }];
        
        // 构建webView
        IMYWebView* htmlWebView = [[IMYWebView alloc] init];
        htmlWebView.delegate = self;
        htmlWebView.scrollView.scrollEnabled = NO;//设置webview不可滚动，让tableview本身滚动即可
        htmlWebView.scrollView.bounces = NO;
        htmlWebView.opaque = NO;
        htmlWebView.scrollView.scrollsToTop = NO;
        htmlWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.htmlWebView = htmlWebView;
        [self addSubview:htmlWebView];
        
        [htmlWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(likeBtn.mas_top).offset(-kMargin);
        }];
        
        self.complete = complete;
        
        [self.htmlWebView loadHTMLString:htmlString baseURL:nil];
        
        self.likeCount = 0;
    }
    
    return self;
}

- (void)clickLike:(UIButton*)btn
{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [btn setBackgroundColor:[UIColor redColor]];
//    } else {
//        [btn setBackgroundColor:[UIColor whiteColor]];
//    }
    
    if ([self.delegate respondsToSelector:@selector(detailHeader:onClickLikeBtn:)]) {
        [self.delegate detailHeader:self onClickLikeBtn:nil];
    }
}

- (void)setLikeCount:(NSInteger)likeCount
{
    _likeCount = likeCount;
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld人喜欢", likeCount] forState:UIControlStateNormal];
}

- (void)setIsLiked:(BOOL)isLiked
{
    _isLiked = isLiked;
    
    self.likeBtn.selected = isLiked;
    
    if (isLiked) {
        [self.likeBtn setBackgroundColor:[UIColor redColor]];
    } else {
        [self.likeBtn setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark -- IMYWebViewDelegate

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL isEqual:@"about:blank"])
    {
        return true;
    }
    
    //启动图片浏览器， 跳转到图片浏览页面
    if ([request.URL.scheme isEqualToString: @"image-preview"]) {
        NSString *url = [request.URL.absoluteString substringFromIndex:14];
        if (_imageArray.count != 0) {
            HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
            browserVc.imageCount = self.imageArray.count; // 图片总数
            browserVc.currentImageIndex = [_imageArray indexOfObject:url];//当前点击的图片
            browserVc.delegate = self;
            [browserVc show];
        }
        return NO;
    }
    
    // 用户点击文章详情中的链接
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        if ([self.delegate respondsToSelector:@selector(detailHeader:onClickUrlLink:)]) {
            [self.delegate detailHeader:self onClickUrlLink:request.URL.absoluteString];
        }
        return NO;
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [self.htmlWebView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id object, NSError *error) {
        NSInteger height = [object integerValue];
        //返回header总高度 webView 和 点赞按钮高度
        if (self.complete) {
            self.complete(height + self.likeBtn.fj_height + 4*kMargin);
        }
    }];
    
    // 插入js代码，对图片进行点击操作
    NSString* jsString = @"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}";
    [webView evaluateJavaScript:jsString completionHandler:^(id object, NSError *error) {
        if (error) {
            NSLog(@"evaluateJavaScript error: %@", error);
        }
    }];
    [webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:^(id object, NSError *error) {
        if (error) {
            NSLog(@"evaluateJavaScript error: %@", error);
        }
    }];
    
    //获取HTML中的图片
    [self getImgs];
}

#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgs
{
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [_htmlWebView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
            
            if (error ==nil) {
                [arrImgURL addObject:str];
            }
        }];
    }
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    return arrImgURL;
}

// 获取某个标签的结点个数
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int count = [[self.htmlWebView stringByEvaluatingJavaScriptFromString:jsString] intValue];

    return count;
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return [UIImage imageNamed:@"img_place_holder2"];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.imageArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}


@end
