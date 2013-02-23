//
//  Detail_ActionViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 27/09/12.
//
//

#import "Detail_ActionViewController.h"
#import "AFNetworking.h"
#import "SBJson.h"





@interface Detail_ActionViewController ()
{
NSMutableArray *listalert;	 // NE SERT PLUS NORMALEMENT
}


@end

@implementation Detail_ActionViewController

@synthesize TableListAlert,TextNomAlert;

@synthesize TextValo,TextVolumeEnc,TextEvo,TextNomValeur;
@synthesize  valeurRecue,alertes_valeur;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}				

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.valeurRecue.codeBourso);
    NSLog(@"ON a RECU LA VALEUR (nom)%@",self.valeurRecue.nom);
    TextNomValeur.text = self.valeurRecue.nom;
    NSLog(@"%@",self.valeurRecue.devise);
    NSLog(@"%@",self.valeurRecue.cotation);
    NSLog(@"%@",self.valeurRecue.volumeEnc);
    
    
       /*
    NSString* URLString = [NSString stringWithFormat:@"%@%@%@", @"http://bourse.lesechos.fr/bourse/streaming/fiches/getHeader.jsp?code=", self.valeurs.codeBourso,@"&place=XPAR&codif=ISIN"];*/
    
    // MARCHE US place =XNAS  codif=TICK
    
    //On construit la requete URL en fonction de la valeur passée
  /*  NSString* URLString = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"http://bourse.lesechos.fr/bourse/streaming/fiches/getHeader.jsp?code=",self.valeurRecue.codeBourso,@"&place=",self.valeurRecue.place,@"&codif=",self.valeurRecue.codif];
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
   */
    //On met à jour l'affichage
    
  //  TextValo.text = [ cotation objectForKey:@"valorisationEnc" ];
   // TextEvo.text = [ cotation objectForKey:@"variation" ];
    
    TextValo.text = self.valeurRecue.cotation;
    TextEvo.text = self.valeurRecue.variation;
    TextVolumeEnc.text = self.valeurRecue.volumeEnc;
    
    if (TextEvo.text.doubleValue>0)
    {
        NSLog(@"VERT");
       TextEvo.backgroundColor = [UIColor greenColor];
    }
    else 
    {
         NSLog(@"ROUGE");
        TextEvo.backgroundColor = [UIColor redColor];
    }
    
    //Fonction de test de remplissage automatique de l'objet list
    
    //if (self.valeurRecue.listeAlertes =nil)
    //[self complete_listalert];
    
    //listalert= self.valeurRecue.listeAlertes;
    
    //self.valeurRecue.listeAlertes = listalert;
   /* Valeurs_Alertes *testinsertalert;
    testinsertalert.nom_alerte =@"POT";
    [listalert addObject:testinsertalert];
    */
    
   
    /* pour gerer des listes (pour plus tard
     
     // Check if there is an error
     if (jsonResults == nil) {
     
     NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
     
     } else {
     
     NSArray *candiesList;
     NSDictionary *bakery = [ jsonResults objectForKey:@"bakery" ];
     NSLog(@"Nom : %@", [ bakery objectForKey:@"name" ]);
     NSLog(@"Adresse : %@", [ bakery objectForKey:@"adress" ]);
     NSLog(@"Bonbons :");
     candiesList = [ [ bakery objectForKey:@"candies" ] objectForKey:@"candy" ];
     for (NSDictionary *candy in candiesList) {
     
     NSLog(@"\tNom=%@ et Prix=%@", [ candy objectForKey:@"name" ],
     [ candy objectForKey:@"price" ]);
     
     }
     
     }
     
     */
    
    
    self.TableListAlert.dataSource = self;
    self.TableListAlert.delegate = self;
    
    //CUSTO GRAPHIQUE
    //self.TableListAlert.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"nav-bar.png"]];
    //[self.tableView setBackgroundView:nil];
    //[self.tableView setBackgroundColor: [UIColor blackColor]];
    
    // [self.activityIndicatorView stopAnimating];
    [self.TableListAlert setHidden:NO];
    [self.TableListAlert reloadData];

    
    
    
    
}




-(void) complete_listalert
{
    
    //codeBourso = UBI;
    //codeIsin = FR0000054470;
    //deviseValeur = EUR;
    //idCompo = 1;
    //idValeur = 1;
    //nomValeur = UBISOFT
    
    //listalert = [[NSMutableArray alloc] initWithCapacity:20];
    self.valeurRecue.listeAlertes = [[NSMutableArray alloc] initWithCapacity:20];
   
        Valeurs_Alertes *alert = [Valeurs_Alertes new];
        
        alert.nom_alerte = @"Seuil";
        alert.param1 = @"8";
     //   [listalert addObject:alert];
    [self.valeurRecue.listeAlertes addObject:alert];
        NSLog(@"On ajoute %@ A listalert",alert.nom_alerte);
    
    
    Valeurs_Alertes *alert2 = [Valeurs_Alertes new];

    alert2.nom_alerte = @"Volumetrie";
    alert2.param1 = @"100000";
   // [listalert addObject:alert2];
    [self.valeurRecue.listeAlertes addObject:alert2];
    NSLog(@"On ajoute %@ A listalert",alert.nom_alerte);
    
    
    
}



//////////////////////////////////////////////////////////////
//          Table View Data Source Methods
//////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   //
    if (self.valeurRecue.listeAlertes && self.valeurRecue.listeAlertes.count) {
        return self.valeurRecue.listeAlertes.count;
    } else {
        return 0;
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.valeurRecue.listeAlertes removeObjectAtIndex:indexPath.row];
    
    //[self savelistValeurs];
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


////////////////////////
// REMPLISSAGE TABLEVIEW
////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ListofValeurs est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofAlertes";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSLog(@"IN TABLEVIEW listAlert");
    NSLog(@"CONTENU listAlert = %@",self.valeurRecue.listeAlertes );
    
    /*
     //VISU CONTENU D UN DICTIONNAIRE
     NSEnumerator *enumerator = [ listValDict keyEnumerator];
     NSString *key;
     while (key = [ enumerator nextObject]) {
     printf("%s\n", [[ listValDict objectForKey:key] UTF8String]);
     }
     //FIN //VISU CONTENU D UN DICTIONNAIRE
     */
    
    
    Valeurs_Alertes *alerte_valeur = [self.valeurRecue.listeAlertes objectAtIndex:indexPath.row];
    
    
    
    UILabel *labelalert = (UILabel *)[cell viewWithTag:1000];
    UILabel *labelParam1 = (UILabel *)[cell viewWithTag:2000];
    //UILabel *labelParam2 = (UILabel *)[cell viewWithTag:3000];
    //UILabel *labelParam3 = (UILabel *)[cell viewWithTag:4000];
    
    
     NSString* compo = [NSString stringWithFormat:@"%@%@", @"à + que : ",alerte_valeur.param1];
    ///NSLog(@"VALEUR = %@", valeur);
    labelalert.text =  alerte_valeur.nom_alerte;
    labelParam1.text =   compo;
    // labelParam2.text = alerte_valeur.param2;
    // labelParam3.text = alerte_valeur.param3;
    
    //labelEvo.backgroundColor = [UIColor redColor];
    
    NSLog(@"OUT TABLEVIEW listalert");
    return cell;
}

///////////////////////////////////////////////////////////////////////
//          PASSAGE SUR ECRAN INDICATEUR EN FONCTION DE CELUI CHOISI
///////////////////////////////////////////////////////////////////////

//On SELECTIONNE UNE LIGNE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* NSLog(@"On clique sur une ligne");
    //[self.navigationController pushViewController:detailValeur animated:YES];
    static NSString *cellID = @"ListofAlertes";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLog(@"On clic la cellule: %@", cell);
    
    Valeurs_Alertes *alerte_choisie  = [self.valeurRecue.listeAlertes objectAtIndex:indexPath.row];
    
    NSLog(@"On clic l indic: %@", alerte_choisie.nom_alerte);
    
    if ([alerte_choisie.nom_alerte isEqualToString: @"Seuil"])
    {
       NSLog(@"ON PASSE LA VALEUR : %@",alerte_choisie.nom_alerte );
        [self performSegueWithIdentifier:@"VersEcranAlerteurSeuil" sender:alerte_choisie];
    }
    else if ([alerte_choisie.nom_alerte isEqualToString: @"Volumetrie"])
    {
        NSLog(@"ON PASSE LA VALEUR : %@",alerte_choisie.nom_alerte );
        [self performSegueWithIdentifier:@"VersEcranAlerteurVolum" sender:alerte_choisie];
        
    }
   */
    
    static NSString *cellID = @"ListofAlertes";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Valeurs_Alertes *indic = [self.valeurRecue.listeAlertes objectAtIndex:indexPath.row];
    //UILabel *labelIndic = (UILabel *)[cell viewWithTag:1000];
    
    
    if ([indic.nom_alerte isEqualToString:@"Seuil" ]) {
        
        
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AS"];
        
        AlerteSeuilViewController *controller = (AlerteSeuilViewController *)navigationController;
        controller.delegateAlertSeuil = self;
        controller.AlertToEdit= indic;
        
        //Checklist *checklist = [lists objectAtIndex:indexPath.row];
        //controller.checklistToEdit = checklist;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    
    
    if ([indic.nom_alerte isEqualToString:@"Volumetrie"])
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AV"];
        
        AlerteVolumeViewController *controller = (AlerteVolumeViewController *)navigationController;
        
        controller.delegateAlertVolume = self;
        controller.AlertToEdit= indic;
        
        
        //Checklist *checklist = [lists objectAtIndex:indexPath.row];
        //controller.checklistToEdit = checklist;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }

    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
  
    NSLog(@"prepareForSegue");
    
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
    
   /* if ([segue.identifier isEqualToString:@"VersEcranListeIndic"]) {
       ListeIndicTableViewController *controller = segue.destinationViewController;
        controller.valeurInEcranListeindic = nil;
    
    // ChecklistViewController *controller = segue.destinationViewController;
       controller.checklist = sender;
    //
    
    
    }
    */
    
    
    if ([segue.identifier isEqualToString:@"VersAlerteGeneral"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        IndicateursViewController *controller = (IndicateursViewController *)navigationController.topViewController;
        controller.delegateIG = self;
        controller.AlertToEdit = nil;
        controller.labelValeur.text = self.valeurRecue.nom;
    }
   
    if ([segue.identifier isEqualToString:@"VersEcranListeIndic"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ListeIndicTableViewController *controller = (ListeIndicTableViewController *)navigationController.topViewController;
        controller.delegateListeIndic = self;
        //controller.AlertToEdit = nil;
        //controller.labelValeur.text = self.valeurRecue.nom;
    }
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN INDICATEUR GENERAUX  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextValo:nil];
    [self setTextVolumeEnc:nil];
    [self setTextEvo:nil];
    [self setTe:nil];
    [self setTextNomValeur:nil];
    [super viewDidUnload];
}

- (void)indicateursViewController:(IndicateursViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    NSLog(@"ON RECOIT LA NOUVELLE ALERTE : %@",newAlert);
    int newRowIndex = [self.valeurRecue.listeAlertes count];
    NSLog(@"list alert count =  %i",newRowIndex);
    [self.valeurRecue.listeAlertes addObject:newAlert];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)indicateursViewControllerDidCancel:(IndicateursViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)indicateursViewController:(IndicateursViewController *)controller didFinishEditingChecklist:(Valeurs_Alertes *)newAlert
{
    int index = [self.valeurRecue.listeAlertes indexOfObject:newAlert];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.TableListAlert cellForRowAtIndexPath:indexPath];
    
    //cell.textLabel.text = newAlert.nom_alerte;
    
    [self.valeurRecue.listeAlertes addObject:newAlert];
    
    NSLog(@"SAV");

    
    
    
    
    // cell.detailTextLabel.text.floatValue = newAlert.param1;
    [self dismissViewControllerAnimated:YES completion:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE SEUIL  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)listeIndicTableView:(ListeIndicTableViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    NSLog(@"ON RECOIT DE LISTE INDIC LA NOUVELLE ALERTE : %@",newAlert);
    int newRowIndex = [self.valeurRecue.listeAlertes count];
    NSLog(@"list alert count =  %i",newRowIndex);
    [self.valeurRecue.listeAlertes addObject:newAlert];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



//RETOUR MODIF ALERTE SEUIL 


- (void)alertSeuilViewController:(AlerteSeuilViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert{
    
    int index = [self.valeurRecue.listeAlertes indexOfObject:newAlert];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.TableListAlert cellForRowAtIndexPath:indexPath];
    
    UILabel *labelParam1 = (UILabel *)[cell viewWithTag:2000];
    labelParam1.text =   newAlert.param1;
    
     [self dismissViewControllerAnimated:YES completion:nil];



}





@end
