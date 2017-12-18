//
//  CoreImageController.m
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//
// 在iOS中开发过程中，想对图片进行简单的处理，那么很简单，苹果帮我们封装了一套简单易用的API——CIFilter。
//
// 使用CIFilter你可以做到：调节图片亮度、对比度、饱和度等图片基本的操作；使用模糊、锐化、高反差等对图片进行滤镜处理。

#import "CoreImageController.h"
#import "CIFilterEffect.h"



@interface CoreImageController ()

@property (nonatomic , retain) UIImageView * showImageView;


@end

@implementation CoreImageController

@synthesize showImageView;



#define FIX_IMAGE(image)  fixImageWidth(image, self.view.frame.size.width)

// 固定图片的宽度
UIImage * fixImageWidth(UIImage *image, CGFloat width)
{
    float newHeight = image.size.height * (width / image.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height),
                       image.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOut;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 显示各种滤镜效果
//    [self initshowUI];
    
    
    // 毛玻璃效果
//    [self blurResult];
    
    
    // 高斯模糊运动模糊
//    [self runactionResult];
    
    
    // 怀旧
    [self oldResult];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initshowUI {
    
    
    /**
     *  系统API 提供了以下各种滤镜效果
     *  CILinearToSRGBToneCurve
     *  CIPhotoEffectChrome
     *  CIPhotoEffectFade
     *  CIPhotoEffectInstant
     *  CIPhotoEffectMono
     *  CIPhotoEffectNoir
     *  CIPhotoEffectProcess
     *  CIPhotoEffectTonal
     *  CIPhotoEffectTransfer
     *  CISRGBToneCurveToLinear
     *  CIVignetteEffect
     */
    
    // 获取图片
    UIImage * images = [[CIFilterEffect alloc] initWithImage:[UIImage imageNamed:@"back.png"] filterName:@"CIPhotoEffectMono"].result;
    
//    if (!showImageView) {
//        showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [self.view addSubview:showImageView];
//    }
    
    showImageView = [[UIImageView alloc]initWithImage:FIX_IMAGE(images)];
    [self.view addSubview:showImageView];
    
}


- (void)showUI {
    if (!showImageView) {
        showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        showImageView.image = [UIImage imageNamed:@"back.png"];
        showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:showImageView];
    }
}

- (void)blurResult {
    
    [self showUI];
    //  开始做毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.frame = self.view.frame;
    [self.showImageView addSubview:visualEffectView];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *ano = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    ano.frame = self.view.frame;
    [self.view addSubview:self.showImageView];
    
}


- (void)runactionResult {
    
    [self showUI];
    
    // 以下代码是高斯模糊
    CIImage *inputImage = [CIImage imageWithCGImage:self.showImageView.image.CGImage];
    
    // CIGaussianBlur   高斯模糊
    // CIBoxBlur        均值模糊
    // CIDiscBlur       环形卷积模糊
    // CIMotionBlur     运动模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIMotionBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@5 forKey:kCIInputRadiusKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outupImage = filter.outputImage;
    CGImageRef imageRef = [context createCGImage:outupImage fromRect:outupImage.extent];
    self.showImageView.image= [UIImage imageWithCGImage:imageRef];
}


- (void)oldResult {
    
    [self showUI];
    
    // 发下是怀旧代码
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self.showImageView.image];
    
    // 怀旧  CIPhotoEffectInstant
    // 单色  CIPhotoEffectMono
    // 黑白  CIPhotoEffectNoir
    // 褪色  CIPhotoEffectFade
    // 色调  CIPhotoEffectTonal
    // 冲印  CIPhotoEffectProcess
    // 岁月  CIPhotoEffectTransfer
    // 铬黄  CIPhotoEffectChrome
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    self.showImageView.image= [UIImage imageWithCGImage:resultImage.CGImage];
}


@end
