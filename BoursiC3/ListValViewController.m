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
@synthesize yahooWebview;


static NSString *yahooLoadStockDetailsURLString = @"https://query1.finance.yahoo.com/v7/finance/quote?symbols=%@&lang=fr-FR";

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
        //NSLog(@"NBR DE VALEURS RECUPERES DANS BASE LOCALE = %i", listVal.count);
        
        //NSLog(@"listVal = %@",listVal);
            [unarchiver finishDecoding]; }
    else
    {
        listVal = [[NSMutableArray alloc] initWithCapacity:20];
    } }

//////////////////////////////////////////
//FONCTION DE REFRESH DE LA TABLEVIEW
/////////////////////////////////////////
- (void)refresh:(UIRefreshControl *)refreshControl {
    
    //NSLog(@"REFRESH DE LA LISTE : Mise en priorité basse de la recherche net %@", [self dataFilePath]);
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
    
    //Custo personnalisation de la navigation bar
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:10.0f/255.0f green:30.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
    //self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //NSAttributedStringKey textAttributes_custo = [NSAttributedStringKey.foregroundColor:UIColor.red];
   
    //[NSAttributedStringKey.foregroundColor:UIColor.red];
    
   // self.navigationController.navigationBar.titleTextAttributes =

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
   // [ self ConstructionGraph];
    
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
    labelCours.text =  valeur.cotation;
    labelEvo.text = valeur.variation;
    //labelEvo.text = [labelEvo.text substringToIndex:4];
    
    
    int count = [valeur.listeAlertes count];
    labelNbAlert.text =[NSString stringWithFormat:@"%d Alerte(s)", count];
   
    if (labelEvo.text.doubleValue>0)
    {
        NSLog(@"VERT");
       
        labelEvo.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:209.0/255.0 blue:0.0/255.0 alpha:1.0];
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
    
   // NSString* Title = [NSString stringWithFormat:@"%@ - %@ --  %@", valeur.dateMaj,valeur.heureMaj, valeur.cotation];
   // graph.title = Title;
    
    
    NSString* url_yahoo_dyn = [NSString stringWithFormat:@"%@%@%@", @"https://finance.yahoo.com/chart/",valeur.codeBourso,@"#eyJpbnRlcnZhbCI6ImRheSIsInBlcmlvZGljaXR5IjoxLCJ0aW1lVW5pdCI6bnVsbCwiY2FuZGxlV2lkdGgiOjUuMDUwNTA1MDUwNTA1MDUsInZvbHVtZVVuZGVybGF5Ijp0cnVlLCJhZGoiOnRydWUsImNyb3NzaGFpciI6dHJ1ZSwiY2hhcnRUeXBlIjoibGluZSIsImV4dGVuZGVkIjpmYWxzZSwibWFya2V0U2Vzc2lvbnMiOnt9LCJhZ2dyZWdhdGlvblR5cGUiOiJvaGxjIiwiY2hhcnRTY2FsZSI6ImxpbmVhciIsInBhbmVscyI6eyJjaGFydCI6eyJwZXJjZW50IjowLjY0LCJkaXNwbGF5IjoiR0xFLlBBIiwiY2hhcnROYW1lIjoiY2hhcnQiLCJ0b3AiOjB9LCLigIxtYWNk4oCMICgxMiwyNiw5KSI6eyJwZXJjZW50IjowLjE2LCJkaXNwbGF5Ijoi4oCMbWFjZOKAjCAoMTIsMjYsOSkiLCJjaGFydE5hbWUiOiJjaGFydCIsInRvcCI6MzA5Ljc2fSwi4oCMcnNp4oCMICgxNCkiOnsicGVyY2VudCI6MC4xOTk5OTk5OTk5OTk5OTk5NiwiZGlzcGxheSI6IuKAjHJzaeKAjCAoMTQpIiwiY2hhcnROYW1lIjoiY2hhcnQiLCJ0b3AiOjM4Ny4yfX0sInNldFNwYW4iOm51bGwsImxpbmVXaWR0aCI6Miwic3RyaXBlZEJhY2tncm91ZCI6dHJ1ZSwiZXZlbnRzIjp0cnVlLCJjb2xvciI6IiMwMDgxZjIiLCJzeW1ib2xzIjpbeyJzeW1ib2wiOiJHTEUuUEEiLCJzeW1ib2xPYmplY3QiOnsic3ltYm9sIjoiR0xFLlBBIn0sInBlcmlvZGljaXR5IjoxLCJpbnRlcnZhbCI6ImRheSIsInRpbWVVbml0IjpudWxsLCJzZXRTcGFuIjpudWxsfV0sImN1c3RvbVJhbmdlIjpudWxsLCJzdHVkaWVzIjp7InZvbCB1bmRyIjp7InR5cGUiOiJ2b2wgdW5kciIsImlucHV0cyI6eyJpZCI6InZvbCB1bmRyIiwiZGlzcGxheSI6InZvbCB1bmRyIn0sIm91dHB1dHMiOnsiVXAgVm9sdW1lIjoiIzAwYjA2MSIsIkRvd24gVm9sdW1lIjoiI0ZGMzMzQSJ9LCJwYW5lbCI6ImNoYXJ0IiwicGFyYW1ldGVycyI6eyJoZWlnaHRQZXJjZW50YWdlIjowLjI1LCJ3aWR0aEZhY3RvciI6MC40NSwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjG1hY2TigIwgKDEyLDI2LDkpIjp7InR5cGUiOiJtYWNkIiwiaW5wdXRzIjp7IkZhc3QgTUEgUGVyaW9kIjoxMiwiU2xvdyBNQSBQZXJpb2QiOjI2LCJTaWduYWwgUGVyaW9kIjo5LCJpZCI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIiwiZGlzcGxheSI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIn0sIm91dHB1dHMiOnsiTUFDRCI6IiNhZDZlZmYiLCJTaWduYWwiOiIjZmZhMzNmIiwiSW5jcmVhc2luZyBCYXIiOiIjNzlmNGJkIiwiRGVjcmVhc2luZyBCYXIiOiIjZmY4MDg0In0sInBhbmVsIjoi4oCMbWFjZOKAjCAoMTIsMjYsOSkiLCJwYXJhbWV0ZXJzIjp7ImNoYXJ0TmFtZSI6ImNoYXJ0In19LCLigIxyc2nigIwgKDE0KSI6eyJ0eXBlIjoicnNpIiwiaW5wdXRzIjp7IlBlcmlvZCI6MTQsImlkIjoi4oCMcnNp4oCMICgxNCkiLCJkaXNwbGF5Ijoi4oCMcnNp4oCMICgxNCkifSwib3V0cHV0cyI6eyJSU0kiOiIjYWQ2ZWZmIn0sInBhbmVsIjoi4oCMcnNp4oCMICgxNCkiLCJwYXJhbWV0ZXJzIjp7InN0dWR5T3ZlclpvbmVzRW5hYmxlZCI6dHJ1ZSwic3R1ZHlPdmVyQm91Z2h0VmFsdWUiOjgwLCJzdHVkeU92ZXJCb3VnaHRDb2xvciI6IiM3OWY0YmQiLCJzdHVkeU92ZXJTb2xkVmFsdWUiOjIwLCJzdHVkeU92ZXJTb2xkQ29sb3IiOiIjZmY4MDg0IiwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjEJvbGxpbmdlciBCYW5kc%2BKAjCAoQywyMCwyLG1hLHkpIjp7InR5cGUiOiJCb2xsaW5nZXIgQmFuZHMiLCJpbnB1dHMiOnsiRmllbGQiOiJDbG9zZSIsIlBlcmlvZCI6MjAsIlN0YW5kYXJkIERldmlhdGlvbnMiOjIsIk1vdmluZyBBdmVyYWdlIFR5cGUiOiJzaW1wbGUiLCJDaGFubmVsIEZpbGwiOnRydWUsImlkIjoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkiLCJkaXNwbGF5Ijoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkifSwib3V0cHV0cyI6eyJCb2xsaW5nZXIgQmFuZHMgVG9wIjoiI2ZmZGI0OCIsIkJvbGxpbmdlciBCYW5kcyBNZWRpYW4iOiIjZmZhMzNmIiwiQm9sbGluZ2VyIEJhbmRzIEJvdHRvbSI6IiNmZmJkNzQifSwicGFuZWwiOiJjaGFydCIsInBhcmFtZXRlcnMiOnsiY2hhcnROYW1lIjoiY2hhcnQifX19fQ%3D%3D"];
    
    /*
     
     //RSI MACD BOLLINGER
     
     #eyJpbnRlcnZhbCI6ImRheSIsInBlcmlvZGljaXR5IjoxLCJ0aW1lVW5pdCI6bnVsbCwiY2FuZGxlV2lkdGgiOjUuMDUwNTA1MDUwNTA1MDUsInZvbHVtZVVuZGVybGF5Ijp0cnVlLCJhZGoiOnRydWUsImNyb3NzaGFpciI6dHJ1ZSwiY2hhcnRUeXBlIjoibGluZSIsImV4dGVuZGVkIjpmYWxzZSwibWFya2V0U2Vzc2lvbnMiOnt9LCJhZ2dyZWdhdGlvblR5cGUiOiJvaGxjIiwiY2hhcnRTY2FsZSI6ImxpbmVhciIsInBhbmVscyI6eyJjaGFydCI6eyJwZXJjZW50IjowLjY0LCJkaXNwbGF5IjoiR0xFLlBBIiwiY2hhcnROYW1lIjoiY2hhcnQiLCJ0b3AiOjB9LCLigIxtYWNk4oCMICgxMiwyNiw5KSI6eyJwZXJjZW50IjowLjE2LCJkaXNwbGF5Ijoi4oCMbWFjZOKAjCAoMTIsMjYsOSkiLCJjaGFydE5hbWUiOiJjaGFydCIsInRvcCI6MzA5Ljc2fSwi4oCMcnNp4oCMICgxNCkiOnsicGVyY2VudCI6MC4xOTk5OTk5OTk5OTk5OTk5NiwiZGlzcGxheSI6IuKAjHJzaeKAjCAoMTQpIiwiY2hhcnROYW1lIjoiY2hhcnQiLCJ0b3AiOjM4Ny4yfX0sInNldFNwYW4iOm51bGwsImxpbmVXaWR0aCI6Miwic3RyaXBlZEJhY2tncm91ZCI6dHJ1ZSwiZXZlbnRzIjp0cnVlLCJjb2xvciI6IiMwMDgxZjIiLCJzeW1ib2xzIjpbeyJzeW1ib2wiOiJHTEUuUEEiLCJzeW1ib2xPYmplY3QiOnsic3ltYm9sIjoiR0xFLlBBIn0sInBlcmlvZGljaXR5IjoxLCJpbnRlcnZhbCI6ImRheSIsInRpbWVVbml0IjpudWxsLCJzZXRTcGFuIjpudWxsfV0sImN1c3RvbVJhbmdlIjpudWxsLCJzdHVkaWVzIjp7InZvbCB1bmRyIjp7InR5cGUiOiJ2b2wgdW5kciIsImlucHV0cyI6eyJpZCI6InZvbCB1bmRyIiwiZGlzcGxheSI6InZvbCB1bmRyIn0sIm91dHB1dHMiOnsiVXAgVm9sdW1lIjoiIzAwYjA2MSIsIkRvd24gVm9sdW1lIjoiI0ZGMzMzQSJ9LCJwYW5lbCI6ImNoYXJ0IiwicGFyYW1ldGVycyI6eyJoZWlnaHRQZXJjZW50YWdlIjowLjI1LCJ3aWR0aEZhY3RvciI6MC40NSwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjG1hY2TigIwgKDEyLDI2LDkpIjp7InR5cGUiOiJtYWNkIiwiaW5wdXRzIjp7IkZhc3QgTUEgUGVyaW9kIjoxMiwiU2xvdyBNQSBQZXJpb2QiOjI2LCJTaWduYWwgUGVyaW9kIjo5LCJpZCI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIiwiZGlzcGxheSI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIn0sIm91dHB1dHMiOnsiTUFDRCI6IiNhZDZlZmYiLCJTaWduYWwiOiIjZmZhMzNmIiwiSW5jcmVhc2luZyBCYXIiOiIjNzlmNGJkIiwiRGVjcmVhc2luZyBCYXIiOiIjZmY4MDg0In0sInBhbmVsIjoi4oCMbWFjZOKAjCAoMTIsMjYsOSkiLCJwYXJhbWV0ZXJzIjp7ImNoYXJ0TmFtZSI6ImNoYXJ0In19LCLigIxyc2nigIwgKDE0KSI6eyJ0eXBlIjoicnNpIiwiaW5wdXRzIjp7IlBlcmlvZCI6MTQsImlkIjoi4oCMcnNp4oCMICgxNCkiLCJkaXNwbGF5Ijoi4oCMcnNp4oCMICgxNCkifSwib3V0cHV0cyI6eyJSU0kiOiIjYWQ2ZWZmIn0sInBhbmVsIjoi4oCMcnNp4oCMICgxNCkiLCJwYXJhbWV0ZXJzIjp7InN0dWR5T3ZlclpvbmVzRW5hYmxlZCI6dHJ1ZSwic3R1ZHlPdmVyQm91Z2h0VmFsdWUiOjgwLCJzdHVkeU92ZXJCb3VnaHRDb2xvciI6IiM3OWY0YmQiLCJzdHVkeU92ZXJTb2xkVmFsdWUiOjIwLCJzdHVkeU92ZXJTb2xkQ29sb3IiOiIjZmY4MDg0IiwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjEJvbGxpbmdlciBCYW5kc%2BKAjCAoQywyMCwyLG1hLHkpIjp7InR5cGUiOiJCb2xsaW5nZXIgQmFuZHMiLCJpbnB1dHMiOnsiRmllbGQiOiJDbG9zZSIsIlBlcmlvZCI6MjAsIlN0YW5kYXJkIERldmlhdGlvbnMiOjIsIk1vdmluZyBBdmVyYWdlIFR5cGUiOiJzaW1wbGUiLCJDaGFubmVsIEZpbGwiOnRydWUsImlkIjoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkiLCJkaXNwbGF5Ijoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkifSwib3V0cHV0cyI6eyJCb2xsaW5nZXIgQmFuZHMgVG9wIjoiI2ZmZGI0OCIsIkJvbGxpbmdlciBCYW5kcyBNZWRpYW4iOiIjZmZhMzNmIiwiQm9sbGluZ2VyIEJhbmRzIEJvdHRvbSI6IiNmZmJkNzQifSwicGFuZWwiOiJjaGFydCIsInBhcmFtZXRlcnMiOnsiY2hhcnROYW1lIjoiY2hhcnQifX19fQ%3D%3D
     
     
     https://finance.yahoo.com/chart/GLE.PA#eyJTWSI6W1siR0xFLlBBIixudWxsLDAsMF1dLCJUUyI6WzEsImRheSIsbnVsbCxudWxsXSwiVVMiOlswLDEsMV0sIkNTIjpbImxpbmUiLCJsaW5lYXIiLDUuMDUwNTA1MDUwNTA1MDUsbnVsbCxudWxsLCIjMDA4MWYyIl0sIlNUIjp7InZvbCB1bmRyIjp7InR5cGUiOiJ2b2wgdW5kciIsImlucHV0cyI6eyJpZCI6InZvbCB1bmRyIiwiZGlzcGxheSI6InZvbCB1bmRyIn0sIm91dHB1dHMiOnsiVXAgVm9sdW1lIjoiIzAwYjA2MSIsIkRvd24gVm9sdW1lIjoiI0ZGMzMzQSJ9LCJwYW5lbCI6ImNoYXJ0IiwicGFyYW1ldGVycyI6eyJoZWlnaHRQZXJjZW50YWdlIjowLjI1LCJ3aWR0aEZhY3RvciI6MC40NSwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjG1hY2TigIwgKDEyLDI2LDkpIjp7InR5cGUiOiJtYWNkIiwiaW5wdXRzIjp7IkZhc3QgTUEgUGVyaW9kIjoxMiwiU2xvdyBNQSBQZXJpb2QiOjI2LCJTaWduYWwgUGVyaW9kIjo5LCJpZCI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIiwiZGlzcGxheSI6IuKAjG1hY2TigIwgKDEyLDI2LDkpIn0sIm91dHB1dHMiOnsiTUFDRCI6IiNhZDZlZmYiLCJTaWduYWwiOiIjZmZhMzNmIiwiSW5jcmVhc2luZyBCYXIiOiIjNzlmNGJkIiwiRGVjcmVhc2luZyBCYXIiOiIjZmY4MDg0In0sInBhbmVsIjoi4oCMbWFjZOKAjCAoMTIsMjYsOSkiLCJwYXJhbWV0ZXJzIjp7ImNoYXJ0TmFtZSI6ImNoYXJ0In19LCLigIxyc2nigIwgKDE0KSI6eyJ0eXBlIjoicnNpIiwiaW5wdXRzIjp7IlBlcmlvZCI6MTQsImlkIjoi4oCMcnNp4oCMICgxNCkiLCJkaXNwbGF5Ijoi4oCMcnNp4oCMICgxNCkifSwib3V0cHV0cyI6eyJSU0kiOiIjYWQ2ZWZmIn0sInBhbmVsIjoi4oCMcnNp4oCMICgxNCkiLCJwYXJhbWV0ZXJzIjp7InN0dWR5T3ZlclpvbmVzRW5hYmxlZCI6dHJ1ZSwic3R1ZHlPdmVyQm91Z2h0VmFsdWUiOjgwLCJzdHVkeU92ZXJCb3VnaHRDb2xvciI6IiM3OWY0YmQiLCJzdHVkeU92ZXJTb2xkVmFsdWUiOjIwLCJzdHVkeU92ZXJTb2xkQ29sb3IiOiIjZmY4MDg0IiwiY2hhcnROYW1lIjoiY2hhcnQifX0sIuKAjEJvbGxpbmdlciBCYW5kc+KAjCAoQywyMCwyLG1hLHkpIjp7InR5cGUiOiJCb2xsaW5nZXIgQmFuZHMiLCJpbnB1dHMiOnsiRmllbGQiOiJDbG9zZSIsIlBlcmlvZCI6MjAsIlN0YW5kYXJkIERldmlhdGlvbnMiOjIsIk1vdmluZyBBdmVyYWdlIFR5cGUiOiJzaW1wbGUiLCJDaGFubmVsIEZpbGwiOnRydWUsImlkIjoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkiLCJkaXNwbGF5Ijoi4oCMQm9sbGluZ2VyIEJhbmRz4oCMIChDLDIwLDIsbWEseSkifSwib3V0cHV0cyI6eyJCb2xsaW5nZXIgQmFuZHMgVG9wIjoiI2ZmZGI0OCIsIkJvbGxpbmdlciBCYW5kcyBNZWRpYW4iOiIjZmZhMzNmIiwiQm9sbGluZ2VyIEJhbmRzIEJvdHRvbSI6IiNmZmJkNzQifSwicGFuZWwiOiJjaGFydCIsInBhcmFtZXRlcnMiOnsiY2hhcnROYW1lIjoiY2hhcnQifX19LCJ2IjoiMC4xLjAiLCJtaW4iOjF9
     
    // JUSTE LE COURS
     
     #eyJTWSI6W1siR0xFLlBBIixudWxsLDAsMF1dLCJUUyI6WzEsImRheSIsbnVsbCxudWxsXSwiVVMiOlswLDEsMV0sIkNTIjpbImxpbmUiLCJsaW5lYXIiLDgsbnVsbCxudWxsLCIjMDA4MWYyIl0sIlNUIjp7InZvbCB1bmRyIjp7InR5cGUiOiJ2b2wgdW5kciIsImlucHV0cyI6eyJpZCI6InZvbCB1bmRyIiwiZGlzcGxheSI6InZvbCB1bmRyIn0sIm91dHB1dHMiOnsiVXAgVm9sdW1lIjoiIzAwYjA2MSIsIkRvd24gVm9sdW1lIjoiI0ZGMzMzQSJ9LCJwYW5lbCI6ImNoYXJ0IiwicGFyYW1ldGVycyI6eyJoZWlnaHRQZXJjZW50YWdlIjowLjI1LCJ3aWR0aEZhY3RvciI6MC40NSwiY2hhcnROYW1lIjoiY2hhcnQifX19LCJ2IjoiMC4xLjAiLCJtaW4iOjF9
     

     
     
     */
	// Faire une requête sur cette URL
	//NSURLRequest *requestObject = [NSURLRequest requestWithURL:url_yahoo_dyn];
   // NSURLRequest *requestObject = [NSURLRequest requestWithURL:@"https://google.fr"];
    
    
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:[NSURL
                                                          
                                                          URLWithString:url_yahoo_dyn]
                             
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             
                                         timeoutInterval:60.0];
	// Charger la requête dans la UIWebView
    yahooWebview.scrollView.scrollEnabled =TRUE;
    yahooWebview.scalesPageToFit =TRUE;
	[yahooWebview loadRequest:requestObject];

    //[self performSegueWithIdentifier:@"showDetailValeur" sender:valeur];
    
}

//ON SELECTIONNE LE DETAIL 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
   //  NSLog(@"CLIC DETAIL");
   Valeurs *valeur_det  = [listVal objectAtIndex:indexPath.row];
  // NSLog(@"ON VEUT LE DETAIL DE LA VALEUR : %@",valeur_det.nom);
    
  [self.TableListVAL selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewRowAnimationTop];


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
        //NSString *cleanJson = [jsonStringB substringFromIndex:11];
        //cleanJson = [cleanJson substringToIndex:[cleanJson length]-2];
        
        //  NSDictionary *jsonResults= [cleanJson JSONValue];
        NSLog(@"jsonResults : %@", jsonStringB);
        
        SBJsonParser *parser = [SBJsonParser new];
        NSDictionary *parsedDictionary = [parser objectWithString:jsonStringB];
        NSMutableArray *JSON = [[parsedDictionary objectForKey:@"quoteResponse"]objectForKey:@"result"];
        NSDictionary *DictJson = [JSON objectAtIndex:0];
     

        //NSString *count_local = [parsedDictionary objectForKey:@"result"];
       // NSLog(@"COUNT STOCKINFO = %i",count_local);
               // SI marché fermé LastTradePriceOnly
        if (0==0) {
            //valeur.cotation = stockInfo[0];
            valeur.cotation =  [[DictJson valueForKey:@"regularMarketPrice"] stringValue];    //[0]["regularMarketPrice"];
            valeur.variation = [[DictJson valueForKey:@"regularMarketChangePercent"] stringValue] ;
            valeur.volumeEnc = [[DictJson valueForKey:@"regularMarketVolume"] stringValue];
            valeur.volumeMoy =[[DictJson valueForKey:@"averageDailyVolume3Month"] stringValue];
            valeur.dateMaj = [[DictJson valueForKey:@"regularMarketTime"] stringValue];
            valeur.heureMaj =   [[DictJson valueForKey:@"regularMarketTime"] stringValue];
            
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
	/*NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:30];
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
    

    */
    /*  graph = (CPTXYGraph *)[theme newGraph];
     
     graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
     graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
     
     */
    
   /* [graph applyTheme:theme];
    
    
    
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
    
    */
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
