//
//  CIFilterEffect.h
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CIFilterEffect : NSObject


@property (nonatomic, strong, readonly) UIImage *result;

- (instancetype)initWithImage:(UIImage *)image
                   filterName:(NSString *)name;

@end
