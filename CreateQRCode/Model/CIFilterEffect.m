//
//  CIFilterEffect.m
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//

#import "CIFilterEffect.h"



@interface CIFilterEffect ()


@property (nonatomic, strong, readwrite) UIImage *result;


@end

@implementation CIFilterEffect

- (instancetype)initWithImage:(UIImage *)image
                   filterName:(NSString *)name

{
    self = [super init];
    
    if (self) {
        // 将UIImage转换成CIImage
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        // 创建滤镜
        CIFilter *filter = [CIFilter filterWithName:name
                                      keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setDefaults];
        
        // 获取绘制上下文
        CIContext *context = [CIContext contextWithOptions:nil];
        
        // 渲染并输出CIImage
        CIImage *outputImage = [filter outputImage];
        
        // 创建CGImage句柄
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        
        _result = [UIImage imageWithCGImage:cgImage];
        
        // 释放CGImage句柄
        CGImageRelease(cgImage);
    }
    return self;
}

@end
