//
//  GlobalConstants.h
//  MGCShow
//
//  Created by Adam on 15/3/21.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#define VERSION         @"1.0.1"

#ifdef DEBUG
#    define DLog(...)     NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif

// 通用部分
#define PROJECT_DB_NAME             @"ProjectDB"
#define SUBMIT_URL_PATH             @"http://58.68.246.100/club/data_receiver.action?"

//  0,不可以编辑; 1,可以编辑;
#define ADMIN_CAN_EDIT_FLAG         @"0"

// 项目部分
#if CarShowType == 10
// DSFL
#define SURVEY_HTML_NAME            @"index"
#define PROJECT_CODE                @"2015ecodriving"
#define UMENG_ANALYS_APP_KEY        @"550f7e8bfd98c58a95000157"

#elif CarShowType == 11
// 品牌体验馆
#define SURVEY_HTML_NAME            @"brandExperience"
#define PROJECT_CODE                @"2015brandexp"
#define UMENG_ANALYS_APP_KEY        @"5513e476fd98c5dcd10005c3"

#elif CarShowType == 12
// 梦工场
#define SURVEY_HTML_NAME            @"dreamworks"
#define PROJECT_CODE                @"2015DreamWorks"
#define UMENG_ANALYS_APP_KEY        @"5523753dfd98c5f0290006ed"

#elif CarShowType == 13
// CTCC
#define SURVEY_HTML_NAME            @"ctcc"
#define PROJECT_CODE                @"2015CTCC"
#define UMENG_ANALYS_APP_KEY        @"553f3a3b67e58e108b0031b6"

#endif


@interface GlobalConstants : NSObject {
    
}

@end
