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
@synthesize dataForPlot, hostingView;

//
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
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    
    if ((self = [super initWithCoder:aDecoder])) { [self loadlistValeurs];
         NSLog(@"NBR OBJET RECUPERE DANS BASE LOCALE = %i", listVal.count);
        
       /* for (Valeurs *Val in listVal) {
            Valeurs_Alertes *alert = [[Valeurs_Alertes alloc] init];
            //alert.nom_alerte = [NSString stringWithFormat:@"Seuil %@", Val.nom];
             alert.nom_alerte = [NSString stringWithFormat:@"Seuil"];
            [Val.listeAlertes addObject:alert];
            
            Valeurs_Alertes *alert2 = [[Valeurs_Alertes alloc] init];
            alert2.nom_alerte = [NSString stringWithFormat:@"Volumetrie"];
            [Val.listeAlertes addObject:alert2];
              NSLog(@"NBR OBJET RECUPERE DANS BASE LOCALE = %i", listVal.count);
        }*/
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Documents folder is %@", [self documentsDirectory]);
    NSLog(@"Data file path is %@", [self dataFilePath]);
	// Do any additional setup after loading the view, typically from a nib.
    // Setting Up Table View
    
    self.TableListVAL.dataSource = self;
    self.TableListVAL.delegate = self;
    
    //CUSTO GRAPHIQUE
    //self.TableListVAL.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"nav-bar.png"]];
    //[self.tableView setBackgroundView:nil];
    //[self.tableView setBackgroundColor: [UIColor blackColor]];
    
    // [self.activityIndicatorView stopAnimating];
    [self.TableListVAL setHidden:NO];
    [self.TableListVAL reloadData];
        
    
    
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


-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [listVal removeObjectAtIndex:indexPath.row];
    
    [self savelistValeurs];
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


/////////////////////////////
// REMPLISSAGE TABLEVIEW
/////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //ListofValeurs est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofValeurs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
   
    NSLog(@"IN TABLEVIEW CELLROWFORROWATINDEXPATH");
    NSLog(@"CONTENU LISTVAL = %@",listVal );
    
    /*
    //VISU CONTENU D UN DICTIONNAIRE
    NSEnumerator *enumerator = [ listValDict keyEnumerator];
    NSString *key;
    while (key = [ enumerator nextObject]) {
        printf("%s\n", [[ listValDict objectForKey:key] UTF8String]);
    }
    //FIN //VISU CONTENU D UN DICTIONNAIRE
    */
    
    
    Valeurs *valeur = [listVal objectAtIndex:indexPath.row];
    
    
    
    UILabel *labelValeur = (UILabel *)[cell viewWithTag:1000];
    UITextView *labelEvo = (UITextView *)[cell viewWithTag:2000];
    UILabel *labelCours = (UILabel *)[cell viewWithTag:3000];
    UILabel *labelISIN = (UILabel *)[cell viewWithTag:4000];
    
    ///NSLog(@"VALEUR = %@", valeur);
    labelValeur.text =  valeur.nom;
    labelISIN.text = valeur.codeBourso;
    
    
    [self MAJ_COURS_DU_MOMENT:valeur ];
    
    NSLog(@"COURS = %@",valeur.cotation);
    
    if (valeur.cotation.integerValue>0)
    {
        //labelEvo.backgroundColor = [UIColor greenColor];
        
        labelEvo.backgroundColor = [UIColor greenColor];
       
    }
    else
    {
        //labelEvo.backgroundColor = [UIColor redColor];
        labelEvo.backgroundColor = [UIColor redColor];
        
    }
    labelCours.text = valeur.cotation;
    labelEvo.text = valeur.variation;
    NSLog(@"OUT TABLEVIEW CELLROWFORROWATINDEXPATH");
    return cell;
}



- (void) MAJ_COURS_DU_MOMENT:(Valeurs*)valeur
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
    NSLog(@"jsonResults : %@", jsonResults);
    
    //1er niveau du JSON
    NSDictionary *cotation = [ jsonResults objectForKey:@"cotation" ];
    
    //second niveau du JSON on recupere les données de l'action
    NSLog(@"Valo : %@", [ cotation objectForKey:@"valorisationEnc" ]);
	NSLog(@"heure : %@", [ cotation objectForKey:@"heure" ]);
    
    
    valeur.cotation =  [ cotation objectForKey:@"valorisationEnc" ];
    valeur.variation = [ cotation objectForKey:@"variation" ];
    valeur.volumeEnc = [ cotation objectForKey:@"volumeEnc" ];
    
  

}





//////////////////////////////////////////////////////////////
//          PASSAGE SUR ECRAN DETAIL ACTION
//////////////////////////////////////////////////////////////



//On SELECTIONNE UNE LIGNE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"On clique sur une ligne");
    //[self.navigationController pushViewController:detailValeur animated:YES];
    static NSString *cellID = @"ListofValeurs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLog(@"On envoit la cellule: %@", cell);
    
    Valeurs *valeur  = [listVal objectAtIndex:indexPath.row];
    
   // Valeurs *valeur =  [Valeurs new];
    
    //valeur.codeBourso = [listValDict2 objectForKey:@"codeBourso"];
    //valeur.nom = [listValDict2 objectForKey:@"nom"];
    
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
    
    NSLog(@"ON PASSE LA VALEUR : %@",valeur.nom);
    
    [self performSegueWithIdentifier:@"showDetailValeur" sender:valeur];
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
   
    if ([segue.identifier isEqualToString:@"showDetailValeur"]) {
        Detail_ActionViewController *controller = segue.destinationViewController;
        controller.valeurRecue = sender;
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
    
    // COORDONNES DE L EMPLACEMENT DU GRAPH
    CPTGraphHostingView *graphHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    graphHostingView.collapsesLayers = NO;
    graphHostingView.hostedGraph = graph;
    // On ajoute le graph a l UIVIEW placé sur l'ecran
    [hostingView addSubview:graphHostingView];
    
    
    
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
    lineStyle.lineWidth = 4.0f;
    lineStyle.lineColor = [CPTColor blueColor];
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
//METHODES DELEGUES POUR LE RETOUR D ECRAN AJOUT VALEUR (declarés dans l ecran AjoutValeur
/////////////////////////////////////////////////////////
-(void) AjoutValeurViewControllerDidCancel:(AjoutValeurViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) AjoutValeurViewController:(AjoutValeurViewController *)controller ajoutNouvelleValeur:(Valeurs *)valeur
{
    
    //NSLog(@"Valeur Saisie recuperee par le delegate: %@",valeur.nom);
    int newRowIndex = [listVal count];
   
    [listVal addObject:valeur];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
   
    [self.TableListVAL insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self savelistValeurs];
    NSLog(@"SAV");
   
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
