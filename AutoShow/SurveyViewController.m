
#import "SurveyViewController.h"
#import "AppManager.h"
#import "SurveyObject.h"
#import "FMDBConnection.h"

@interface SurveyViewController () <UIWebViewDelegate>

@end

@implementation SurveyViewController
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:SURVEY_HTML_NAME ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObjc = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObjc];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    webView.backgroundColor = [UIColor blackColor];
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    //处理JavaScript和Objective-C交互
    
    if([[[url scheme] lowercaseString] isEqualToString:@"uploadmethod"]) {
        // 得到html5的问卷结果
        if([[url host] isEqualToString:@"data"])
        {
            NSString *showString = [[url resourceSpecifier] substringFromIndex:7];
            NSString *str = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *parmString = [NSString stringWithFormat:@"%@&qpg=%@&qeventname=%@&qcity=%@&projectcode=%@", str, [AppManager instance].qpg, [AppManager instance].qeventname, [AppManager instance].qcity, PROJECT_CODE];
           
            [self sendHTTPGet:parmString];
        }
        
        return NO;
    } else if([[[url scheme] lowercaseString] isEqualToString:@"showalert"]) {
        // 处理js的alert
        if([[url host] isEqualToString:@"data"])
        {
            
            NSString *showString = [[url resourceSpecifier] substringFromIndex:13];
            
            NSString *str = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[[UIAlertView alloc] initWithTitle:str
                                        message:@""
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
              ] show];
            
        }
        
        return NO;
    }

    
    return YES;
}

#pragma mark - do action

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

- (IBAction)doPost:(id)sender
{
    
    [webView stringByEvaluatingJavaScriptFromString:@"submitAnswer()"];
}

- (void) sendHTTPGet:(NSString *)parmString
{
    
    NSString *requestedURL = [NSString stringWithFormat:@"%@%@", SUBMIT_URL_PATH, parmString];
    NSURL *url = [NSURL URLWithString:[requestedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"newStr = %@", newStr);
    
    NSData *jsonData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];

    
    NSString *result = [dict objectForKey:@"message"];
    
    // save result
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *dataId = [NSString stringWithFormat:@"%.0f", a];
    
    // 解析参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    int resultVal = [result intValue];
    if (resultVal == 1) {
        
        // 存数据库
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        surveyObject.surveyId = dataId;
        surveyObject.projectcode = PROJECT_CODE;
        surveyObject.phone = [params objectForKey:@"qmobile"];
        surveyObject.user = [params objectForKey:@"qpg"];
        surveyObject.city = [params objectForKey:@"qcity"];
        surveyObject.remark = parmString;
        surveyObject.status = @(1);
        [[FMDBConnection instance] insertSurveyObjectDB:surveyObject];
        
        // 提示
        [[[UIAlertView alloc] initWithTitle:@"数据提交成功."
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        // 判断是否有重复
        [[FMDBConnection instance] updateRepeatSurveyObjectDB:surveyObject];
    } else {
        
        // 存数据库
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        surveyObject.surveyId = dataId;
        surveyObject.projectcode = PROJECT_CODE;
        surveyObject.phone = [params objectForKey:@"qmobile"];
        surveyObject.user = [params objectForKey:@"qpg"];
        surveyObject.city = [params objectForKey:@"qcity"];
        surveyObject.remark = parmString;
        surveyObject.status = @(0);
        [[FMDBConnection instance] insertSurveyObjectDB:surveyObject];
        
        // 提示
        NSString *promptStr = @"";
        if (result != nil && result.length > 0) {
            if ([result isEqualToString:@"7"]) {
                promptStr = @"活动的录入和手机号已存在，请勿重复录入！";
            }
        }

        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@\n数据保存本地.", promptStr]
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        // 判断是否有重复
//        [[FMDBConnection instance] updateRepeatSurveyObjectDB:surveyObject];
    }
    
}

#pragma mark
#pragma mark - Fixed bug:UIPopoverPresentationController (<UIPopoverPresentationController: 0x14eeec960>) should have a non-nil sourceView or barButtonItem set before the presentation occurs

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_USEC), dispatch_get_main_queue(),
                   ^{
                       [super presentViewController:viewControllerToPresent animated:flag completion:completion];
                   });
}


@end
