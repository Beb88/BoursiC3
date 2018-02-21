//
//  AppDelegate.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Valeurs.h"
//2018
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property ( nonatomic,retain) NSMutableArray *ValeursArray;
@property (nonatomic, retain) NSString *ZETOKEN;

@end
