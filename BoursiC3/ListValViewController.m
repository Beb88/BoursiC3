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
@synthesize dataForPlot, hostingView;//,refreshControl;


static NSString *yahooLoadStockDetailsURLString = @"http://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.quotes%%20where%%20symbol%%20%%3D%%20%%22%@%%22&format=json&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=cbfunc";


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
        NSLog(@"NBR OBJET RECUPERE DANS BASE LOCALE = %i", listVal.count);
        [unarchiver finishDecoding]; }
    else
    {
        listVal = [[NSMutableArray alloc] initWithCapacity:20];
    } }


//FONCTION DE REFRESH

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"Mise en priorité basse la recherche net %@", [self dataFilePath]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        for (Valeurs *Val in listVal) {
            [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:Val ];
            
        }
        
        [self.TableListVAL reloadData];
        [self.TableListVAL reloadInputViews];
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
    
    //CUSTO GRAPHIQUE du TABLEVIEW
    //self.TableListVAL.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"nav-bar.png"]];
    //[self.tableView setBackgroundView:nil];
    //[self.tableView setBackgroundColor: [UIColor blackColor]];
    
    // [self.activityIndicatorView stopAnimating];
    
    
     NSLog(@"Mise en priorité basse la recherche net %@", [self dataFilePath]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    
   for (Valeurs *Val in listVal) {
       [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:Val ];
   
        }
        
        [self.TableListVAL reloadData];
        [self.TableListVAL reloadInputViews];
    });
    
    
    [self.TableListVAL setHidden:NO];
    [self.TableListVAL reloadData];
    

    
    // implémentation du refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.TableListVAL addSubview:refreshControl];
    
    
    
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//          TRANSFERT DU JSON RECU DANS UN NSMutableArray CONTENANT TOUS LES OBJETS de type VALEURS
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) TransfertJSON_Vers_Objet_ListVal
{
    
    //codeBourso = UBI;
    //codeIsin = FR0000054470;
    //deviseValeur = EUR;
    //idCompo = 1;
    //idValeur = 1;
    //nomValeur = UBISOFT
    
    listVal = [[NSMutableArray alloc] initWithCapacity:20];
    
    for ( int i=0; i< [self.listValJSON count]; i=i+1)
    {
         Valeurs *valeur = [Valeurs new];
        NSDictionary *listValDict3 = [self.listValJSON objectAtIndex:i];
        valeur.codeBourso = [listValDict3 objectForKey:@"codeIsin"];
        valeur.nom = [listValDict3 objectForKey:@"nomValeur"];
        [listVal addObject:valeur];
        NSLog(@"On ajoute %@ A listVal",valeur.nom);
        
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
    
    NSLog(@"contenant la valeur= %@", valeur.nom);
    labelValeur.text =  valeur.nom;
    labelISIN.text = valeur.codeBourso;
    labelCours.text = valeur.cotation;
    labelEvo.text = valeur.variation;
    
    
    
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
    
    
    
    
    // NSLog(@"ON CHECK LIGNE %@  avec codif %@",valeur.nom, valeur.codif);
    
  //  if (valeur.codif==@"ISIN" ) {
  //      [self MAJ_COURS_DU_MOMENT_SOURCE_ECHOS:valeur ];
  //  }
  //  else if (valeur.codif==@"TICK" )
  //  {
     //   [self MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:valeur ];
    
   // NSLog(@"COURS = %@",valeur.cotation);
    
  
    
  
    
    //NSLog(@"OUT TABLEVIEW CELLROWFORROWATINDEXPATH");
    return cell;
}




- (void) MAJ_COURS_DU_MOMENT_SOURCE_YAHOO:(Valeurs*)valeur
{
    
    NSLog(@"RECHERCHE INTERNET YAHOO pour %@", valeur.nom );
    //On construit la requete URL en fonction de la valeur passée
    // On ajoute la codification TICK à la requete URL ( exemple  : UBI.PA pour Ubisoft)
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:yahooLoadStockDetailsURLString, [valeur.codeBourso stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    //NSLog(@"ON BALANCE l URL : %@",requestUrl.absoluteString);
    
    //On execute la requete URL
    NSURLRequest* requestB = [NSURLRequest requestWithURL:requestUrl];
  
    NSData* responseB = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:nil];
    
    // On transforme le résultat en String de type NSASCII 
    NSString* jsonStringB = [[NSString alloc] initWithData:responseB encoding:NSASCIIStringEncoding];
    
    
    // Remove the jsonp callback ( specifique au renvoi de YAHOO FINANCE
    NSString *cleanJson = [jsonStringB substringFromIndex:7];
	cleanJson = [cleanJson substringToIndex:[cleanJson length]-2];

    
    NSDictionary *jsonResults= [cleanJson JSONValue];
   // NSLog(@"jsonResults : %@", jsonResults);
    
    
    SBJsonParser *parser = [SBJsonParser new];
	NSDictionary *parsedDictionary = [parser objectWithString:cleanJson];

 
    NSDictionary *stockInfo = [[[parsedDictionary objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"];
    
    valeur.cotation =  [ stockInfo objectForKey:@"BidRealtime" ];
    valeur.variation = [ stockInfo objectForKey:@"PercentChange" ];
    valeur.volumeEnc = [ stockInfo objectForKey:@"Volume" ];
    
    NSLog(@"FIN DE RECHERCHE INTERNET YAHOO pour %@", valeur.nom );
  //  NSLog(@"COTATION VALEUR= %@",valeur.cotation);
  //  NSLog(@"COTATION object = %@",[ stockInfo objectForKey:@"BidRealtime" ]);
    
    
}






//////////////////////////////////////////////////////////////
//          PASSAGE SUR ECRAN DETAIL ACTION
//////////////////////////////////////////////////////////////



//On SELECTIONNE UNE LIGNE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //[self.navigationController pushViewController:detailValeur animated:YES];
    NSLog(@"On clic  ");
    
    Valeurs *valeur  = [listVal objectAtIndex:indexPath.row];
    
    //NSLog(@"ON PASSE LA VALEUR : %@",valeur.nom);
    graph.title = valeur.nom;
    
    
    [self performSegueWithIdentifier:@"showDetailValeur" sender:valeur];
    
}

//ON SELECTIONNE LE DETAIL 
/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
    // NSLog(@"CLIC DETAIL");
    Valeurs *valeur  = [listVal objectAtIndex:indexPath.row];
   NSLog(@"ON PASSE LA VALEUR : %@",valeur.nom);
    [self performSegueWithIdentifier:@"showDetailValeur" sender:valeur];

}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
   
    if ([segue.identifier isEqualToString:@"showDetailValeur"]) {
        Detail_ActionViewController *controller = segue.destinationViewController;
        controller.valeurRecue = sender;
        controller.delegate= self;
        
        
    }
    
    
    
    if ([segue.identifier isEqualToString:@"VersEcranAjoutValeur"]) {
            UINavigationController *navigationController = segue.destinationViewController;
            AjoutValeurViewController *controller = (AjoutValeurViewController *)navigationController.topViewController;
            controller.delegate = self;
        }
    
    
}





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





///////////////////////////////////////////////////////////
//      SUPPRESSION D UNE LIGNE DE TABLEAU ( STANDARD APPLE
/////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [listVal removeObjectAtIndex:indexPath.row];
    
    [self savelistValeurs];
    
   
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}




///////////////////////////////////////////////////////////
//METHODES DELEGUES POUR LE RETOUR D ECRAN AJOUT VALEUR (declarés dans l ecran AjoutValeur
/////////////////////////////////////////////////////////



-(void) AjoutValeurViewControllerDidCancel:(AjoutValeurViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void) AjoutValeurViewController:(AjoutValeurViewController *)controller ajoutNouvelleValeur:(Valeurs *)valeur
{
    
    NSLog(@"RECHERCHE DU COURS POUR LA NOUVELLE ACTION %@",valeur.nom);

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


@end
