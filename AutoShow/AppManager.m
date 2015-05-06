
#import "AppManager.h"

@implementation AppManager {
}

// new message number
@synthesize msgNumber;

// User
@synthesize userId;
@synthesize userPswd;
@synthesize userNickName;
@synthesize userEmail;

@synthesize userMobile;
@synthesize userDefaultAddress;
@synthesize userProvince;

@synthesize status;
@synthesize qpg;
@synthesize qeventname;
@synthesize qcity;

// Product
@synthesize productKeyWord;

@synthesize profileCellNumberDict;

static AppManager *shareInstance = nil;

+ (AppManager *)instance {
    
    @synchronized(self) {
        
        if (nil == shareInstance) {
            shareInstance = [[self alloc] init];
        }
    }
    
    return shareInstance;
}


- (BOOL)loadUser
{
    
    NSString *userIdStr = [self userIdRemembered];
    if (userIdStr != nil && userIdStr.length > 0) {
        
        [AppManager instance].userId = userIdStr;
        [AppManager instance].qpg = [self qpgRemembered];
        [AppManager instance].userNickName = [self nickNameRemembered];
        [AppManager instance].qcity = [self cityRemembered];
        [AppManager instance].qeventname = [self activityRemembered];
        
        return YES;
    } else {
        
        [AppManager instance].userId = @"";
        [AppManager instance].qpg = @"";
        [AppManager instance].userNickName = @"";
        [AppManager instance].qcity = @"";
        [AppManager instance].qeventname = @"";
        
        return NO;
    }
}

- (NSString *) userIdRemembered {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (NSString *) qpgRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"qpg"];
}

- (NSString *) nickNameRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
}

- (NSString *) cityRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
}

- (NSString *) activityRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"activity"];
}

- (void)saveUserData:(NSString *)aUserId
                userName:(NSString *)aUserName
                nickName:(NSString *)aNickName
                city:(NSString *)city
            activity:(NSString *)activity
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if(userId == nil) {
        
        [_def removeObjectForKey:@"userId"];
        [_def removeObjectForKey:@"qpg"];
        [_def removeObjectForKey:@"nickName"];
        [_def removeObjectForKey:@"city"];
        [_def removeObjectForKey:@"activity"];
    } else {
        
        [_def setObject:aUserId forKey:@"userId"];
        [_def setObject:aUserName forKey:@"qpg"];
        [_def setObject:aNickName forKey:@"nickName"];
        [_def setObject:city forKey:@"city"];
        [_def setObject:activity forKey:@"activity"];
    }
    
    [_def synchronize];
}

- (void)saveQuestionData:(NSString *)resultId resultMsg:(NSString *)resultMsg
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:resultMsg forKey:resultId];
    [_def synchronize];
}

- (void)saveQuestionDataIndex:(NSString *)result
{
    
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if ([self getResultIds].length > 0) {
        NSString *resultMsg = [NSString stringWithFormat:@"%@#%@", [self getResultIds], result];
        [_def setObject:resultMsg forKey:@"resultId"];
    } else {
        [_def setObject:result forKey:@"resultId"];
    }
    
    [_def synchronize];
}

- (NSString *)getResultIds
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"resultId"];
}

@end
