//
//  Valeurs.m
//  BoursiC3
//
//  Created by Bertrand louis on 01/11/12.
//
//


#import "Valeurs.h"



@implementation Valeurs
@synthesize nom,cotation,devise,idCompo,idValeur,place,codif,codeBourso,nb_alertes,listeAlertes,dateMaj,heureMaj,variation,volumeEnc,volumeMoy;



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nom forKey:@"Nom"];
    [aCoder encodeObject:self.codeBourso forKey:@"CodeBourso"];
    [aCoder encodeObject:self.listeAlertes forKey:@"listeAlertes"];
    [aCoder encodeObject:self.cotation forKey:@"cotation"];
    [aCoder encodeObject:self.variation forKey:@"variation"];
     [aCoder encodeObject:self.volumeMoy forKey:@"volumeMoy"];
     [aCoder encodeObject:self.volumeEnc forKey:@"volumeEnc"];
    [aCoder encodeObject:self.dateMaj forKey:@"dateMaj"];
    [aCoder encodeObject:self.heureMaj forKey:@"heureMaj"];
    [aCoder encodeInteger:self.nb_alertes forKey:@"nb_alertes"];
    
    
   // self.cotation
   // self.variation
}


-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.nom = [aDecoder decodeObjectForKey:@"Nom"];
        self.codeBourso = [aDecoder decodeObjectForKey:@"CodeBourso"];
        self.listeAlertes = [aDecoder decodeObjectForKey:@"listeAlertes"];
        self.cotation = [aDecoder decodeObjectForKey:@"cotation"];
        self.variation = [aDecoder decodeObjectForKey:@"variation"];
        self.volumeEnc = [aDecoder decodeObjectForKey:@"volumeEnc"];
        self.volumeMoy = [aDecoder decodeObjectForKey:@"volumeMoy"];
         self.dateMaj = [aDecoder decodeObjectForKey:@"dateMaj"];
         self.heureMaj = [aDecoder decodeObjectForKey:@"heureMaj"];
        self.nb_alertes = [aDecoder decodeIntegerForKey:@"nb_alertes"];
    }
    return self; }

- (id)init
{
    if ((self = [super init])) {
        self.listeAlertes = [[NSMutableArray alloc] initWithCapacity:80];
    }
    return self;
}


- (int)countListAlertes
{
	int count = 0;
	for (Valeurs *valeur in self.listeAlertes) {
			count += 1;
		}
	
	return count;
}


@end
