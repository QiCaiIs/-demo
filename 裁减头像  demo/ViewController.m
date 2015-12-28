//
//  ViewController.m
//  裁减头像  demo
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "YSHYClipViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ClipViewControllerDelegate>

@end

@implementation ViewController
{
    UIImageView * bigImageView;
    UIImagePickerController * imagePicker;
    UIButton * btn;
    ClipType clipType;
    UIButton * circleBtn;
    UIButton * squareBtn;
    UITextField * textField ;
    CGFloat radius;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    bigImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bigImageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:bigImageView];
    [self ConfigUI];
}
-(void)ConfigUI
{
    btn = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    [btn setBackgroundColor:[UIColor colorWithRed:239/255.0 green:156/255.0 blue:158/255.0 alpha:.8]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 15;
    btn.clipsToBounds = YES;
    [btn setFrame:CGRectMake(self.view.frame.size.width/ 2 - 50, 100, 100, 100)];
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc]init];
    [label setText:@"上传头像"];
    [label setFont:[UIFont systemFontOfSize:18.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFrame:CGRectMake(self.view.frame.size.width/ 2 - 50, 215, 100, 15)];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/ 2 - 130, 260, 150, 25)];
    [label1 setText:@"选择裁剪类型:"];
    [self.view addSubview:label1];
    
    circleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [circleBtn setBackgroundColor:[UIColor redColor]];
    [circleBtn setFrame:CGRectMake(self.view.frame.size.width/ 2 - 90, 300, 100, 40)];
    [circleBtn setTitle:@"圆形裁剪" forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(selectedClipType:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.layer.cornerRadius = 15;
    circleBtn.clipsToBounds = YES;
    [self.view addSubview:circleBtn];
    
    squareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [squareBtn setFrame:CGRectMake(self.view.frame.size.width/ 2 + 10, 300, 100, 40)];
    [squareBtn setTitle:@"方形裁剪" forState:UIControlStateNormal];
    [squareBtn addTarget:self action:@selector(selectedClipType:) forControlEvents:UIControlEventTouchUpInside];
    squareBtn.layer.cornerRadius = 15;
    squareBtn.clipsToBounds = YES;
    [self.view addSubview:squareBtn];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/ 2 - 110, 350, 210, 25)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"请输入裁剪半径 默认120";
    [self.view addSubview:textField];
}
-(void)selectedClipType:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor redColor]];
    if([sender.titleLabel.text isEqualToString:@"圆形裁剪"])
    {
        clipType = CIRCULARCLIP;
        [squareBtn setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        clipType = SQUARECLIP;
        [circleBtn setBackgroundColor:[UIColor clearColor]];
    }
}
-(void)btnClick:(UIButton *)btn
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    
    YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:image];
    clipView.delegate = self;
    clipView.clipType = clipType; //支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
    if(![textField.text isEqualToString:@""])
    {
        radius = textField.text.intValue;
        clipView.radius = radius;   //设置 裁剪框的半径  默认120
    }
    //    clipView.scaleRation = 2;// 图片缩放的最大倍数 默认为3
    [picker pushViewController:clipView animated:YES];
    
}

#pragma mark - ClipViewControllerDelegate
-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        [btn setImage:editImage forState:UIControlStateNormal];
    }];;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
