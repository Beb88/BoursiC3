//
//  SecondViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListValViewController.h"
#import "AFNetworking.h"
#import "Detail_ActionViewController.h"

#import "AFNetworking.h"
#import "SBJson.h"

@interface ListValViewController ()

@end

@implementation ListValViewController
{
    NSMutableArray *listVal;
}

@synthesize TableListVAL ,listValJSON = _listValJSON;
@synthesize dataForPlot, hostingView,activityIndicatorView;//,refreshControl;

//ANCIENNE DEPUIS TABLE JSON ( PB REACTU )
static NSString *yahooLoadStockDetailsURLString = @"http://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.quotes%%20where%%20symbol%%20%%3D%%20%%22%@%%22&format=json&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=cbfunc";

//@"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D'http%3A%2F%2Fdownload.finance.yahoo.com%2Fd%2Fquotes.csv%3Fs%3D%%22%@%%22%26f%3Dsl1p2d1t1c1ohgva2x%26e%3D.csv'%20and%20columns%3D'symbol%2CLastTradePriceOnly%2CPercentChange%2Cdate%2Ctime%2Cchange%2Couv%2Chigh%2Clow%2CVolume%2CAverageDailyVolume%2CStockExchange'&format=json&diagnostics=true&callback=cbfunc";

/*http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D'http%3A%2F%2Fdownload.finance.yahoo.com%2Fd%2Fquotes.csv%3Fs%3D
 UBI.PA%2CGFT.PA%2CUBIBS.PA
 %26f%3Dsl1p2d1t1c1ohgva2x%26e%3D.csv'%20and%20columns%3D'symbol%2CLastTradePriceOnly%2CPercentChange%2Cdate%2Ctime%2Cchange%2Couv%2Chigh%2Clow%2CVolume%2CAverageDailyVolume%2CStockExchange'&format=json&diagnostics=true&callback=cbfunc*/

/*#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20BidRealtime%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
#define QUOTE_QUERY_SUFFIX @")&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

*/

//%%22%@%%22

///////////////////////////////////////////////////
// CHARGEMENT ET SAUVEGARDE DES DONNEES
//////////////////////////////////////////////////


- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory; }


- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"BCC.plist"]; }


-(void)savelistValeurs {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:listVal forKey:@"Valeurs"]; [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    // POPUP
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAV OK"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];*/
    //
    
}


//RECUPERATION DE LA LISTE EN BASE LOCALE
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self loadlistValeurs];
       
          }
    return self;
}



-(void)loadlistValeurs {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        listVal = [unarchiver decodeObjectForKey:@"Valeurs"];
        NSLog(@"NBR DE VALEURS RECUPERES DANS BASE LOCALE = %i", listVal.count);
        
        NSLog(@"listVal = %@",listVal);
            [unarchiver finishDecoding]; }
    else
    {
        listVal = [[NSMutableArray alloc] initWithCapacity:20];
    } }

//////////////////////////////////////////
//FONCTION DE REFRESH DE LA TABLEVIEW
/////////////////////////////////////////
- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"REFRESH DE LA LISTE : Mise en priorité basse de la recherche net %@", [self dataFilePath]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
         [activityIndicatorView startAnimating];
        for (Valeurs *Val in listVal) {
            [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:Val ];
             
        }
        
        [self.TableListVAL reloadData];
        [self.TableListVAL reloadInputViews];
        [activityIndicatorView stopAnimating];
    
    });
    

    
    [self.TableListVAL reloadData];
    [self.TableListVAL reloadInputViews];
    [refreshControl endRefreshing];
       
    
}


///////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Documents folder is %@", [self documentsDirectory]);
    NSLog(@"Data file path is %@", [self dataFilePath]);
	// Do any additional setup after loading the view, typically from a nib.
    // Setting Up Table View
    
    self.TableListVAL.dataSource = self;
    self.TableListVAL.delegate = self;
    
    
    
    // Implémentation de l' Activity Indicator View
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.hostingView.center;
    [self.view addSubview:self.activityIndicatorView];
    
    //CUSTO GRAPHIQUE du TABLEVIEW
    //self.TableListVAL.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"nav-bar.png"]];
    //[self.tableView setBackgroundView:nil];
    //[self.tableView setBackgroundColor: [UIColor blackColor]];
    
    
   
    
    // implémentation du refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.TableListVAL addSubview:refreshControl];

    
    
  
    
    
     NSLog(@"Mise en priorité basse la recherche net %@", [self dataFilePath]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    //
        [self.activityIndicatorView startAnimating];
   
    for (Valeurs *Val in listVal) {
        
       
        [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:Val ];
        
      
        }
        
        [self.TableListVAL reloadData];
        [self.TableListVAL reloadInputViews];
         [self.activityIndicatorView stopAnimating];
    });
    
    
    [self.TableListVAL setHidden:NO];
    [self.TableListVAL reloadData];
  
 

    
       
    
    
   // refreshControl
    
    [ self ConstructionGraph];
    
      
    
  

}

- (void)viewDidUnload
{
    [self setTableListVAL:nil];
    [self setHostingView:nil];
    [self setTextdetailcell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


//////////////////////////////////////////////////////////////
//          Table View Data Source Methods
//////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listVal && listVal.count) {
        return listVal.count;
    } else {
        return 0;
    }
}



/////////////////////////////
// REMPLISSAGE TABLEVIEW
/////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    
    NSLog(@"Fonction  cellForRowAtIndexPath pour la cellule a l index %@", indexPath );
    
    //ListofValeurs est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofValeurs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
   
  //  NSLog(@"IN TABLEVIEW CELLROWFORROWATINDEXPATH");
  //  NSLog(@"CONTENU LISTVAL = %@",listVal );

    Valeurs *valeur = [listVal objectAtIndex:indexPath.row];
    
    UILabel *labelValeur = (UILabel *)[cell viewWithTag:1000];
    UITextView *labelEvo = (UITextView *)[cell viewWithTag:2000];
    UILabel *labelCours = (UILabel *)[cell viewWithTag:3000];
    UILabel *labelISIN = (UILabel *)[cell viewWithTag:4000];
    UILabel *labelNbAlert = (UILabel *)[cell viewWithTag:5000];
    
    NSLog(@"contenant la valeur= %@, avec cotation = %@ et variation = %@", valeur.nom,valeur.cotation,valeur.variation);
    labelValeur.text =  valeur.nom;
    labelISIN.text = valeur.codeBourso;
    labelCours.text = valeur.cotation;
    labelEvo.text = valeur.variation;
    
    int count = [valeur.listeAlertes count];
    labelNbAlert.text =[NSString stringWithFormat:@"%d Alerte(s)", count];


    
    
    
    if (labelEvo.text.doubleValue>0)
    {
        NSLog(@"VERT");
        labelEvo.backgroundColor = [UIColor greenColor];
    }
    else
    {
        NSLog(@"ROUGE");
        labelEvo.backgroundColor = [UIColor redColor];
    }
     //NSLog(@"OUT TABLEVIEW CELLROWFORROWATINDEXPATH");
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 



//////////////////////////////////////////////////////////////
//          PASSAGE SUR ECRAN DETAIL ACTION
//////////////////////////////////////////////////////////////



//On SELECTIONNE UNE LIGNE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //[self.navigationController pushViewController:detailValeur animated:YES];
   
    
    Valeurs *valeur  = [listVal objectAtIndex:indexPath.row];
    
    NSLog(@"On SELECTION  ");
    NSLog(@"ON SELECTIONNE  LA VALEUR : %@",valeur.nom);
    
    //NSLog(@"ON PASSE LA VALEUR : %@",valeur.nom);
    
    NSString* Title = [NSString stringWithFormat:@"%@ - %@ --  %@", valeur.dateMaj,valeur.heureMaj, valeur.cotation];
    graph.title = Title;
    
    //
    
    
    
    
    //[self performSegueWithIdentifier:@"showDetailValeur" sender:valeur];
    
}

//ON SELECTIONNE LE DETAIL 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
   //  NSLog(@"CLIC DETAIL");
   Valeurs *valeur_det  = [listVal objectAtIndex:indexPath.row];
  // NSLog(@"ON VEUT LE DETAIL DE LA VALEUR : %@",valeur_det.nom);
    
    [self.TableListVAL selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewRowAnimationTop];
   // UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailStoryboardID"];
    
	//Detail_ActionViewController *controller = (Detail_ActionViewController *)navigationController.topViewController;
    //controller.valeurRecue = valeur_det;
    //controller.delegate = self;
    
  
    
    
    
    
  // [self performSegueWithIdentifier:@"showDetailValeur" sender:valeur_det];
    
    
    /*UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailStoryboardID"];
    
	Detail_ActionViewController *controller = (Detail_ActionViewController *)navigationController.topViewController;
	controller.delegate = self;
    
	Valeurs *valeurdetail = [listVal objectAtIndex:indexPath.row];;
	controller.valeurRecue = valeurdetail;
    
	[self presentViewController:navigationController animated:YES completion:nil];*/

}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
   
   //if([sender isKindOfClass:[Valeurs class]])
    if ([segue.identifier isEqualToString:@"showDetailValeur"]) {
       
        Detail_ActionViewController *controller = segue.destinationViewController;
        
        //UINavigationController *navigationController = segue.destinationViewController;
        //Detail_ActionViewController *controller = (Detail_ActionViewController *)navigationController.topViewController;
        
        //ON RECUPERE LA VALEUR DEPUIS LE PREPAREFOR SEGUE ( PAS BESOIN DE LE FAIRE DANS LE DIDSELECT OU ACCESSORYTAPPED
        
        NSIndexPath *indexPath = [self.TableListVAL indexPathForSelectedRow];
           Valeurs *valeur_test = [listVal objectAtIndex:indexPath.row];
        
        NSLog(@"le sender est  %@",sender);
        //controller.valeurRecue = sender;
        controller.valeurRecue = valeur_test;
        controller.delegate= self;
        
    }
    
    
    
    if ([segue.identifier isEqualToString:@"VersEcranAjoutValeur"]) {
            UINavigationController *navigationController = segue.destinationViewController;
            AjoutValeurViewController *controller = (AjoutValeurViewController *)navigationController.topViewController;
            controller.delegate = self;
        }
    
    
}





///////////////////////////////////////////////////////////
//      SUPPRESSION D UNE LIGNE DE TABLEAU ( STANDARD APPLE
/////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [listVal removeObjectAtIndex:indexPath.row];
    
    [self savelistValeurs];
    
   
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void) MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:(Valeurs*)valeur
{
    
    NSLog(@"RECHERCHE INTERNET YAHOO pour %@", valeur.nom );
    //On construit la requete URL en fonction de la valeur passée
    // On ajoute la codification TICK à la requete URL ( exemple  : UBI.PA pour Ubisoft)
    
    
    //PREVOIR OPTIMISATION CHERCHER TOUTES LES VALEURS EN UNE FOIS
    /* modele de la requete multi valeurs
     http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20%22GFT.PA,UBI.PA%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=cbfunc
     */
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:yahooLoadStockDetailsURLString, [valeur.codeBourso stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    NSLog(@"ON BALANCE l URL : %@",requestUrl.absoluteString);
    
    //On execute la requete URL
    NSURLRequest* requestB = [NSURLRequest requestWithURL:requestUrl];
    NSData* responseB = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:nil];
    
    
    //SI PAS DE CONNEXION INTERNET
    if (responseB!=nil) {
        // On transforme le résultat en String de type NSASCII
        NSString* jsonStringB = [[NSString alloc] initWithData:responseB encoding:NSASCIIStringEncoding];
        
        // Remove the jsonp callback ( specifique au renvoi de YAHOO FINANCE
        NSString *cleanJson = [jsonStringB substringFromIndex:7];
        cleanJson = [cleanJson substringToIndex:[cleanJson length]-2];
        
        //  NSDictionary *jsonResults= [cleanJson JSONValue];
        //NSLog(@"jsonResults : %@", cleanJson);
        
        SBJsonParser *parser = [SBJsonParser new];
        NSDictionary *parsedDictionary = [parser objectWithString:cleanJson];
        
        
        //ATTENTION CA PEUT BUGGER
        NSDictionary *stockInfo = [[parsedDictionary objectForKey:@"query"] objectForKey:@"results"] ;
        NSLog(@"DICO STOCKINFO = %@",stockInfo);
       
        NSString *count_local = [[parsedDictionary objectForKey:@"query"] objectForKey:@"count"] ;
       // NSLog(@"COUNT STOCKINFO = %i",count_local);
               // SI marché fermé LastTradePriceOnly
        if (!count_local.intValue==0) {
            valeur.cotation =  [[ stockInfo objectForKey:@"quote"]
                                objectForKey:@"LastTradePriceOnly" ];
            valeur.variation = [[ stockInfo objectForKey:@"quote"]
                                objectForKey:@"PercentChange" ];
            valeur.volumeEnc = [[ stockInfo objectForKey:@"quote"]
                                objectForKey:@"Volume" ];
            
            valeur.dateMaj = [[ stockInfo objectForKey:@"quote"]
                             objectForKey:@"LastTradeDate" ];
            valeur.heureMaj =    [[ stockInfo objectForKey:@"quote"] objectForKey:@"LastTradeTime" ];
            
            // RAF DATEHIGH, DATELOW, YEARLOW , YEARHIGH
            
            //valeur.devise =
            NSLog(@"FIN DE RECHERCHE INTERNET YAHOO pour %@", valeur.nom );
            
        }
        else
        //ECHEC DU BLOC COUNT = 0 
        {
            //valeur.cotation =  @"0.00";
            //valeur.variation = @"0.00";
            //valeur.volumeEnc = @"0";
            
            
            /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur à la récupération"
                                                                message:valeur.codeBourso
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];*/
            
            NSLog(@"ERREUR A LA RECUPERATION YAHOO FINANCES pour %@", valeur.nom );
            
        }
        
        //  NSLog(@"COTATION VALEUR= %@",valeur.cotation);
        //  NSLog(@"COTATION object = %@",[ stockInfo objectForKey:@"BidRealtime" ]);
    } // SI PAS DE CONNEXION
    else {
        
        //valeur.cotation = self.valeur.cotation;
        // valeur.variation =self.valeur.variation;
        
    }
    
   
    
}







///////////////////////////////////////////////////////////
//METHODES DELEGUES POUR LE RETOUR D ECRAN AJOUT VALEUR (declarés dans l ecran AjoutValeur
/////////////////////////////////////////////////////////



-(void) AjoutValeurViewControllerDidCancel:(AjoutValeurViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



// AJOUT D UNE VALEUR
-(void) AjoutValeurViewController:(AjoutValeurViewController *)controller ajoutNouvelleValeur:(Valeurs *)valeur
{
    
    NSLog(@"RECHERCHE DU COURS POUR LA NOUVELLE ACTION %@",valeur.nom);

    valeur.cotation=@"0.00";
    valeur.variation=@"0.00";
    [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:valeur ];
     int newRowIndex = [listVal count];
   
    [listVal addObject:valeur];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
   
    [self.TableListVAL insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self savelistValeurs];
  
    NSLog(@"MAJ des objet listVal et TableListVal : OK");
 
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.TableListVAL reloadData];
}


- (void)SAV_ALERT:(Detail_ActionViewController *)controller
{
  [self savelistValeurs];
}

/*
- (IBAction)detailValeur:(id)sender
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailValeur"];
    
    Detail_ActionViewController *controller = (Detail_ActionViewController *)navigationController;
    controller.valeurRecue = sender;
    controller.delegate= self;
    
    //Checklist *checklist = [lists objectAtIndex:indexPath.row];
    //controller.checklistToEdit = checklist;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"showDetailValeur" sender:sender];


}
*/

/*
 
 - (void) MAJ_COURS_DU_MOMENT_SOURCE_ECHOS:(Valeurs*)valeur
 {
 //On construit la requete URL en fonction de la valeur passée
 
 if ([valeur.nom isEqualToString: @"FACEBOOK"])
 {
 NSLog(@"ON EST AU US");
 valeur.codif = @"ISIN";
 valeur.place =@"XNAS";
 }
 else
 {
 NSLog(@"ON EST A PARIS");
 valeur.codif = @"ISIN";
 valeur.place =@"XPAR";
 }
 
 NSString* URLString = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"http://bourse.lesechos.fr/bourse/streaming/fiches/getHeader.jsp?code=",valeur.codeBourso,@"&place=",valeur.place,@"&codif=",valeur.codif];
 NSLog(@"ON BALANCE l URL : %@",URLString);
 
 
 //On execute la requete URL
 NSURLRequest* requestB = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
 // On récupère le résultat de la requête JSON ( avec 6 lignes vides avt)
 NSData* responseB = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:nil];
 
 // On transforme le résultat en String de type NSASCII (TRAITEMENT SPECIFIQUE pour source leschos)
 NSString* jsonStringB = [[NSString alloc] initWithData:responseB encoding:NSASCIIStringEncoding];
 
 //Suppression des lignes vides
 NSString *trimmedText = [jsonStringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 // On met le resultat en string et purgé des lignes vides dans un NSdictionnaire JSON
 NSDictionary *jsonResults= [trimmedText JSONValue];
 //NSLog(@"jsonResults : %@", jsonResults);
 
 //1er niveau du JSON
 NSDictionary *cotation = [ jsonResults objectForKey:@"cotation" ];
 
 //second niveau du JSON on recupere les données de l'action
 //NSLog(@"Valo : %@", [ cotation objectForKey:@"valorisationEnc" ]);
 //NSLog(@"heure : %@", [ cotation objectForKey:@"heure" ]);
 
 
 valeur.cotation =  [ cotation objectForKey:@"valorisationEnc" ];
 valeur.variation = [ cotation objectForKey:@"variation" ];
 valeur.volumeEnc = [ cotation objectForKey:@"volumeEnc" ];
 
 }
 */




//////////////////////////////////////////////////////////////
//          METHODES POUR LE GRAPHIQUE
//////////////////////////////////////////////////////////////


-(void) ConstructionGraph
{
    
    // Données de test du graph
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:30];
	NSUInteger i;
	for ( i = 0; i < 30; i++ ) {
        id x = [NSNumber numberWithFloat:i];
        id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 2.2];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    
    
    
    self.dataForPlot = contentArray;
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    
    // Theme du graphique
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    

    
    /*  graph = (CPTXYGraph *)[theme newGraph];
     
     graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
     graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
     
     */
    
    [graph applyTheme:theme];
    
    
    
    //Style personnalisé de texte ( voir autre CPTMutable....)
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontName = @"HelveticaNeue-Thin";
    textStyle.fontSize = 16.0f;
    graph.titleTextStyle = textStyle;
    
    
    
    graph.titleDisplacement = CGPointMake(0.0f, -161);
    
    
    
    // COORDONNES et TAILLE DU GRAPHiQUE PLACE DANS LE HOSTINGVIEW DU STORYBOARD
    CPTGraphHostingView *graphHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 320, 194)];
    graphHostingView.collapsesLayers = NO;
    graphHostingView.hostedGraph = graph;
    
    
    
    // On ajoute le graph a l UIVIEW placé sur l'ecran
    [hostingView addSubview:graphHostingView];
    
    
    //definition de l affichage
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.8) length:CPTDecimalFromFloat(30.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.8) length:CPTDecimalFromInt(10)];
    
    // Axe X
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"5");
    x.minorTicksPerInterval = 4;
    
    // Axe Y
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"5");
    y.minorTicksPerInterval = 4;
    
    
    
    // Ligne du graphique
    CPTScatterPlot *boundLinePlot = [[CPTScatterPlot alloc] init ];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [CPTColor blackColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier = @"Blue Plot";
    boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
    
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}



-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
    return [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
}

/*
 
 -(NSUInteger)numberOfRecords {
 return 51;
 }
 
 -(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum
 recordIndex:(NSUInteger)index
 {
 double val = (index/5.0)-5;
 if(fieldEnum == CPTScatterPlotFieldX)
 { return [NSNumber numberWithDouble:val]; }
 else
 {
 if(plot.identifier == @"X Squared Plot")
 { return [NSNumber numberWithDouble:val*val]; }
 else
 { return [NSNumber numberWithDouble:1/val]; }
 }
 }
 */





@end
