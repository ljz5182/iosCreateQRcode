//
//  UIImage+Extens.m
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//

#import "UIImage+Extens.h"

@implementation UIImage (Extens)


void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}


/**
 调整二维码清晰度
 
 @param image 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                            withSize:(CGFloat)size
{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //清晰的二维码图片
    return [UIImage imageWithCGImage:scaledImage];
}



/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */

+ (UIImage *)sencond_getHDImgWithCIImage:(CIImage *)img
                                    size:(CGSize)size {
    
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}



/**
 修改二维码颜色
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
+ (UIImage *)changeColorWithQRCodeImg:(UIImage *)image
                                  red:(NSUInteger)red
                                green:(NSUInteger)green
                                 blue:(NSUInteger)blue
{
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self changeColorOnPixel:rgbImageBuf pixelNum:pixelNumber red:red green:green blue:blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}



/**
 遍历像素点，修改颜色
 
 @param rgbImageBuf rgbImageBuf
 @param pixelNum pixelNum
 @param red red
 @param green green
 @param blue blue
 */
+ (void)changeColorOnPixel:(uint32_t *)rgbImageBuf
                  pixelNum:(int)pixelNum
                       red:(NSUInteger)red
                     green:(NSUInteger)green
                      blue:(NSUInteger)blue {
    
    uint32_t * pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        
        //通过颜色区分是不是要改变的区域
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}



/**
 调整二维码清晰度，添加水印图片
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @param waterImg 水印图片
 @return 添加水印图片后，清晰的二维码图片
 */
+ (UIImage *)getHDImgWithCIImage:(CIImage *)img
                            size:(CGSize)size
                        waterImg:(UIImage *)waterImg
{
    
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //清晰的二维码图片
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //水印图片
    //把水印图片画到生成的二维码图片上，注意尺寸不要太大（根据上面生成二维码设置的纠错程度设置），否则有可能造成扫不出来
    [waterImg drawInRect:CGRectMake((size.width-waterImg.size.width)/2.0, (size.height-waterImg.size.height)/2.0, waterImg.size.width, waterImg.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}


/**
 拼接图片
 
 @param imgOne 图片1
 @param imgTwo 图片2
 @return 拼接后的图片
 */
+ (UIImage *)spliceImgOne:(UIImage *)imgOne
                   imgTwo:(UIImage *)imgTwo {
    
    CGSize sizeOne = imgOne.size;
    CGSize sizeTwo = imgTwo.size;
    
    UIGraphicsBeginImageContextWithOptions(imgOne.size, NO, [[UIScreen mainScreen] scale]);
    [imgOne drawInRect:CGRectMake(0, 0, imgOne.size.width, imgOne.size.height)];
    
    [imgTwo drawInRect:CGRectMake((sizeOne.width-sizeTwo.width)/2.0, (sizeOne.height-sizeTwo.height)/2.0, sizeTwo.width, sizeTwo.height)];
    //[imgTwo drawInRect:CGRectMake(sizeOne.width/4.0, sizeOne.height/2.5, sizeOne.width/2, sizeOne.width/2)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
