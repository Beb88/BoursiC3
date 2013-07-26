//
//  AppDelegate.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
@implementation AppDelegate

@synthesize window = _window,ValeursArray,ZETOKEN;

static NSString *URLServeurString = @"http://s454555776.onlinehome.fr/boursicoincoin/Send_id.php";

/*
- (NSString *) getDBPath {
	
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"BCC.sqlite"];
}
*/
+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

/*
- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
    
    //PERMET DE MANIPULER DES FICHIERS
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
    
    
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		//RECUPERE LE CHEMIN DE LA BASE QUI EST AVEC LES FICHIERS SOURCES
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BCC.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    /*ValeursArray = [NSMutableArray new ];
    
    //JE VERIFIE SI LA DB EST COPIE OU PAS DS L'APPLICATION
    [self copyDatabaseIfNeeded];
    
    Valeurs  *uneValeur = [Valeurs new];
    
    
    //JE CHARGE LE CONTENU DE LA DB DANS L OBJET Valeurs
    [Valeurs getInitialDataToDisplay:[self getDBPath]];
    
    NSLog(@" Base Locale sqlite BCC  RAMENE %i Valeurs", ValeursArray.count);
*/
    
    //CUSTO NAVIGATIONBAR
    //UIImage *navBarImage = [UIImage imageNamed:@"nav-bar.png"];
      //[[UINavigationBar appearance] setBackgroundImage:navBarImage
        //                               forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
                                     
    //CUSTO BOUTON NAVIGATIONBAR
   // UIImage *barButton = [[UIImage imageNamed:@"bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    //[[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
      //                                    barMetrics:UIBarMetricsDefault];
    
    //UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,6)];
    
    
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
      //                                              barMetrics:UIBarMetricsDefault];
    
    
    
    // Pour definir que l'appli veut recevoir des push notifications
    NSLog(@"DEMANDE D'autorisation pour notification");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSLog(@"DEMANDE faite D'autorisation pour notification");
    
    // self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
    
	// Let the device know we want to receive push notifications
	    
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    ZETOKEN = [NSString stringWithFormat:@"%@",deviceToken];;
    //formatage ( suppression espace et <>)
    ZETOKEN = [[ZETOKEN description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    ZETOKEN = [ZETOKEN stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"My token is: %@", ZETOKEN);
    
    //Mise en objet NSUSERDEFAULT du token
     [[NSUserDefaults standardUserDefaults] setObject:ZETOKEN forKey:@"deviceToken"];
   
       
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}



//FONCTION
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /*
     //POUR VOIR LE CONTENU D UN NSDictionnary
     NSEnumerator *enumerator = [ listValDict keyEnumerator];
     NSString *key;
     while (key = [ enumerator nextObject]) {
     printf("%s\n", [[ listValDict objectForKey:key] UTF8String]);
     }
     //FIN //VISU CONTENU D UN DICTIONNAIRE
     */
    
    
    
    /*Suppression d'une valeur ds le BCC.plist*/
    
    
    
   /*  NSString *pathToPlist = @"/Users/H2CO3/my.plist";
     NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithCOntentsOfFile:pathToPlist];
     [plist removeObjectForKey:@"MyKeyIWannaDelete"];
     [plist writeToFile:pathToPlist atomically:YES];
     
     */
    
   // [dico setObject:dateSettings forKey:@"date"];
    
    
    for (id key in userInfo) {
        NSLog(@"RECEPTION D UNE PUSH NOTIFICATION composee de la key: %@, avec value: %@", key, [userInfo objectForKey:key]);
       
        
        
        /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"COIN"
                                                            message:[userInfo objectForKey:key]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        */
        
        
        
        
    }
    
   

    

}

@end
