//
//  AjoutValeurViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 12/01/13.
//
//

#import "AjoutValeurViewController.h"
#import "AFNetworking.h"

@interface AjoutValeurViewController ()

@end


@implementation AjoutValeurViewController{
    NSMutableArray *listVal;
}

@synthesize delegate, TableListVAL, listValJSON,SearchBarValeurs;


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
    
    
    // Initializing Data Source
    self.listValJSON = [[NSMutableArray alloc] init];
    NSLog(@"COIN");
     listVal = [[NSMutableArray alloc] initWithCapacity:20];
    
  /*
    //FLO
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.12:8888/wsgetValeurs.php"];
    //WAM
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wsgetValeurs.php"];
    // ARKKOX
    //NSURL *url = [NSURL URLWithString:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //On construit les parametres qui vont etre passes en POST de la requete
    //VERSION UTILISATEUR FLO  Parametre passé : idPtf =1
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"idPtf",
                            nil];
    
    //On interroge le serveur avec la requete
    //CHEWAM
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/wsgetValeurs.php"parameters:params];
    //FLO
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.0.12:8888/wsgetValeurs.php"parameters:params];
    //ARKKOX
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"parameters:params];
    
   */ 
    
    
    
    ///// NEW VERSION SERVEUR AVEC JSONCONNECT et sqlfunction.php
    
  
    //FLO
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.12:8888/jsonConnect.php"];
    //WAM
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/jssonConnect.php"];
    // ARKKOX
    //NSURL *url = [NSURL URLWithString:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"];
    
    
    
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //On construit les parametres qui vont etre passes en POST de la requete
    //VERSION UTILISATEUR FLO  Parametre passé : idPtf =1
   
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beb", @"user",
                            @"beb", @"password",
                            @"getAllValeurs", @"action",
                            @"iphone", @"source",
                            @"", @"nomValeur",
                            nil];
    
    //On interroge le serveur avec la requete
    //CHEWAM
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/jsonConnect.php"parameters:params];
    //FLO
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.0.12:8888/jsonConnect.php"parameters:params];
    //ARKKOX
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"parameters:params];

    
    
    
    ///END OF SERVEUR BCC VERSION
    
    
    //YAHOO VERSION
    
    
    //END OF YAHOO VERSION 
    
    
    
    //On recupere la reponse du serveur
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"REQUEST OK JSON");
        //NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        //On recupere l'objet MERE du JSON Renvoyé par le SERVEUR
        //self.listValJSON = [JSON objectForKey:@"VALEURS"];
        self.listValJSON = JSON;
        
        NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
        
        
        [self TransfertJSON_Vers_Objet_ListVal];
        
        
        // [self.activityIndicatorView stopAnimating];
        [self.TableListVAL setHidden:NO];
        [self.TableListVAL reloadData];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    [operation start];

    

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
        [listVal addObject:valeur];
        NSLog(@"On ajoute %@ A listVal",valeur.nom);
        
        
    }
    
}

-(void) OnChercheValeur

{
    ///// NEW VERSION SERVEUR AVEC JSONCONNECT et sqlfunction.php
    
    
    //FLO
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.12:8888/jsonConnect.php"];
    //WAM
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/jssonConnect.php"];
    // ARKKOX
    //NSURL *url = [NSURL URLWithString:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //On construit les parametres qui vont etre passes en POST de la requete
    //VERSION UTILISATEUR FLO  Parametre passé : idPtf =1
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beb", @"user",
                            @"beb", @"password",
                            @"getAllValeurs", @"action",
                            @"iphone", @"source",
                            SearchBarValeurs.text, @"nomValeur",
                            nil];
    
    //On interroge le serveur avec la requete
    //CHEWAM
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/jsonConnect.php"parameters:params];
    //FLO
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.0.12:8888/jsonConnect.php"parameters:params];
    //ARKKOX
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://arkkox.free.fr/Boursicoincoin/wsgetValeurs.php"parameters:params];
    
    
    
    
    ///
    
    
    
    //On recupere la reponse du serveur
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"REQUEST OK JSON");
        //NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
       //   NSLog(@"json count: %i, key: %@", [JSON count], [JSON valueLists] );
        
        //NSLog(@"json countForIbject : %i", [JSON countForObject:@"nomvaleur"]);

   
             self.listValJSON = JSON;
        
        NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
        
        
        [self TransfertJSON_Vers_Objet_ListVal];
        
        
        // [self.activityIndicatorView stopAnimating];
        [self.TableListVAL setHidden:NO];
        [self.TableListVAL reloadData];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    [operation start];

}



- (IBAction)cancel
{
    
    //   Valeurs *valeur = [Valeurs new];
    //= @"NV";//self.textField.text;
    //valeur.checked = NO;
    
    [self.delegate AjoutValeurViewControllerDidCancel:self];
    
    //Retour sur ecran precedent
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    
    NSLog(@"IN TABLEVIEW AJOUT VALEUR");
    NSLog(@"CONTENU LISTVAL = %@",listVal );
    
    
    Valeurs *valeur = [listVal objectAtIndex:indexPath.row];
    
    UILabel *labelValeur = (UILabel *)[cell viewWithTag:1000];
    //UILabel *labelCours = (UILabel *)[cell viewWithTag:2000];
    //UILabel *labelEvo = (UILabel *)[cell viewWithTag:3000];
    UILabel *labelISIN = (UILabel *)[cell viewWithTag:4000];
    
    NSLog(@"VALEUR pour AJOUTVALEUR= %@", valeur);
    labelValeur.text =  valeur.nom;
    labelISIN.text = valeur.codeBourso;
    
    
    //cell.textLabel.text = valeur.nom;
    
    //labelEvo.backgroundColor = [UIColor redColor];
    
    NSLog(@"OUT TABLEVIEW AJOUT VALEUR");
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
