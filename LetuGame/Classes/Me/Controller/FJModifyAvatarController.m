//
//  FJModifyAvatarController.m
//  LetuGame
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJModifyAvatarController.h"
#import "ZHNheadImageLoadViewController.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kImageSize_1_M (1024*1024) // 定义1M的大小

@interface FJModifyAvatarController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImageView* avatarView;
@property (nonatomic, strong)UIAlertController* alertController;
@property (nonatomic, strong)UIImagePickerController* imagePicker;

@end

@implementation FJModifyAvatarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人头像";
    
    // 头像视图
    UIImageView* avatarView = [[UIImageView alloc] init];
    avatarView.backgroundColor = FJRGBColor(230, 230, 230);
    [self.view addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_width);
        make.center.mas_equalTo(self.view);
    }];
    self.avatarView = avatarView;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserAuth shared].userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    // 选择按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"选择" forState:UIControlStateNormal];
    [sendBtn setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(0, 0, 50, 20);
    [sendBtn sizeToFit];
    [sendBtn.titleLabel setFont:FJNavbarItemFont];
    [sendBtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserAuth shared].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
}

- (void)select
{
    [self.navigationController presentViewController:self.alertController animated:YES completion:nil];
}

// 懒加载 UIAlertController
- (UIAlertController *)alertController
{
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_alertController addAction:cancelAction];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self takePhotoActionMethod];
        }];
        [_alertController addAction:takePhotoAction];
        
        UIAlertAction *localPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:0 handler:^(UIAlertAction * _Nonnull action) {
            [self localPhotoActionMethod];
        }];
        [_alertController addAction:localPhotoAction];
    }
    return _alertController;
}

// 拍照
- (void)takePhotoActionMethod
{
    //相机权限
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied) { //用户已经明确否认了这一照片数据的应用程序访问
        
        [FJPopView showConfirmViewWithTitle:@"提示" message:@"该功能需要访问相机，去设置中心开启？" okBlock:^{
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        } cancelBlock:nil];
    } else {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

// 从相册选择
- (void)localPhotoActionMethod
{
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author ==ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //无权限 引导去开启
        [FJPopView showConfirmViewWithTitle:@"提示" message:@"该功能需要访问相册，去设置中心开启？" okBlock:^{
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        } cancelBlock:nil];
    } else {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

// 拿到照片之后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"image = %@", image);
//    if (@available(iOS 11.0, *)) {
//        NSLog(@"imagePath = %@", [info objectForKey:UIImagePickerControllerImageURL]);
//    } else {
//        // Fallback on earlier versions
//    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    // 将照片存到相册中
    if (_imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [self buildAvatar:image];
    
    //第三方裁剪（开启系统编辑了就不用第三方裁剪）
//    ZHNheadImageLoadViewController* loadVC = [ZHNheadImageLoadViewController new];
//    loadVC.oldImage = image;
//    loadVC.ZHNheadImageBlock = ^(UIImage* newImage) {
//        [self buildAvatar:newImage];
//    };
//    [self presentViewController:loadVC animated:YES completion:nil];
}

- (void)buildAvatar:(UIImage*)newImage
{
    if (newImage == nil) {
        return;
    }
    UIImage* finalImage = newImage;
    
    //将图片压缩放到上传时
//    NSUInteger length = UIImagePNGRepresentation(newImage).length; //计算图像大小
//    if (length > kImageSize_1_M) { //如果图片大于1M，进行压缩
//        NSData* data = UIImageJPEGRepresentation(newImage, 0.5);
//        if (data.length > kImageSize_1_M) {
//            finalImage = [UIImage imageWithData:data];
//            data = UIImageJPEGRepresentation(finalImage, 0.5);
//            if (data.length > kImageSize_1_M) {
//                finalImage = [UIImage imageWithData:data];
//                data = UIImageJPEGRepresentation(finalImage, 0.5);
//            }
//        }
//        finalImage = [UIImage imageWithData:data];
//    }
    
    self.avatarView.image = finalImage;
    
    NSDictionary* info = @{ @"image" : finalImage };
    
    [HttpTool modifyUserAvatarWithImage:finalImage Success:^(id retObj) {
        NSLog(@"uploadPic retObj = %@", retObj);
        NSDictionary* retDict = (NSDictionary*)retObj;
        if (!retObj || ![retObj isKindOfClass:[NSDictionary class]]) {
            DLog(@"上传失败，返回数据错误 - %@", retObj);
            [FJProgressHUB showErrorWithMessage:@"上传失败，返回数据错误" withTimeInterval:kTimeHubError];
            return;
        }
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
        if ([code isEqualToString:@"1"]) { //上传成功
            NSString* modifyUrl = retDict[@"data"];
            [self modifyInfo:modifyUrl];
            [FJProgressHUB showSuccessWithMessage:@"上传成功" withTimeInterval:kTimeHubSuccess];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModifyAvatarSuccess object:nil userInfo:info];
        } else {
            DLog(@"上传失败-%@", code);
            [FJProgressHUB showErrorWithMessage:message withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        NSLog(@"uploadPic error = %@", error);
        [FJProgressHUB showErrorWithMessage:@"上传失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

- (void)modifyInfo:(NSString*)avatarUrl
{
    if (avatarUrl == nil || [avatarUrl isNullString]) {
        return;
    }
    
    UserModel* userinfo = [UserAuth shared].userInfo;
    userinfo.avatarUrl = avatarUrl;
    [UserAuth saveUserInfo:userinfo];
}

// 判断保存相册是否成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

@end
