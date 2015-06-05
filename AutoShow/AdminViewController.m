
#import "AdminViewController.h"
#import "AppManager.h"
#import "StringCategory.h"

@interface AdminViewController () <UIWebViewDelegate>

@end

@implementation AdminViewController
{
    NSInteger needUploadNum;
    NSInteger currentUploadNum;
    NSInteger errorUploadNum;
    
    BOOL isUploading;
}

@synthesize webView;
@synthesize progressBGView;
@synthesize progressLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isUploading = NO;
    
    currentUploadNum = 0;
    errorUploadNum = 0;
    
    progressBGView.hidden = YES;
    progressLabel.hidden = YES;
    
    // html
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"admin" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObjc = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObjc];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定要返回首页?"
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert setHandler:^(UIAlertView* alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    } forButtonAtIndex:[alert firstOtherButtonIndex]];
    [alert show];
}

#pragma mark - UIWebViewDelegate method

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    // 禁用用户选择
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // 防止拖动后产生白屏
    self.webView.backgroundColor = [UIColor clearColor];
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = [request URL];
    
    NSLog(@"url = %@", url);
    
    //处理JavaScript和Objective-C交互
    if([[[url scheme] lowercaseString] isEqualToString:@"uploaddata"]) {
        
        if (![self isConnectionAvailable:YES]) {
            return NO;
        }
        
        // 提交数据
        if([[url host] isEqualToString:@"data"])
        {
            
            // 直接从Sqlite里面取数据
            NSString *parmString = [[FMDBConnection instance] getNeedSubmitSurveyResult];
            NSArray *needUploadDataArray = [parmString componentsSeparatedByString:@"##"];
            
            needUploadNum = [needUploadDataArray count] - 1;
            
            if (needUploadNum > 0) {
                
                if (isUploading) {
                    // 正在上传，避免数据重复提交
                    return NO;
                }
                
                isUploading = YES;
                
                // 显示进度提示
                currentUploadNum = 0;
                errorUploadNum = 0;
                
                [self updateProgress];
                
                // 调用上传接口
                for (int i = 0; i<needUploadNum; i++) {
                    
                    [self sendHTTPGet:needUploadDataArray[i]];
                }
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"没有需要提交的数据."
                                            message:@""
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil
                  ] show];
            }
        }
        
        return NO;
    } else if([[[url scheme] lowercaseString] isEqualToString:@"admininitmethod"]) {
        
        // 初始化列表内容
        NSString *allDataStr = [NSString stringWithFormat:@"funtest('%@', '%@')", [[[FMDBConnection instance] getAvailableSurveyResult] stringByAddingPercentEscapes], ADMIN_CAN_EDIT_FLAG];
        [aWebView stringByEvaluatingJavaScriptFromString:allDataStr];
        
        return YES;
        
    } else if([[[url scheme] lowercaseString] isEqualToString:@"savecsv"]) {
        
        // 直接从Sqlite里面取数据
        NSString *parmString = [[FMDBConnection instance] getAvailableSurveyResult];
        NSArray *needUploadDataArray = [parmString componentsSeparatedByString:@"##"];
        
        needUploadNum = [needUploadDataArray count] - 1;
        
        if (needUploadNum > 0) {
            
            // 导出CSV
            [self makeCSV];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"没有需要导出的数据."
                                        message:@""
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
              ] show];
        }
        
        return NO;
        
    } else if([[[url scheme] lowercaseString] isEqualToString:@"optiondata"]) {
        
        NSString *delOptionStr = [[url resourceSpecifier] substringFromIndex:7];
        
        // 解析参数
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [delOptionStr componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // 删除记录
        [[FMDBConnection instance] updateSurveyStatus:[params objectForKey:@"q_id"] status:@"-1"];
        
        [[FMDBConnection instance] recoverySurveyStatus:[params objectForKey:@"projectcode"]
                                                   user:[params objectForKey:@"qpg"]
                                                  phone:[params objectForKey:@"qmobile"]];
        
        // 回调js
        NSString *allDataStr = [NSString stringWithFormat:@"funtest('%@', '%@')", [[[FMDBConnection instance] getAvailableSurveyResult] stringByAddingPercentEscapes], ADMIN_CAN_EDIT_FLAG];
        [aWebView stringByEvaluatingJavaScriptFromString:allDataStr];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)doPost:(id)sender
{
    
    [[[UIAlertView alloc] initWithTitle:@"提交数据..."
                                message:@""
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ] show];
}

- (void)showProgressView
{
    progressBGView.hidden = NO;
    progressLabel.hidden = NO;
    
    progressLabel.text = [NSString stringWithFormat:@"上传数据%ld条, 已上传成功%ld条, 上传失败%ld条.", (long)needUploadNum, (long)currentUploadNum, (long)errorUploadNum];
    
}

- (void)hideProgressView
{
    isUploading = NO;
    progressBGView.hidden = YES;
    progressLabel.hidden = YES;
    
}

- (void)updateProgress
{
    if (needUploadNum != currentUploadNum + errorUploadNum) {
        
        [self showProgressView];
        
    } else {
        
        [self hideProgressView];
        
        // 通知h5刷新
        // js方式刷新
        NSString *allDataStr = [NSString stringWithFormat:@"funtest('%@', '%@')", [[[FMDBConnection instance] getAvailableSurveyResult] stringByAddingPercentEscapes], ADMIN_CAN_EDIT_FLAG];
        [webView stringByEvaluatingJavaScriptFromString:allDataStr];
        // [webView reload]; 这种方式会产生闪屏
        
        // 提示
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:[NSString stringWithFormat:@"上传数据%ld条, 已上传成功%ld条, \n上传失败%ld条.", needUploadNum, currentUploadNum, errorUploadNum]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

- (void)sendHTTPGet:(NSString *)parmString
{
    
    NSString *requestedURL = [NSString stringWithFormat:@"%@%@", SUBMIT_URL_PATH, parmString];
    NSURL *myURL = [NSURL URLWithString:[requestedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //创建请求
    NSURLRequest *myRuquest = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //建立连接（异步的response在专门的代理协议中实现）
    [NSURLConnection connectionWithRequest:myRuquest delegate:self];
    
}

#pragma mark -
#pragma mark - URLConnectionDataDelegate 异步加载数据需要下面几个方法常用的有四个方法
//接受服务器响应－－接收到服务器回应的时候会执行该方法
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    DLog(@"服务器响应");
    
    self.myData = [NSMutableData dataWithCapacity:5000];
}

//接收服务器数据－－接收服务器传输数据的时候会调用，会根据数据量的大小，多次执行
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"服务器返回数据");
    
    //将返回数据放入缓存区
    [self.myData appendData:data];
}

//显示数据，直到所有的数据接收完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"数据接受完毕");
    NSString *backMsg = [[NSString alloc] initWithData:self.myData encoding:NSUTF8StringEncoding];
    DLog(@"backMsg=%@", backMsg);
    
    NSData *jsonData = [backMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSString *result = [dict objectForKey:@"message"];
    
    // 请求连接
    NSString * requestUrlStr = [[[connection currentRequest] URL] absoluteString];
    DLog(@"requestUrlStr: %@", requestUrlStr);
    NSString *parmString = [requestUrlStr componentsSeparatedByString:@"?"][1];
    
    // 解析参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    int resultVal = [result intValue];
    if (resultVal == 1) {
        
        [[FMDBConnection instance] updateSurveyStatus:[params objectForKey:@"q_id"] status:@"1"];
        
        currentUploadNum ++;
    } else if (resultVal == 7){
        
        [[FMDBConnection instance] updateSurveyStatus:[params objectForKey:@"q_id"] status:@"2"];
        
        errorUploadNum ++;
    } else {
        
        [[FMDBConnection instance] updateSurveyStatus:[params objectForKey:@"q_id"] status:@"0"];
        
        errorUploadNum ++;
    }
    
    [self updateProgress];
}

//接受失败的时候调用的方法（断网或者是连接超时）
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
//    [self hideProgressView];
    
    errorUploadNum ++;
    [self updateProgress];
    DLog(@"数据接受失败，失败原因：%@", [error localizedDescription]);
}

#pragma mark -
#pragma mark - mack csv file

- (void)makeCSV {
    
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *docementDir = [documents objectAtIndex:0];
    NSString *filePath = [docementDir stringByAppendingPathComponent:@"customer.csv"];
    DLog(@"filePath = %@", filePath);
    
    [self createFile:filePath];
    [self exportCSV:filePath];
}

- (void)createFile:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    
    
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        DLog(@"不能创建文件");
        
        [[[UIAlertView alloc] initWithTitle:@"不能创建文件"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

- (void)exportCSV:(NSString *)fileName {
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:fileName append:YES];
    [output open];
    
    if (![output hasSpaceAvailable]) {
        DLog(@"没有足够可用空间");
        
        [[[UIAlertView alloc] initWithTitle:@"没有足够可用空间"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    } else {
        
        [self exportDataCSV:output];
    }
}

#pragma mark - load resources
- (void)exportDataCSV:(NSOutputStream *)output
{
    
    // 项目部分
#if CarShowType == 10
    // DSFL
    [self exportDSFLDataCSV:output];
    
#elif CarShowType == 11
    // 品牌体验馆
    [self exportBrandDataCSV:output];
    
#elif CarShowType == 12
    // 梦工场
    [self exportMGCDataCSV:output];

#elif CarShowType == 13
    // CTCC
    [self exportCTCCDataCSV:output];

#endif
    
}

- (void)exportCTCCDataCSV:(NSOutputStream *)output
{
    NSString *header = @"ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,最喜欢的车款,何时(再)购车,购车预算,车展中最喜欢车型,是否需要购车服务,是否贷款购买福特,是否接收促销信息,isreceiving\n";
    
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSInteger result = [output write:headerString maxLength:headerLength];
    if (result <= 0) {
        NSLog(@"写入错误");
    }
    
    NSArray *dataArray = [[[FMDBConnection instance] getAvailableSurveyResult] componentsSeparatedByString:@"##"];
    NSInteger dataArrayCount = [dataArray count];
    
    for (int i = 0; i<dataArrayCount-1; i++) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [dataArray[i] componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,最喜欢的车款,何时(再)购车,购车预算,车展中最喜欢车型,是否需要购车服务,是否贷款购买福特,是否接收促销信息,isreceiving
        NSString *row = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@,  %@,%@,%@,%@,%@, %@\n",
                         [params objectForKey:@"q_id"],
                         PROJECT_CODE,
                         [params objectForKey:@"qname"],
                         [params objectForKey:@"qgender"],
                         [params objectForKey:@"qmobile"],
                         [params objectForKey:@"qemail"] == nil ? @"" : [params objectForKey:@"qemail"],
                         [params objectForKey:@"qdealerprovince"] == nil ? @"" : [params objectForKey:@"qdealerprovince"],
                         [params objectForKey:@"qdealercity"] == nil ? @"" : [params objectForKey:@"qdealercity"],
                         [params objectForKey:@"qdealer"] == nil ? @"" : [params objectForKey:@"qdealer"],
                         [params objectForKey:@"importdate"],
                         [params objectForKey:@"qeventname"],
                         [params objectForKey:@"qcity"],
                         [params objectForKey:@"qpg"],
                         [params objectForKey:@"q1"] == nil ? @"" : [params objectForKey:@"q1"],
                         [params objectForKey:@"q2"] == nil ? @"" : [params objectForKey:@"q2"],
                         [params objectForKey:@"q3"] == nil ? @"" : [params objectForKey:@"q3"],
                         [params objectForKey:@"q4"] == nil ? @"" : [params objectForKey:@"q4"],
                         [params objectForKey:@"q5"] == nil ? @"" : [params objectForKey:@"q5"],
                         [params objectForKey:@"q6"] == nil ? @"" : [params objectForKey:@"q6"],
                         [params objectForKey:@"q7"] == nil ? @"" : [params objectForKey:@"q7"],
                         [params objectForKey:@"q8"] == nil ? @"" : [params objectForKey:@"q8"],
                         [[params objectForKey:@"status"] isEqualToString:@"1"] ? @"是" : @"否"
                         ];
        
        NSString *transRow = [row stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        const uint8_t *rowString = (const uint8_t *)[transRow cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [transRow lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        result = [output write:rowString maxLength:rowLength];
        
        if (result <= 0) {
            NSLog(@"无法写入内容");
        }
    }
    
    [output close];
    
    if (dataArrayCount > 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"导出成功"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

- (void)exportDSFLDataCSV:(NSOutputStream *)output
{
    NSString *header = @"ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,最喜欢的车款,何时(再)购车,购车预算,车展中最喜欢车型,是否需要购车服务,是否贷款购买福特,是否接收促销信息,isreceiving\n";
    
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSInteger result = [output write:headerString maxLength:headerLength];
    if (result <= 0) {
        NSLog(@"写入错误");
    }
    
    NSArray *dataArray = [[[FMDBConnection instance] getAvailableSurveyResult] componentsSeparatedByString:@"##"];
    NSInteger dataArrayCount = [dataArray count];
    
    for (int i = 0; i<dataArrayCount-1; i++) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [dataArray[i] componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,最喜欢的车款,何时(再)购车,购车预算,车展中最喜欢车型,是否需要购车服务,是否贷款购买福特,是否接收促销信息,isreceiving
        NSString *row = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@,  %@,%@,%@,%@,%@, %@\n",
                         [params objectForKey:@"q_id"],
                         PROJECT_CODE,
                         [params objectForKey:@"qname"],
                         [params objectForKey:@"qgender"],
                         [params objectForKey:@"qmobile"],
                         [params objectForKey:@"qemail"] == nil ? @"" : [params objectForKey:@"qemail"],
                         [params objectForKey:@"qdealerprovince"] == nil ? @"" : [params objectForKey:@"qdealerprovince"],
                         [params objectForKey:@"qdealercity"] == nil ? @"" : [params objectForKey:@"qdealercity"],
                         [params objectForKey:@"qdealer"] == nil ? @"" : [params objectForKey:@"qdealer"],
                         [params objectForKey:@"importdate"],
                         [params objectForKey:@"qeventname"],
                         [params objectForKey:@"qcity"],
                         [params objectForKey:@"qpg"],
                         [params objectForKey:@"q1"] == nil ? @"" : [params objectForKey:@"q1"],
                         [params objectForKey:@"q2"] == nil ? @"" : [params objectForKey:@"q2"],
                         [params objectForKey:@"q3"] == nil ? @"" : [params objectForKey:@"q3"],
                         [params objectForKey:@"q4"] == nil ? @"" : [params objectForKey:@"q4"],
                         [params objectForKey:@"q5"] == nil ? @"" : [params objectForKey:@"q5"],
                         [params objectForKey:@"q6"] == nil ? @"" : [params objectForKey:@"q6"],
                         [params objectForKey:@"q7"] == nil ? @"" : [params objectForKey:@"q7"],
                         [params objectForKey:@"q8"] == nil ? @"" : [params objectForKey:@"q8"],
                         [[params objectForKey:@"status"] isEqualToString:@"1"] ? @"是" : @"否"
                         ];
        
        NSString *transRow = [row stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        const uint8_t *rowString = (const uint8_t *)[transRow cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [transRow lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        result = [output write:rowString maxLength:rowLength];
        
        if (result <= 0) {
            NSLog(@"无法写入内容");
        }
    }
    
    [output close];
    
    if (dataArrayCount > 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"导出成功"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

- (void)exportBrandDataCSV:(NSOutputStream *)output
{
    NSString *header = @"ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,何时(再)购车,购车预算,是否需要购车服务,isreceiving\n";
    
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSInteger result = [output write:headerString maxLength:headerLength];
    if (result <= 0) {
        DLog(@"写入错误");
    }
    
    NSArray *dataArray = [[[FMDBConnection instance] getAvailableSurveyResult]  componentsSeparatedByString:@"##"];
    NSInteger dataArrayCount = [dataArray count];
    
    for (NSInteger i = 0; i<dataArrayCount-1; i++) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [dataArray[i] componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // ID,项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,何时(再)购车,购车预算,是否需要购车服务,isreceiving
        NSString *row = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@\n",
                         [params objectForKey:@"q_id"],
                         PROJECT_CODE,
                         [params objectForKey:@"qname"],
                         [params objectForKey:@"qgender"],
                         [params objectForKey:@"qmobile"],
                         [params objectForKey:@"qemail"] == nil ? @"" : [params objectForKey:@"qemail"],
                         [params objectForKey:@"qdealerprovince"] == nil ? @"" : [params objectForKey:@"qdealerprovince"],
                         [params objectForKey:@"qdealercity"] == nil ? @"" : [params objectForKey:@"qdealercity"],
                         [params objectForKey:@"qdealer"] == nil ? @"" : [params objectForKey:@"qdealer"],
                         [params objectForKey:@"importdate"],
                         [params objectForKey:@"qeventname"],
                         [params objectForKey:@"qcity"],
                         [params objectForKey:@"qpg"],
                         [params objectForKey:@"q1"] == nil ? @"" : [params objectForKey:@"q1"],
                         [params objectForKey:@"q2"] == nil ? @"" : [params objectForKey:@"q2"],
                         [params objectForKey:@"q3"] == nil ? @"" : [params objectForKey:@"q3"],
                         [params objectForKey:@"q4"] == nil ? @"" : [params objectForKey:@"q4"],
                         [params objectForKey:@"q5"] == nil ? @"" : [params objectForKey:@"q5"],
                         [[params objectForKey:@"status"] isEqualToString:@"1"] ? @"是" : @"否"
                         ];
        
        NSString *transRow = [row stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        const uint8_t *rowString = (const uint8_t *)[transRow cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [transRow lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        result = [output write:rowString maxLength:rowLength];
        
        if (result <= 0) {
            DLog(@"无法写入内容");
        }
    }
    
    
    [output close];
    
    if (dataArrayCount > 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"导出成功"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

- (void)exportMGCDataCSV:(NSOutputStream *)output
{
    NSString *header = @"项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,何时(再)购车,购车预算,您的年龄？,您已经拥有座驾了吗？,您的座驾是？,影响您再购因素有哪些？,何种渠道了解本次活动？,您对此次梦工厂的评价？,1-10分对长安福特品牌的印象？,isreceiving\n";
    
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSInteger result = [output write:headerString maxLength:headerLength];
    if (result <= 0) {
        DLog(@"写入错误");
    }
    
    NSArray *dataArray = [[[FMDBConnection instance] getAvailableSurveyResult]  componentsSeparatedByString:@"##"];
    NSInteger dataArrayCount = [dataArray count];
    
    for (NSInteger i = 0; i<dataArrayCount-1; i++) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [dataArray[i] componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // 项目活动编码,姓名,性别,手机,EMAIL,经销商省份,经销商城市,经销商名称,提交时间,活动名称,活动城市,录入,最感兴趣车型,还感兴趣车型,何时(再)购车,购车预算,您的年龄？,您已经拥有座驾了吗？,您的座驾是？,影响您再购因素有哪些？,何种渠道了解本次活动？,您对此次梦工厂的评价？,1-10分对长安福特品牌的印象？,isreceiving
        
        NSString *row = [NSString stringWithFormat:@"%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@, %@,%@,%@,%@,%@\n",
                         PROJECT_CODE,
                         [params objectForKey:@"qname"],
                         [params objectForKey:@"qgender"],
                         [params objectForKey:@"qmobile"],
                         [params objectForKey:@"qemail"] == nil ? @"" : [params objectForKey:@"qemail"],
                         [params objectForKey:@"qdealerprovince"] == nil ? @"" : [params objectForKey:@"qdealerprovince"],
                         [params objectForKey:@"qdealercity"] == nil ? @"" : [params objectForKey:@"qdealercity"],
                         [params objectForKey:@"qdealer"] == nil ? @"" : [params objectForKey:@"qdealer"],
                         [params objectForKey:@"importdate"],
                         [params objectForKey:@"qeventname"],
                         [params objectForKey:@"qcity"],
                         [params objectForKey:@"qpg"],
                         [params objectForKey:@"q1"] == nil ? @"" : [params objectForKey:@"q1"],
                         [params objectForKey:@"q2"] == nil ? @"" : [params objectForKey:@"q2"],
                         [params objectForKey:@"q3"] == nil ? @"" : [params objectForKey:@"q3"],
                         [params objectForKey:@"q4"] == nil ? @"" : [params objectForKey:@"q4"],
                         [params objectForKey:@"q5"] == nil ? @"" : [params objectForKey:@"q5"],
                         [params objectForKey:@"q6"] == nil ? @"" : [params objectForKey:@"q6"],
                         [params objectForKey:@"q7"] == nil ? @"" : [params objectForKey:@"q7"],
                         [params objectForKey:@"q8"] == nil ? @"" : [params objectForKey:@"q8"],
                         [params objectForKey:@"q9"] == nil ? @"" : [params objectForKey:@"q9"],
                         [params objectForKey:@"q10"] == nil ? @"" : [params objectForKey:@"q10"],
                         [params objectForKey:@"q11"] == nil ? @"" : [params objectForKey:@"q11"],
                         [[params objectForKey:@"status"] isEqualToString:@"1"] ? @"是" : @"否"
                         ];
        
        NSString *transRow = [row stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        const uint8_t *rowString = (const uint8_t *)[transRow cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [transRow lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        result = [output write:rowString maxLength:rowLength];
        
        if (result <= 0) {
            DLog(@"无法写入内容");
        }
    }
    
    [output close];
    
    if (dataArrayCount > 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"导出成功"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
    }
}

@end
