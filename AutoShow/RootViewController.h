//
//  RootViewController
//  WebviewDemo
//
//  Created by Adam on 15/3/11.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "FMDBConnection.h"
#import "Reachability.h"
#import "UIAlertView+IABlocks.h"

@interface RootViewController : UIViewController
{

}

@property (nonatomic, retain) NSMutableData *myData;

- (BOOL) isConnectionAvailable;

@end

