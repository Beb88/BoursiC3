//
//  Valeurs_Alertes.m
//  BoursiC3
//
//  Created by Bertrand louis on 02/02/13.
//
//

#import "Valeurs_Alertes.h"

@implementation Valeurs_Alertes

@synthesize id_alerte,id_Valeur,nom_alerte,param1;


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id_alerte forKey:@"id_alerte"];
    [aCoder encodeInt:self.id_Valeur forKey:@"id_Valeur"];
    [aCoder encodeObject:self.nom_alerte forKey:@"nom_alerte"];
    [aCoder encodeObject:self.param1 forKey:@"param1"];
}


-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.id_alerte = [aDecoder decodeObjectForKey:@"id_alerte"];
        self.id_Valeur = [aDecoder decodeIntForKey:@"id_Valeur"];
        self.nom_alerte = [aDecoder decodeObjectForKey:@"nom_alerte"];
        self.param1 = [aDecoder decodeObjectForKey:@"param1"];
        
    }
    return self; }



@end
