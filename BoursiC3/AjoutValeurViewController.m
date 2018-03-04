//
//  AjoutValeurViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 12/01/13.
//
//

#import "AjoutValeurViewController.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
@interface AjoutValeurViewController ()

@end


@implementation AjoutValeurViewController{
    NSMutableArray *listVal;
}

@synthesize delegate, TableListVAL, listValJSON,SearchBarValeurs;

//static NSString *yahooSymbolSearchURLString = @"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback";
static NSString *yahooSymbolSearchURLString = @"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback&lang=en-US";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    // Initializing Data Source
    self.listValJSON = [[NSMutableArray alloc] init];
    NSLog(@"COIN");
     listVal = [[NSMutableArray alloc] initWithCapacity:20];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    //listVal = [[NSMutableArray alloc] initWithCapacity:20];
    [listVal removeAllObjects];
    
    

    for ( int i=0; i< [self.listValJSON count]; i=i+1)
    {
        Valeurs *valeur = [Valeurs new];
        NSDictionary *listValDict3 = [self.listValJSON objectAtIndex:i];
        valeur.codeBourso = [listValDict3 objectForKey:@"codeIsin"];
        valeur.nom = [listValDict3 objectForKey:@"nomValeur"];
        
        NSString *str = valeur.nom;
        NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *newStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"%@", newStr);
        valeur.nom =newStr;
        [listVal addObject:valeur];
        NSLog(@"On ajoute %@ A listVal",valeur.nom);
        
        
    }
    
}

-(void) OnChercheValeur

{
    ///// NEW VERSION SERVEUR AVEC JSONCONNECT et sqlfunction.php
    
    //YAHOO VERSION
    
    NSString* URLString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback&lang=en-US",SearchBarValeurs.text];
    NSLog(@"ON BALANCE l URL : %@",URLString);
    
    /////////////////
    //ON MET L ECHANGE CLIENT SERVEUR DANS LE MIDDLE THREAD 
    /////////////////
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    
    //On execute la requete URL
    NSURLRequest* requestB = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    // On récupère le résultat de la requête JSON ( avec 6 lignes vides avt)
   
    NSData* responseB = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:nil];
    // On transforme le résultat en String de type NSASCII (TRAITEMENT SPECIFIQUE pour source leschos)
    NSString* jsonStringB = [[NSString alloc] initWithData:responseB encoding:NSASCIIStringEncoding];
    // Remove the jsonp callback
    NSString *cleanJson = [jsonStringB substringFromIndex:39];
	cleanJson = [cleanJson substringToIndex:[cleanJson length]-2];
    NSLog(@"REQUEST OK JSON");
    NSLog(@"cleanjson: %@", cleanJson);
    // On met le resultat en string et purgé des lignes vides dans un NSdictionnaire JSON
    //NSDictionary *jsonResults= [cleanJson JSONValue];
    //NSLog(@"jsonResults : %@", jsonResults);
    SBJsonParser *parser = [SBJsonParser new];
	NSDictionary *parsedDictionary = [parser objectWithString:cleanJson];
	NSMutableArray *JSON = [[parsedDictionary objectForKey:@"ResultSet"] objectForKey:@"Result"];
    
    self.listValJSON = JSON;
    
     NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
    
    
     [self TransfertJSONYAHOO_Vers_Objet_ListVal];
    
      /////////////////
      //ON GARDE L AFFICHAGE DANS LE MAIN THREAD
     /////////////////
        dispatch_async(dispatch_get_main_queue(), ^{
          // [self.activityIndicatorView stopAnimating];
          [self.TableListVAL setHidden:NO];
          [self.TableListVAL reloadData];
        });
   
    });
 
    
    
}


-(void) TransfertJSONYAHOO_Vers_Objet_ListVal
{
    
    //codeBourso = UBI;
    //codeIsin = FR0000054470;
    //deviseValeur = EUR;
    //idCompo = 1;
    //idValeur = 1;
    //nomValeur = UBISOFT
    
    //listVal = [[NSMutableArray alloc] initWithCapacity:20];
    [listVal removeAllObjects];
    
    for ( int i=0; i< [self.listValJSON count]; i=i+1)
    {
        Valeurs *valeur = [Valeurs new];
        NSDictionary *listValDict3 = [self.listValJSON objectAtIndex:i];
        valeur.codeBourso = [listValDict3 objectForKey:@"symbol"];
        valeur.nom = [listValDict3 objectForKey:@"name"];
        NSString *str = valeur.nom;
        NSData *data = [str dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
        NSString *newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", newStr);
        valeur.nom =newStr;
        
        valeur.codif = @"TICK";
       
        //symbol.symbol = [[symbols objectAtIndex:i] objectForKey:@"symbol"];
        //symbol.name = [[symbols objectAtIndex:i] objectForKey:@"name"];
        
        [listVal addObject:valeur];
       // NSLog(@"On ajoute %@ A listVal",valeur.nom);
        
    }
    
}

- (IBAction)cancel
{
    [self.delegate AjoutValeurViewControllerDidCancel:self];
    
}

- (IBAction)done
{
    
    //on prepare le nouvel objet a renvoyer a l'apellant ( delegate
    
  //  Valeurs *valeur =  [Valeurs new];
    //valeur.nom =@"NV";
  //  [self.delegate AjoutValeurViewController:self ajoutNouvelleValeur:valeur ];
   
  //  NSLog(@"On a cree et on envoie en retour la valeur %@" , valeur.nom);
   // [self.delegate AjoutValeurViewController:self ajoutNouvelleValeur:valeur ];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"The search text is: '%@'", searchBar.text);
    [searchBar resignFirstResponder];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"The search text is: '%@'", searchBar.text);
    
    
    [self OnChercheValeur];
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listVal && listVal.count) {
        return listVal.count;
    } else {
        return 0;
    }
}



////////////////////////
// REMPLISSAGE TABLEVIEW
////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ListofValeurs est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofALLValeurs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    //NSLog(@"IN TABLEVIEW AJOUT VALEUR");
    //NSLog(@"CONTENU LISTVAL = %@",listVal );
    
    
    Valeurs *valeur = [listVal objectAtIndex:indexPath.row];
    
    UILabel *labelValeur = (UILabel *)[cell viewWithTag:1000];
    //UILabel *labelCours = (UILabel *)[cell viewWithTag:2000];
    //UILabel *labelEvo = (UILabel *)[cell viewWithTag:3000];
    UILabel *labelISIN = (UILabel *)[cell viewWithTag:4000];
    
    //NSLog(@"VALEUR pour AJOUTVALEUR= %@", valeur.nom);
    labelValeur.text =  valeur.nom;
    labelISIN.text = valeur.codeBourso;
    
    
    //cell.textLabel.text = valeur.nom;
    
    //labelEvo.backgroundColor = [UIColor redColor];
    
   // NSLog(@"OUT TABLEVIEW AJOUT VALEUR");
    return cell;
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
*/

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


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    Valeurs *valeur =  [Valeurs new];
    
    
    NSLog(@"On clique sur une ligne");
    //[self.navigationController pushViewController:detailValeur animated:YES];
    static NSString *cellID = @"ListofValeurs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLog(@"On envoit la cellule: %@", cell);
    
    valeur  = [listVal objectAtIndex:indexPath.row]; 
    

    NSLog(@"On a cree et on envoie en retour la valeur %@" , valeur.nom);
    [self.delegate AjoutValeurViewController:self ajoutNouvelleValeur:valeur ];
    
}

- (void)viewDidUnload {
    //[self setIBSearchBarValeur:nil];
    [self setSearchBarValeurs:nil];
    [super viewDidUnload];
}
@end
