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
    NSInteger idValeur;
	NSInteger idCompo;
    
    
}

@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *cotation;
@property (nonatomic, retain) NSString *devise;
@property (nonatomic, retain) NSString *codeBourso;
@property  NSInteger idValeur;
@property  NSInteger idCompo;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) ajoutValeur;
- (void) deleteValeur;


@end
