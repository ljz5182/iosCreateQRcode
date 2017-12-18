//
//  UIImage+Extens.h
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extens)


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                            withSize:(CGFloat)size ;


+ (UIImage *)sencond_getHDImgWithCIImage:(CIImage *)img
                                    size:(CGSize)size ;


+ (UIImage *)changeColorWithQRCodeImg:(UIImage *)image
                                  red:(NSUInteger)red
                                green:(NSUInteger)green
                                 blue:(NSUInteger)blue;


+ (UIImage *)getHDImgWithCIImage:(CIImage *)img
                            size:(CGSize)size
                        waterImg:(UIImage *)waterImg;



+ (UIImage *)spliceImgOne:(UIImage *)imgOne
                   imgTwo:(UIImage *)imgTwo;



@end
