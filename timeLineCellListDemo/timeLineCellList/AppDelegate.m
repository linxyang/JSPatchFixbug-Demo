//
//  AppDelegate.m
//  timeLineCellList
//
//  Created by Yanglixia on 16/9/17.
//  Copyright © 2016年 yanglinxia. All rights reserved.
//

#import "AppDelegate.h"
#import "MyBeautyPlanDailyViewController.h"
#import <JSPatch/JPEngine.h>
#import "NSData+Des.h"
#import "NSString+Des.h"

///密钥
NSString * const JSPatchEncryptKey = @"2871714D2B554D6B";
///向量
NSString * const JSPatchEncryptIV  = @"484A374B5B674E48";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 启动修复引擎
    [self runPatch];//运行补丁
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MyBeautyPlanDailyViewController *controller = [[MyBeautyPlanDailyViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 运行补丁
/// 补丁
- (void)runPatch
{
#pragma mark 这里测试js写的是否正确
//    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"release.1.1.40" ofType:@"js"];
//    NSString *js = [[NSString alloc] initWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
//    if(js)
//    {
//        [JPEngine startEngine];
//        [JPEngine evaluateScript:js];
//    }
//    return;
    
#pragma mark 这里对写好且正确的js文件加密，然后给后台
    //------- js加密---加密后给运营的
    NSString *toEncptyPath = @"/Users/fuchun/Desktop/release.1.1.40.js";
    NSData *toEncptyData = [NSData dataWithContentsOfFile:toEncptyPath];
    NSData *encptyData = [toEncptyData encryptWithKey:[JSPatchEncryptKey stringOfHexString] iv:[JSPatchEncryptIV stringOfHexString]];
    // 写到桌面，到时候给运营上传到后台管理系统
    [encptyData writeToFile:@"/Users/fuchun/Desktop/release.toService.data" atomically:YES];
    //------ js加密结束-----
#pragma mark 这里是本地测试加密后测试能否修复，以保证给后台的到时候有效
    //------ 测试加密是否有用--begin--
    NSString *jsFilePath = @"/Users/fuchun/Desktop/release.toService.data";
    NSData * deEncptyData = [NSData dataWithContentsOfFile:jsFilePath];
    if(deEncptyData)
    {
        deEncptyData = [deEncptyData decryptWithKey:[JSPatchEncryptKey stringOfHexString]  iv:[JSPatchEncryptIV stringOfHexString]];
        NSString *js = [[NSString alloc] initWithData:deEncptyData encoding:NSUTF8StringEncoding];
        if(js)
        {
            [JPEngine startEngine];
            [JPEngine evaluateScript:js];
        }
        
    }
    return;
    //------ 测试加密是否有用---end--
#pragma 这里才是真正的修复
    NSString *config = @"";
#if DEBUG
    config = @"debug";
#else
    config = @"release";
#endif
    
    NSInteger v = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] integerValue];//bundle内部版本号
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//发布版本号,3位如:1.1.0
    NSString *fileName = [NSString stringWithFormat:@"patch.%@.%ld.luac",version,(long)v];
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filepath = [docuPath stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.gmall.com/myapp/%@/%@",config,fileName]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:3];
    NSError *error;
    NSHTTPURLResponse *response;

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(!error && response.statusCode == 200)
    {
        [data writeToFile:filepath atomically:YES];
    }
    else
    {
        data = [NSData dataWithContentsOfFile:filepath];
    }
    
    if(data)
    {
        data = [data decryptWithKey:[JSPatchEncryptKey stringOfHexString]  iv:[JSPatchEncryptIV stringOfHexString]];
        if(!error)
        {
            NSString *js = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if(js)
            {
                [JPEngine startEngine];
                [JPEngine evaluateScript:js];
            }
        }
    }
}


@end
