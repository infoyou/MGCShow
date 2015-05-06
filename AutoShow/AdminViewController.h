//
//  AdminViewController.h
//  WebviewDemo
//
//  Created by 5adian on 15/3/9.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AdminViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *progressBGView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

