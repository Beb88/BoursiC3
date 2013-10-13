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
    
    /*Suppression d'une valeur ds le BCC.plist*/
    
    //[data se]
    //  NSString *pathToPlist = @"/Users/H2CO3/my.plist";
    //  NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithCOntentsOfFile:pathToPlist];
    //  [data removeObjectForKey:@"MyKeyIWannaDelete"];
    //  [data writeToFile:pathToPlist atomically:YES];
    
    
    
    
    // [dict setObject:dateSettings forKey:@"date"];
    /*  NSDictionary *dict_TEST = [[NSDictionary alloc] initWithContentsOfFile:path];
     
     //POUR VOIR LE CONTENU D UN NSDictionnary
     NSEnumerator *enumerator = [ dict_TEST keyEnumerator];
     NSString *key;
     while (key = [ enumerator nextObject]) {
     printf("DICO TEST : %s\n", [[ dict_TEST objectForKey:key] UTF8String]);
     }
     //FIN //VISU CONTENU D UN DICTIONNAIRE
     */
    
    /* for (Valeurs *Val in listVal) {
     //NSLog(@"  %@",  )
     
     }
     */

    //ON RECOIT L ID
    
    
    
    for (id key in userInfo) {
        NSLog(@"RECEPTION D UNE PUSH NOTIFICATION composee de la key: %@, avec value: %@", key, [userInfo objectForKey:key]);
        
        //RECEPTION D UNE PUSH NOTIFICATION composee de la key: idAlert, avec value: 285
        
        
        //RECEPTION D UNE PUSH NOTIFICATION composee de la key: aps, avec value: {alert = "Boursicoincoin vous informe que le 8/12/2013  00311:35amla valeur UBI.PA a franchi le cours 5  006ca hausse.";
      //  sound = default;
        
        
        
    }
        
    // EXEMPLE DE GESTION SI L APP EST ACTIVE OU PAS

    /*
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        
     UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"xxx" message:yourMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles: @"Anzeigen", nil] autorelease];
     [alert setTag: 2];
     [alert show];
    }
}
else
{
    // just ignore it…
}
     
     */
      NSString *message = nil; 
    id APS = [userInfo objectForKey:@"aps"];
    if ([APS isKindOfClass:[NSString class]]) {
        message = APS;
    } else if ([APS isKindOfClass:[NSDictionary class]]) {
        message = [APS objectForKey:@"alert"];
    }
    if (APS) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NOTIF RECUE"
                                                            message:message delegate:self
                                                  cancelButtonTitle:@"CANCEL"
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
    }
    
   
    id alert = [userInfo objectForKey:@"idAlert"];
    if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"alert"];
    }
    if (alert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ALERTE"
                                                            message:message delegate:self
                                                  cancelButtonTitle:@"CANCEL"
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
    }


    
    
    // ATTENTION : INSCRIT LE JOURNAL(msg pushé du serveur ) ET l'id de l'alerte déclenchée dans le
    //NSUserDefaults
    
    //ON SAUVEGARDE LE DERNIER MESSAGE DONC L ID ALERT
     [[NSUserDefaults standardUserDefaults] setObject:message forKey:message];
    
    
    //RAJOUTER GESTION D UN COMPTEUR D ALERTE DECLENCHE

    
    
       // [[NSUserDefaults standardUserDefaults] removeObjectForKey:<#(NSString *)#>
        
        
        /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"COIN"
                                                            message:[userInfo objectForKey:key]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        */
        
        
        
        
     
    
   

    

}

@end
