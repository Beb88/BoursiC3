//
//  Valeurs_Alertes.h
//  BoursiC3
//
//  Created by Bertrand louis on 02/02/13.
//
//

#import <Foundation/Foundation.h>

@interface Valeurs_Alertes : NSObject<NSCoding>
{
    NSString *id_alerte;
    NSInteger id_Valeur;
    NSString *nom_alerte;
    
    NSInteger id_indicateurs;
    
    NSString *param1;
    NSInteger param2;
    NSInteger param3;
    NSInteger param4;
    
    
   //@"UBI.PA", @"codeyf",
   // @"2", @"idindic", //1 ou 2(seuil)
   // @"notif", @"typealert", //notif ou mail
    //@"THEFIRSTNAMEALERT", @"namealert",
    //@"10", @"seuil", //
    //@"H", @"sens", // H ou B
    //@"0", @"volume",

}

@property  (nonatomic, retain) NSString *id_alerte;
@property  NSInteger id_Valeur;

@property  NSInteger param2;
@property  NSInteger param3;
@property  NSInteger param4;
@property (nonatomic, retain) NSString *nom_alerte;
@property (nonatomic, retain) NSString *param1;

@end
