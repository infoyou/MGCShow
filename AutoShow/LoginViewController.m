
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
    cityNameArray = @[@"广州",
                      @"无锡",
                      @"济南",
                      @"哈尔滨",
                      @"武汉",
                      @"成都",
                      @"上海",
                      @"肇庆",
                      @"珠海",
                      @"盐城",
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
    cityNameArray = @[@"昆山",
                      @"安康",
                      @"安宁",
                      @"安顺",
                      @"安溪",
                      @"安阳",
                      @"巴中",
                      @"白银",
                      @"百色",
                      @"宝鸡",
                      @"北海",
                      @"毕节",
                      @"昌吉",
                      @"常德",
                      @"郴州",
                      @"成都",
                      @"楚雄",
                      @"达州",
                      @"大渡口",
                      @"大理",
                      @"德宏州",
                      @"德阳",
                      @"登封市",
                      @"定西",
                      @"东莞",
                      @"都江堰",
                      @"恩施",
                      @"防城港",
                      @"佛山",
                      @"涪陵区",
                      @"福清",
                      @"福州",
                      @"抚州",
                      @"赣州",
                      @"巩义市",
                      @"广安",
                      @"广元",
                      @"广州番禺",
                      @"广州芳村",
                      @"广州花都",
                      @"桂林",
                      @"哈密",
                      @"海口",
                      @"汉中",
                      @"合川区",
                      @"河池",
                      @"河源",
                      @"鹤壁",
                      @"衡阳",
                      @"红河州",
                      @"怀化",
                      @"黄石",
                      @"惠州",
                      @"吉安",
                      @"济源",
                      @"嘉峪关",
                      @"江津区",
                      @"江门",
                      @"焦作",
                      @"揭阳",
                      @"荆门",
                      @"荆州",
                      @"景德镇",
                      @"九江",
                      @"开封",
                      @"凯里",
                      @"克拉玛依",
                      @"库尔勒",
                      @"兰州",
                      @"乐山",
                      @"丽江",
                      @"凉山",
                      @"林州",
                      @"浏阳",
                      @"柳州",
                      @"六盘水",
                      @"龙岩",
                      @"泸州",
                      @"洛阳",
                      @"漯河",
                      @"茂名",
                      @"眉山",
                      @"梅州",
                      @"绵阳",
                      @"南昌",
                      @"南充",
                      @"南宁",
                      @"南平",
                      @"南阳",
                      @"内江",
                      @"宁德",
                      @"宁乡",
                      @"攀枝花",
                      @"彭州",
                      @"平顶山",
                      @"平凉",
                      @"莆田",
                      @"濮阳",
                      @"普洱市",
                      @"黔江区",
                      @"钦州",
                      @"清远",
                      @"庆阳",
                      @"曲靖",
                      @"泉州",
                      @"三门峡",
                      @"三明",
                      @"厦门",
                      @"汕头",
                      @"商洛",
                      @"商丘",
                      @"上饶",
                      @"韶关",
                      @"深圳",
                      @"石嘴山",
                      @"遂宁",
                      @"天水",
                      @"铜仁",
                      @"万州区",
                      @"渭南",
                      @"文山",
                      @"乌鲁木齐",
                      @"梧州",
                      @"武汉",
                      @"西安",
                      @"西宁",
                      @"咸宁",
                      @"咸阳",
                      @"湘潭",
                      @"湘西",
                      @"襄阳",
                      @"孝感",
                      @"新密市",
                      @"新乡",
                      @"新余",
                      @"新郑市",
                      @"信阳",
                      @"兴义",
                      @"许昌",
                      @"雅安",
                      @"延安",
                      @"阳江",
                      @"杨凌",
                      @"伊宁",
                      @"宜宾",
                      @"宜昌",
                      @"宜春",
                      @"益阳",
                      @"银川",
                      @"荥阳市",
                      @"永城",
                      @"永川区",
                      @"永州",
                      @"榆林",
                      @"玉林",
                      @"玉溪",
                      @"岳阳",
                      @"云浮",
                      @"湛江",
                      @"张掖",
                      @"漳州",
                      @"昭通",
                      @"肇庆",
                      @"郑州市区",
                      @"中牟市",
                      @"中山",
                      @"中卫",
                      @"周口",
                      @"珠海",
                      @"株洲",
                      @"驻马店",
                      @"资阳",
                      @"自贡",
                      @"遵义",
                      @"其他"];
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
