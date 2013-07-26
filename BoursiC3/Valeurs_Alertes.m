//
//  Valeurs_Alertes.m
//  BoursiC3
//
//  Created by Bertrand louis on 02/02/13.
//
//

#import "Valeurs_Alertes.h"

@implementation Valeurs_Alertes

@synthesize id_alerte,id_Valeur,nom_alerte,param1,param2,param3,param4,etat_alerte,id_indic;


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id_alerte forKey:@"id_alerte"];
    [aCoder encodeObject:self.id_Valeur forKey:@"id_Valeur"];
    [aCoder encodeObject:self.id_indic forKey:@"id_indic"];
    [aCoder encodeObject:self.nom_alerte forKey:@"nom_alerte"];
    [aCoder encodeObject:self.etat_alerte forKey:@"etat_alerte"];
    [aCoder encodeObject:self.param1 forKey:@"param1"];
    [aCoder encodeObject:self.param2 forKey:@"param2"];
    [aCoder encodeObject:self.param3 forKey:@"param3"];
    [aCoder encodeObject:self.param4 forKey:@"param4"];
}




-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.id_alerte = [aDecoder decodeObjectForKey:@"id_alerte"];
        self.id_Valeur = [aDecoder decodeObjectForKey:@"id_Valeur"];
        self.nom_alerte = [aDecoder decodeObjectForKey:@"nom_alerte"];
        self.etat_alerte = [aDecoder decodeObjectForKey:@"etat_alerte"];
        self.param1 = [aDecoder decodeObjectForKey:@"param1"];
        self.param2 = [aDecoder decodeObjectForKey:@"param2"];
        self.param3 = [aDecoder decodeObjectForKey:@"param3"];
        self.param4 = [aDecoder decodeObjectForKey:@"param4"];
        
    }
    return self; }



@end
