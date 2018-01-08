//
//  SipTestAppDelegate.m
//  SipTest
//
//  Created by Zhe Cui on 1/7/18.
//  Copyright © 2018 Zhe Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pjsua-lib/pjsua.h>

#include "pjsua_app.h"

#import "SipTestAppDelegate.h"

static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata);
static void on_call_state(pjsua_call_id call_id, pjsip_event *e);
static void on_call_media_state(pjsua_call_id call_id);
static void on_reg_state(pjsua_acc_id acc_id);


@interface SipTestAppDelegate ()

@end

@implementation SipTestAppDelegate

SipTestAppDelegate      *app;
static pjsua_app_cfg_t  app_cfg;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__handleIncommingCall:)
                                                 name:@"SIPIncomingCallNotification"
                                               object:nil];
    
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //        self.viewController = [[LoginViewController alloc] initWithNibName:@"ipjsuaViewController_iPhone" bundle:nil];
    //    } else {
    //        self.viewController = [[LoginViewController alloc] initWithNibName:@"ipjsuaViewController_iPad" bundle:nil];
    //    }
    //    self.window.rootViewController = self.viewController;
    //    [self.window makeKeyAndVisible];
    
    app = self;
    
    /* Start pjsua app thread */
    [NSThread detachNewThreadSelector:@selector(pjsuaStart) toTarget:self withObject:nil];
    
//    pj_status_t status;
//
//    // 创建SUA
//    status = pjsua_create();
//
//    if (status != PJ_SUCCESS) {
//        NSLog(@"error create pjsua"); return NO;
//    }
//
//    {
//        // SUA 相关配置
//        pjsua_config cfg;
//        pjsua_media_config media_cfg;
//        pjsua_logging_config log_cfg;
//
//        pjsua_config_default(&cfg);
//
//
//        // 回调函数配置
//        cfg.cb.on_incoming_call = &on_incoming_call;            // 来电回调
//        cfg.cb.on_call_media_state = &on_call_media_state;      // 媒体状态回调（通话建立后，要播放RTP流）
//        cfg.cb.on_call_state = &on_call_state;                  // 电话状态回调
//        cfg.cb.on_reg_state = &on_reg_state;                    // 注册状态回调
//
//        // 媒体相关配置
//        pjsua_media_config_default(&media_cfg);
//        media_cfg.clock_rate = 16000;
//        media_cfg.snd_clock_rate = 16000;
//        media_cfg.ec_tail_len = 0;
//
//        // 日志相关配置
//        pjsua_logging_config_default(&log_cfg);
//#ifdef DEBUG
//        log_cfg.msg_logging = PJ_TRUE;
//        log_cfg.console_level = 4;
//        log_cfg.level = 5;
//#else
//        log_cfg.msg_logging = PJ_FALSE;
//        log_cfg.console_level = 0;
//        log_cfg.level = 0;
//#endif
//
//        // Pete, added for test
//        //cfg.use_tls = PJ_TRUE;
//        cfg.outbound_proxy_cnt = 1;
//        cfg.outbound_proxy[0] = pj_str("sips:siptest.butterflymx.com:5061");
//        //cfg.port = 5061;
//
//
//        // 初始化PJSUA
//        status = pjsua_init(&cfg, &log_cfg, &media_cfg);
//        if (status != PJ_SUCCESS) {
//            NSLog(@"error init pjsua"); return NO;
//        }
//    }
//
//    // udp transport
//    {
//        pjsua_transport_config cfg;
//        pjsua_transport_config_default(&cfg);
//
//        // 传输类型配置
//        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
//        if (status != PJ_SUCCESS) {
//            NSLog(@"error add transport for pjsua"); return NO;
//        }
//
//        // Pete
//        cfg.port = 5061;
//        status = pjsua_transport_create(PJSIP_TRANSPORT_TLS, &cfg, nil);
//
//        if (status != PJ_SUCCESS) {
//            NSLog(@"error add TLS transport for pjsua");
//            return NO;
//        }
//
//    }
//
//    // 启动PJSUA
//    status = pjsua_start();
//    if (status != PJ_SUCCESS) {
//        NSLog(@"error start pjsua"); return NO;
//    }
//
    return YES;
}

/* Add account */
static pj_status_t cmd_add_account()
{
    pjsua_acc_config acc_cfg;
    pj_status_t status;
    
    pjsua_acc_config_default(&acc_cfg);
    acc_cfg.id = pj_str("sip:6728@siptest.butterflymx.com");
    acc_cfg.reg_uri = pj_str("sips:siptest.butterflymx.com");
    acc_cfg.cred_count = 1;
    acc_cfg.cred_info[0].scheme = pj_str("Digest");
    acc_cfg.cred_info[0].realm = pj_str("siptest.butterflymx.com");
    acc_cfg.cred_info[0].username = pj_str("6728");
    acc_cfg.cred_info[0].data_type = 0;
    acc_cfg.cred_info[0].data = pj_str("123456");
    
    acc_cfg.rtp_cfg = app_config.rtp_cfg;
    app_config_init_video(&acc_cfg);
    
    status = pjsua_acc_add(&acc_cfg, PJ_TRUE, NULL);
    if (status != PJ_SUCCESS) {
        //pjsua_perror(THIS_FILE, "Error adding new account", status);
        printf("!!!!!Error adding new account!");
    }
    
    return status;
}

- (void)pjsuaStart
{
    pj_status_t status;
    
    status = pjsua_app_init(&app_cfg);
    if (status != PJ_SUCCESS) {
        char errmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, errmsg, sizeof(errmsg));
        //pjsua_app_destroy();
        return;
    }
    
    status = pjsua_app_run(PJ_TRUE);
    if (status != PJ_SUCCESS) {
        char errmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, errmsg, sizeof(errmsg));
    }
    
    cmd_add_account();
    //pjsua_app_destroy();
}

- (void)__handleIncommingCall:(NSNotification *)notification {
    pjsua_call_id callId = [notification.userInfo[@"call_id"] intValue];
//    NSString *phoneNumber = notification.userInfo[@"remote_address"];
    
    pjsua_call_answer(callId, 200, nil, nil);
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    IncomingCallViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
    
//    viewController.phoneNumber = phoneNumber;
//    viewController.callId = callId;
    
//    UIViewController *rootViewController = self.window.rootViewController;
//    [rootViewController presentViewController:viewController animated:YES completion:nil];
}

void displayWindow(pjsua_vid_win_id wid)
{
//#if PJSUA_HAS_VIDEO
    int i, last;
    
    i = (wid == PJSUA_INVALID_ID) ? 0 : wid;
    last = (wid == PJSUA_INVALID_ID) ? PJSUA_MAX_VID_WINS : wid+1;
    
    for (;i < last; ++i) {
        pjsua_vid_win_info wi;
        
        if (pjsua_vid_win_get_info(i, &wi) == PJ_SUCCESS) {
            //UIView *parent = app.viewController.view;
            
            UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            while (topVC.presentedViewController) {
                topVC = topVC.presentedViewController;
            }
            
            UIView *view = (__bridge UIView *)wi.hwnd.info.ios.window;
            
            if (view) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* Add the video window as subview */
                    if (![view isDescendantOfView:topVC.view])
                        [topVC.view addSubview:view];
                    
                    if (!wi.is_native) {
                        /* Resize it to fit width */
                        view.bounds = CGRectMake(0, 0, topVC.view.bounds.size.width,
                                                 (topVC.view.bounds.size.height *
                                                  1.0*topVC.view.bounds.size.width/
                                                  view.bounds.size.width));
                        /* Center it horizontally */
                        view.center = CGPointMake(topVC.view.bounds.size.width/2.0,
                                                  view.bounds.size.height/2.0);
                    } else {
                        /* Preview window, move it to the bottom */
                        view.center = CGPointMake(topVC.view.bounds.size.width/2.0,
                                                  topVC.view.bounds.size.height-
                                                  view.bounds.size.height/2.0);
                    }
                });
            }
        }
    }
    
    
//#endif
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


@end
