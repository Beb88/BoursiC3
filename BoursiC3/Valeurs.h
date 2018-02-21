//
//  Valeurs.h
//  BoursiC3
//
//  Created by Bertrand louis on 01/11/12.
//
//

#import <Foundation/Foundation.h>
/*#import <sqlite3.h>
#import "AppDelegate.h"
*/
@interface Valeurs : NSObject<NSCoding>{
    
	
	NSString *nom;
	NSString *cotation;
    NSString *variation;
    NSString *volumEnc;
    NSString *volumeMoy;
    NSString *devise;
    NSString *codeBourso; //(ISIN OU TICK)
    NSString *codeIsin;
    NSString *dateMaj;
    NSString *heureMaj;
 
    
    NSInteger idValeur;
	NSInteger idCompo;
    NSString *place;
    NSString *codif;
    NSInteger nb_alertes;
    
    
}

@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *cotation;
@property (nonatomic, retain) NSString *volumeEnc;
@property (nonatomic, retain) NSString *volumeMoy;

@property (nonatomic, retain) NSString *variation;
@property (nonatomic, retain) NSString *devise;
@property (nonatomic, retain) NSString *codeBourso;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *codif;
@property (nonatomic, retain) NSString *dateMaj;
@property (nonatomic, retain) NSString *heureMaj;


// A RAJOUTER
//  DaysHigh = "4.13";
//  DaysLow = "3.95";
//DaysRange = "3.95 - 4.13";
//  YearHigh = "2.95";
//  YearLow = "0.71";

//  TradeDate  (peut servir d' equivalent marche fermé si égal à null

@property  NSInteger idValeur;
@property  NSInteger idCompo;
@property  NSInteger nb_alertes;
@property (nonatomic, strong) NSMutableArray *listeAlertes;


//Static methods.
//+ (void) getInitialDataToDisplay:(NSString *)dbPath;
//+ (void) finalizeStatements;

//Instance methods.
//- (id) initWithPrimaryKey:(NSInteger)pk;
//- (void) ajoutValeur;
//- (void) deleteValeur;


@end
