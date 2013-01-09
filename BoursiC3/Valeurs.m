//
//  Valeurs.m
//  BoursiC3
//
//  Created by Bertrand louis on 01/11/12.
//
//


#import "Valeurs.h"

static sqlite3 *database = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *deleteStmt = nil;

@implementation Valeurs

@synthesize nom,cotation,devise,idCompo,idValeur;



+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql1 = "select idValeur,nomValeur from valeurs";
        
		sqlite3_stmt *selectstmt1;
		if(sqlite3_prepare_v2(database, sql1, -1, &selectstmt1, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt1) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt1, 0);
				Valeurs *valeursObjet = [[Valeurs alloc] initWithPrimaryKey:primaryKey];
				//alerteObj.alerteId = primaryKey;
                valeursObjet.idValeur = primaryKey;
				
				char *valeurNomChars = [self checkValue:sqlite3_column_text(selectstmt1, 1)];
                
                //valeursObjet.nom = valeurNomChars;
                
                /*char *fruitCouleurChars = [self checkValue:sqlite3_column_text(selectstmt1, 2)];
                valeursObjet.couleur=fruitCouleurChars;
                
				char *fruitTailleChar = [self checkValue:sqlite3_column_text(selectstmt1, 3)];
				valeursObjet.taille=fruitTailleChar;
                */
                [appDelegate.ValeursArray addObject:valeursObjet];
                
                NSLog(@"%@",appDelegate.ValeursArray);
				//[valeursObjet release];
			}
		}
	}
    
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

+(char *)checkValue:(char *) value
{
    if (value ==NULL)
        return nil;
    else
        return nil;
        //NSLog(value);
        //  return [NSString stringWithUTF8String: value];
}

+ (void) finalizeStatements {
	
	if(database) sqlite3_close(database);
	if(addStmt) sqlite3_finalize(addStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	//[super init];
	idValeur = pk;
	
	
	return self;
}


- (void) ajoutValeur {
	
	//NSLog(@"%@-%@-%@-%@-%@", departement,secteur,emploi, experience,contrat);
	
	if(addStmt == nil) {
		const char *sql = "insert into Fruit(nom, couleur, taille) Values(?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		
	}
	
	
	sqlite3_bind_text(addStmt, 1, [nom UTF8String], -1, SQLITE_TRANSIENT);
	//sqlite3_bind_text(addStmt, 2, [couleur UTF8String], -1, SQLITE_TRANSIENT);
	//sqlite3_bind_text(addStmt, 3, [taille UTF8String], -1, SQLITE_TRANSIENT);
    
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		idValeur = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) deleteValeur {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from Fruit where fruitId = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, idValeur);
	//sqlite3_bind_text(deleteStmt, 1, [JobId UTF8String], -1, SQLITE_TRANSIENT);
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}
@end
