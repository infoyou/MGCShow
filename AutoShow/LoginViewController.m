
#import "LoginViewController.h"
#import "SurveyViewController.h"
#import "AdminViewController.h"
#import "AppManager.h"

typedef enum {
    
    PICKER_TYPE_NAME,
    PICKER_TYPE_CITY,
    
} PICKER_TYPE;


@interface LoginViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>


@end

@implementation LoginViewController
{
    NSArray *activityNameArray;
    NSArray *cityNameArray;
}

@synthesize pickerBGView;

@synthesize activityPicker;
@synthesize cityPicker;

@synthesize activityTxt;
@synthesize nameTxt;
@synthesize pswdTxt;
@synthesize cityTxt;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[AppManager instance] loadUser]) {
        
        nameTxt.text = [AppManager instance].qpg;
        pswdTxt.text = [AppManager instance].userNickName;
        cityTxt.text = [AppManager instance].qcity;
        activityTxt.text = [AppManager instance].qeventname;
    } else {
        
        activityTxt.text = activityNameArray[0];
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadResource];
    
    pickerBGView.hidden = YES;
    activityPicker.hidden = YES;
    cityPicker.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDelegate method
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger dataNum = 0;
    if (pickerView == activityPicker) {
        dataNum = [activityNameArray count];
    } else if (pickerView == cityPicker) {
        dataNum = [cityNameArray count];
    }
    
    return dataNum;
}

// The data to return for the row and component (column) that's bei  ng passed in
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == activityPicker) {
        
        return activityNameArray[row];
        
    } else if (pickerView == cityPicker) {

        return cityNameArray[row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == activityPicker) {
        
        activityTxt.text = activityNameArray[row];
    } else if (pickerView == cityPicker) {
        
        cityTxt.text = cityNameArray[row];
    }
}

#pragma mark - UITextFieldDelegate method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ( textField == activityTxt ) {
        
        [self resetUI];
        
        pickerBGView.hidden = NO;
        activityPicker.hidden = NO;
//        [textField resignFirstResponder];
        
        return NO;
    }
    
    if ( textField == cityTxt ) {
        
        [self resetUI];
        
        pickerBGView.hidden = NO;
        cityPicker.hidden = NO;
//        [textField resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - load resources
- (void)loadResource
{
    
    // 项目部分
#if CarShowType == 10
    // DSFL
    [self loadDSFLResource];
    self.loginBG.image = [UIImage imageNamed:@"loginBgDSFL.png"];
    
#elif CarShowType == 11
    // 品牌体验馆
    [self loadBrandCarResource];
    self.loginBG.image = [UIImage imageNamed:@"loginBgMGC.png"];
    
#elif CarShowType == 12
    // 梦工场
    self.loginBG.image = [UIImage imageNamed:@"loginBgMGC.png"];
    [self loadMGCResource];
    
#elif CarShowType == 13
    // CTCC
    [self loadCTCCResource];
    self.loginBG.image = [UIImage imageNamed:@"loginBgCTCC.png"];
    
#endif

}

- (void) loadCTCCResource
{
    activityNameArray = @[@"2015长安福特CTCC赛车运动"];
    cityNameArray = @[@"上海",
                      @"肇庆",
                      @"韩国",
                      @"珠海",
                      @"盐城",
                      @"成都",
                      @"其他"];
}

- (void) loadDSFLResource
{
    activityNameArray = @[@"2015长安福特安全节能驾驶训练营"];
    cityNameArray = @[@"上海",
                      @"长沙",
                      @"武汉",
                      @"广州",
                      @"珠海",
                      @"重庆",
                      @"北京",
                      @"成都",
                      @"大连",
                      @"哈尔滨",
                      @"其他"];
}

- (void) loadBrandCarResource
{
    activityNameArray = @[@"2015品牌体验馆"];
    cityNameArray = @[@"长沙",
                      @"深圳",
                      @"广州",
                      @"重庆",
                      @"西安",
                      @"昆明",
                      @"成都",
                      @"武汉",
                      @"天津",
                      @"济南",
                      @"长春",
                      @"沈阳",
                      @"石家庄",
                      @"上海",
                      @"杭州",
                      @"宁波",
                      @"南京",
                      @"潍坊",
                      @"其他"];
}

- (void) loadMGCResource
{
    activityNameArray = @[@"2015长安福特汽车梦工场"];
    cityNameArray = @[@"菏泽",
                      @"安吉",
                      @"安康",
                      @"安宁",
                      @"安庆",
                      @"安顺",
                      @"安亭",
                      @"安溪",
                      @"安阳",
                      @"鞍山",
                      @"霸州",
                      @"百色",
                      @"北碚",
                      @"北海",
                      @"滨州",
                      @"苍南",
                      @"常熟",
                      @"成都",
                      @"承德",
                      @"池州",
                      @"滁州",
                      @"楚雄",
                      @"慈溪",
                      @"大丰",
                      @"大理",
                      @"大同",
                      @"丹阳",
                      @"德宏",
                      @"德清",
                      @"德州",
                      @"定西",
                      @"东莞",
                      @"东阳",
                      @"东营",
                      @"都江堰",
                      @"鄂尔多斯",
                      @"恩施",
                      @"奉贤",
                      @"佛山",
                      @"福清",
                      @"阜阳",
                      @"富阳",
                      @"赣州",
                      @"高安",
                      @"高密",
                      @"高邮",
                      @"巩义",
                      @"广安",
                      @"贵港",
                      @"桂林",
                      @"海安",
                      @"海口",
                      @"海门",
                      @"海宁",
                      @"海盐",
                      @"邯郸",
                      @"杭州临平",
                      @"杭州萧山",
                      @"毫州",
                      @"合川",
                      @"河池",
                      @"河源",
                      @"红河",
                      @"呼伦贝尔",
                      @"花都",
                      @"淮安",
                      @"淮北",
                      @"淮南",
                      @"黄冈",
                      @"黄山",
                      @"吉林",
                      @"即墨",
                      @"济源",
                      @"佳木斯",
                      @"嘉峪关",
                      @"江都",
                      @"江津",
                      @"江门新会",
                      @"江阴",
                      @"姜堰",
                      @"胶南",
                      @"胶州",
                      @"揭阳",
                      @"金坛",
                      @"锦州",
                      @"荆州",
                      @"景德镇",
                      @"靖江",
                      @"九江",
                      @"凯里",
                      @"柯桥",
                      @"昆山",
                      @"莱芜",
                      @"莱阳",
                      @"莱州",
                      @"廊坊",
                      @"乐清",
                      @"丽江",
                      @"丽水",
                      @"溧阳",
                      @"连云港",
                      @"聊城",
                      @"林州",
                      @"临汾",
                      @"临海",
                      @"柳州",
                      @"六安",
                      @"六盘水",
                      @"龙口",
                      @"泸州",
                      @"洛阳",
                      @"吕梁",
                      @"马鞍山",
                      @"茂名",
                      @"眉山",
                      @"梅州",
                      @"蒙城",
                      @"绵阳",
                      @"牡丹江",
                      @"南昌",
                      @"南海",
                      @"南宁",
                      @"南平",
                      @"南通",
                      @"宁波",
                      @"宁德",
                      @"平顶山",
                      @"平度",
                      @"平湖",
                      @"平凉",
                      @"莆田",
                      @"濮阳",
                      @"普洱",
                      @"齐齐哈尔",
                      @"迁安",
                      @"黔江",
                      @"钦州",
                      @"钦州",
                      @"青浦",
                      @"青州",
                      @"清远",
                      @"衢州",
                      @"曲靖",
                      @"任丘",
                      @"日照",
                      @"如皋",
                      @"三门峡",
                      @"三明",
                      @"厦门",
                      @"汕头",
                      @"商洛",
                      @"上海",
                      @"上虞",
                      @"韶关",
                      @"深圳",
                      @"嵊州",
                      @"十堰",
                      @"石嘴山",
                      @"寿光",
                      @"沭阳",
                      @"松江",
                      @"遂宁",
                      @"台州",
                      @"太仓",
                      @"太原",
                      @"泰安",
                      @"泰兴",
                      @"唐山",
                      @"滕州",
                      @"天水",
                      @"铁岭",
                      @"通辽",
                      @"桐乡",
                      @"万州",
                      @"威海",
                      @"渭南",
                      @"温岭",
                      @"芜湖",
                      @"梧州",
                      @"武安",
                      @"锡林浩特",
                      @"仙桃",
                      @"咸宁",
                      @"咸阳",
                      @"小榄",
                      @"新乡",
                      @"新余",
                      @"信阳",
                      @"邢台",
                      @"兴义",
                      @"宿迁",
                      @"宿州",
                      @"徐州",
                      @"雅安",
                      @"延安",
                      @"延吉",
                      @"扬中",
                      @"扬州",
                      @"阳江",
                      @"阳泉",
                      @"杨凌",
                      @"杨浦",
                      @"宜宾",
                      @"宜春",
                      @"宜兴",
                      @"义乌",
                      @"银川",
                      @"营口",
                      @"永州",
                      @"玉林",
                      @"玉溪",
                      @"岳阳",
                      @"云浮",
                      @"枣庄",
                      @"湛江",
                      @"张家口",
                      @"章丘",
                      @"漳州",
                      @"长兴",
                      @"长治",
                      @"昭通",
                      @"肇庆",
                      @"镇江",
                      @"郑州",
                      @"中山",
                      @"中卫",
                      @"重庆",
                      @"舟山",
                      @"周口",
                      @"珠海",
                      @"株洲",
                      @"诸暨",
                      @"驻马店",
                      @"涿州",
                      @"自贡",
                      @"邹城",
                      @"邹平",
                      @"遵义",
                      @"其他	"];
}

#pragma mark - check val
- (BOOL)checkVal
{
    if ([nameTxt.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"请输入用户名"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        [nameTxt becomeFirstResponder];
        return NO;
    }
    
    if ([pswdTxt.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"请输入密码"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        [pswdTxt becomeFirstResponder];
        return NO;
    }
    
    if ([cityTxt.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"请选择城市"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        [cityTxt becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - validate logic
- (BOOL)validateDSFL
{
    NSString *userName = [nameTxt.text lowercaseString];
    
    // 管理员
    if ([userName isEqualToString:@"admin"]) {
        
        if ([pswdTxt.text isEqualToString:@"000"]) {
            return YES;
        }
        
        return NO;
    }
    
    // 普通人员
    // F1 - F10
    if ([userName hasPrefix:@"f"]) {
        
        NSString *numberStr = [userName componentsSeparatedByString:@"f"][1];
        
        if(![self filterData:numberStr]) {
            return NO;
        }
        
        NSInteger number = [numberStr integerValue];
        
        if (number >=1 && number <= 10) {
            
            if ([pswdTxt.text isEqualToString:@"123456"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)validateBrandCar
{
    NSString *userName = [nameTxt.text lowercaseString];
    
    // 管理员
    if ([userName isEqualToString:@"admin"]) {
        
        if ([pswdTxt.text isEqualToString:@"000"]) {
            return YES;
        }
        
        return NO;
    }
    
    // 普通人员
    // M1 - M15, W1 - W15
    NSString *firstStr = [userName substringToIndex:1];
    NSInteger asciiCode = [firstStr characterAtIndex:0];
    
    if (asciiCode == 109 || asciiCode == 119) {
        
        NSString *numberStr = [userName componentsSeparatedByString:firstStr][1];
        
        if(![self filterData:numberStr]) {
            return NO;
        }
        NSInteger number = [numberStr integerValue];
        
        if (number >=1 && number <= 15) {
            
            if ([pswdTxt.text isEqualToString:@"123456"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)validateMGC
{
    NSString *userName = [nameTxt.text lowercaseString];
    
    // 管理员
    if ([userName isEqualToString:@"admin"]) {
        
        if ([pswdTxt.text isEqualToString:@"000"]) {
            return YES;
        }
        
        return NO;
    }
    
    // 普通人员
    // A1 - A10
    // .. - ..
    // K1 - K10
    NSString *firstStr = [userName substringToIndex:1];
    NSInteger asciiCode = [firstStr characterAtIndex:0];
    
    if (asciiCode >= 97 && asciiCode <= 116){
        NSString *numberStr = [userName componentsSeparatedByString:firstStr][1];
        
        if(![self filterData:numberStr]) {
            return NO;
        }
        NSInteger number = [numberStr integerValue];
        
        if (number >=1 && number <= 12) {
            
            if ([pswdTxt.text isEqualToString:@"123456"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)validateCTCC
{
    NSString *userName = [nameTxt.text lowercaseString];
    
    // 管理员
    if ([userName isEqualToString:@"admin"]) {
        
        if ([pswdTxt.text isEqualToString:@"000"]) {
            return YES;
        }
        
        return NO;
    }
    
    // 普通人员
    // cpg1 - cpg8
    if ([userName hasPrefix:@"cpg"]) {
        
        NSString *numberStr = [userName componentsSeparatedByString:@"cpg"][1];
        
        if(![self filterData:numberStr]) {
            return NO;
        }
        NSInteger number = [numberStr integerValue];
        
        if (number >=1 && number <= 10) {
            
            if ([pswdTxt.text isEqualToString:@"123456"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)filterData:(NSString *)numberStr
{
    if (numberStr.length > 2) {
        return NO;
    } else if (numberStr.length == 2) {
        if ([numberStr integerValue] < 10) {
            return NO;
        }
    } else if (numberStr.length == 1) {
        if ([numberStr integerValue] < 1) {
            return NO;
        }
    } else if (numberStr.length == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validate
{

    // 项目部分
#if CarShowType == 10
    // DSFL
    return [self validateDSFL];
    
#elif CarShowType == 11
    // 品牌体验馆
    return [self validateBrandCar];
    
#elif CarShowType == 12
    // 梦工场
    return [self validateMGC];
    
#elif CarShowType == 13
    // CTCC
    return [self validateCTCC];
    
#endif
    
    return NO;
}

#pragma mark - do Login
- (IBAction)doLogin:(id)sender
{
    
    if (![self checkVal]) {
        return;
    }
    
    if (![self validate]) {
        
        [[[UIAlertView alloc] initWithTitle:@"用户名密码错误，请重新输入"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        return;
    }
    
    [self resetUI];
    [self loginSuccess];
    
    [[AppManager instance] saveUserData:nameTxt.text
                                       userName:nameTxt.text
                                       nickName:pswdTxt.text
                                         city:cityTxt.text
                                          activity:activityTxt.text];
    
    if (![[nameTxt.text lowercaseString] isEqualToString:@"admin"]) {

        // 调研问卷
        SurveyViewController *surveyVC = [[SurveyViewController alloc] init];
        //    UINavigationController *surveyNav = [[UINavigationController alloc] initWithRootViewController:surveyVC];
        
        [self.navigationController presentViewController:surveyVC animated:YES completion:^{}];
    } else {
        // 后台
        AdminViewController *adminVC = [[AdminViewController alloc] init];
        //    UINavigationController *surveyNav = [[UINavigationController alloc] initWithRootViewController:surveyVC];
        
        [self.navigationController presentViewController:adminVC animated:YES completion:^{}];
    }
    
}

#pragma mark - save data
- (void)loginSuccess
{
    [AppManager instance].status = @"0";
    [AppManager instance].qpg = nameTxt.text;
    [AppManager instance].qcity = cityTxt.text;
    [AppManager instance].qeventname = activityTxt.text;
}

#pragma mark - reset
- (IBAction)doReset:(id)sender
{
    cityTxt.text = @"";
    
    nameTxt.text = @"";
    pswdTxt.text = @"";
    
    [[AppManager instance] saveUserData:@""
                               userName:@""
                               nickName:@""
                                 city:@""
                                  activity:activityTxt.text];
}

#pragma mark - check val
- (void)resetUI
{
    pickerBGView.hidden = YES;
    activityPicker.hidden = YES;
    cityPicker.hidden = YES;
    
    [nameTxt resignFirstResponder];
    [pswdTxt resignFirstResponder];
}

@end
