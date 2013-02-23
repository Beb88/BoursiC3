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
    NSInteger id_alerte;
    NSInteger id_Valeur;
    NSString *nom_alerte;
    
    NSString *param1;
    NSInteger param2;
    NSInteger param3;
    NSInteger param4;

}

@property  NSInteger id_alerte;
@property  NSInteger id_Valeur;

@property  NSInteger param2;
@property  NSInteger param3;
@property  NSInteger param4;
@property (nonatomic, retain) NSString *nom_alerte;
@property (nonatomic, retain) NSString *param1;

@end
