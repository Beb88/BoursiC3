//
//  Valeurs.h
//  BoursiC3
//
//  Created by Bertrand louis on 01/11/12.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"

@interface Valeurs : NSObject{
    
	
	NSString *nom;
	NSString *cotation;
    NSString *devise;
    NSString *codeBourso; //(ISIN)
    NSString *codeIsin;
    NSInteger idValeur;
	NSInteger idCompo;
    NSString *place;
    NSString *codif;
    NSInteger *nb_alertes;
    
    
}

@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *cotation;
@property (nonatomic, retain) NSString *devise;
@property (nonatomic, retain) NSString *codeBourso;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *codif;
@property  NSInteger idValeur;
@property  NSInteger idCompo;
@property  NSInteger nb_alertes;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) ajoutValeur;
- (void) deleteValeur;


@end
