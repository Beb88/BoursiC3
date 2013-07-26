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
    NSString *id_Valeur;
    NSString *nom_alerte;
    
    NSString *id_indic;
    
    NSString *param1;
    NSString *param2;
    NSString *param3;
    NSString *param4;
    
    NSString *etat_alerte;
    
    
   //@"UBI.PA", @"codeyf",
   // @"2", @"idindic", //1 ou 2(seuil)
   // @"notif", @"typealert", //notif ou mail
    //@"THEFIRSTNAMEALERT", @"namealert",
    //@"10", @"seuil", //
    //@"H", @"sens", // H ou B
    //@"0", @"volume",

}

@property  (nonatomic, retain) NSString *id_alerte,*id_Valeur,*id_indic, *etat_alerte;


@property (nonatomic, retain) NSString *nom_alerte;
@property (nonatomic, retain) NSString *param1, *param2, *param3, *param4;

@end
