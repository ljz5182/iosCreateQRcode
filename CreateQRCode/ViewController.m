//
//  ViewController.m
//  CreateQRCode
//
//  Created by 梁家章 on 18/12/2017.
//  Copyright © 2017 liangjiazhang. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+Extens.h"
#import "CoreImageController.h"









@interface ViewController ()

@property (nonatomic, retain) UIImageView * codeImageView;

@property (nonatomic, retain) UIButton * testButton;


@end

@implementation ViewController


@synthesize codeImageView , testButton;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   // [self initUI];
    
    
    [self initButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUI {
    
    
    if (!codeImageView) {
        codeImageView = [[UIImageView alloc] initWithFrame: CGRectMake( 40, 80, 120, 120)];
        [self.view addSubview:codeImageView];
    }
    
    // 1.  创建一个二维码滤镜实例(CIFilter)
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    
    NSString *string = @"https://www.baidu.com/";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 设置 filter 容错等级
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // 3. 生成二维码
    CIImage * image = [filter outputImage];
    
    // 4. 显示二维码
   // self.codeImageView.image = [UIImage createNonInterpolatedUIImageFormCIImage:image withSize:200.0];   //[UIImage imageWithCIImage:image];
    
    // 5. 改变二维码的颜色
//    self.codeImageView.image = [UIImage changeColorWithQRCodeImg:[UIImage createNonInterpolatedUIImageFormCIImage:image
//                                                                                                         withSize:200.0]
//                                                             red:120
//                                                           green:60
//                                                            blue:201];
    
    
    
    // 6. 添加logo 图片
//    self.codeImageView.image = [UIImage getHDImgWithCIImage:image
//                                                       size:CGSizeMake(600.0, 600.0)
//                                                   waterImg:[UIImage imageNamed:@"logo_main.png"]];
    
    
    // 7. 图片拼接
    self.codeImageView.image = [UIImage spliceImgOne:[UIImage imageNamed:@"ysb_startup.png"]
                                              imgTwo:[UIImage createNonInterpolatedUIImageFormCIImage:image
                                                                                             withSize:200.0]];
    
}


- (void)initButton {
    
    if (!testButton) {
        testButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 120, 120, 40)];
        testButton.backgroundColor = [UIColor redColor];
        [testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testButton];
    }
    
    
    
}

- (void)testButtonAction {
    

    CoreImageController * coreImageController = [[CoreImageController alloc]init];
    
    [self presentViewController:coreImageController animated:NO completion:nil];
    
}


@end
