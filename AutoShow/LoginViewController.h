//
//  LoginViewController.m
//  WebviewDemo
//
//  Created by Adam on 15/3/11.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface LoginViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIImageView *loginBG;

@property (weak, nonatomic) IBOutlet UIView *pickerBGView;
@property (weak, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *pswdTxt;

@property (weak, nonatomic) IBOutlet UITextField *activityTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

