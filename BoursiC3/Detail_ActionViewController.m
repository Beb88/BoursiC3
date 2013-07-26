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

@synthesize TableListAlert,TextNomAlert,delegate;

@synthesize TextValo,TextVolumeEnc,TextEvo,TextNomValeur;
@synthesize  valeurRecue,alertes_valeur,TextEtatAlert;

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
    NSLog(@"DEVISE%@",self.valeurRecue.devise);
    NSLog(@"COTATION%@",self.valeurRecue.cotation);
    NSLog(@"VOLUMeEnc%@",self.valeurRecue.volumeEnc);
    
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




-(void)Desinscription_Alerte_Serveur:(Valeurs_Alertes *)del_alert
{
    //1&1
    NSURL *url = [NSURL URLWithString:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    // new_alert.id_Valeur
    //new_alert.id_alerte
    // new_alert.param1
    // new_alert.nom_alerte
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"deleteAlert",@"action",
                            del_alert.id_alerte,@"idalert",
                            nil];// Autre param a envoyer
    
    
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"parameters:params];
    
    //MISE EN COMMENTAIRE EN VUE DE SUPPRESSION DE LECRAN et DU LOG
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
        NSLog(@"DESNSCRIPTION ALERTE OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Synchro serveur OK"
                                                            message:@"Desinscrition alerte"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR DESINCRIPTION ALERTE SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
    
    [operation start];
    
    
    
    
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



//SUPPRESSSION D UNE ALERTE
-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Valeurs_Alertes *alert_sup = [self.valeurRecue.listeAlertes objectAtIndex:indexPath.row];
    
    NSLog(@"ENVOIE AU SERVEUR SUPPRESSION ALERTE : ID_VAL =%@,  ID_ALERTE=%@,   NOM_ALERTE =%@, PARAM1 =%@ ", alert_sup.id_Valeur, alert_sup.id_alerte, alert_sup.nom_alerte, alert_sup.param1);
   
    
    //APPEL AU SERVEUR POUR SUPPRESSION
    [self Desinscription_Alerte_Serveur:alert_sup];
    
    // SUPPRESSION DE L ALERTE de L OBJET
    [self.valeurRecue.listeAlertes removeObjectAtIndex:indexPath.row];
   
    //SUPPRESSION de l alerte de la VUE
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
     [self.delegate SAV_ALERT:self];
     //[self savelistValeurs];
    
    
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
    
      
    
    Valeurs_Alertes *alerte_valeur = [self.valeurRecue.listeAlertes objectAtIndex:indexPath.row];
    
    NSLog(@"ALERTE %@ :   codeBourso=%@, ETAT=%@,  NOM_ALERTE =%@, PARAM1 =%@ , PARAM2 =%@ , PARAM3 =%@ , PARAM4 =%@ ", alerte_valeur.id_alerte, self.valeurRecue.codeBourso,alerte_valeur.etat_alerte, alerte_valeur.nom_alerte, alerte_valeur.param1,alerte_valeur.param2,alerte_valeur.param3,alerte_valeur.param4);
    

    
    
    UILabel *labelalert = (UILabel *)[cell viewWithTag:1000];
    
        
    NSString* compo=@"";
    //CUSTO AFFICHAGE POUR ALERTE SEUIL
    if (![alerte_valeur.param1 isEqual:@""]) {
         compo = [NSString stringWithFormat:@"%@%@", @"A + que : ",alerte_valeur.param1];
    } else if (![alerte_valeur.param3 isEqual:@""]) {
         compo = [NSString stringWithFormat:@"%@%@", @"A - que : ",alerte_valeur.param3];
    }
    
      UILabel *labelParam1 = (UILabel *)[cell viewWithTag:2000];

    ///NSLog(@"VALEUR = %@", valeur);
    labelalert.text =  alerte_valeur.nom_alerte;
    labelParam1.text =   compo;
    
    
    UITextView *TextfieldEtat = (UITextView *)[cell viewWithTag:3000];
    if ([alerte_valeur.etat_alerte isEqualToString:@"ON"]) {
        TextfieldEtat.backgroundColor = [UIColor greenColor];
    }
    else if ([alerte_valeur.etat_alerte isEqualToString:@"OFF"])
    {
         TextfieldEtat.backgroundColor = [UIColor grayColor];
    }
    else
         TextfieldEtat.backgroundColor = [UIColor orangeColor];
    
    
    //UILabel *labelParam2 = (UILabel *)[cell viewWithTag:3000];
    //UILabel *labelParam3 = (UILabel *)[cell viewWithTag:4000];
    NSLog(@"contenant la valeur= %@", alerte_valeur.id_alerte);
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
   
    
    
    /////////////////////////////////////////////////
    // A REMPLACER PAR GESTION DU indic.id_indic
    ////////////////////////////////////////////////
    
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
    
    
    [self.delegate SAV_ALERT:self];
    
  
    // cell.detailTextLabel.text.floatValue = newAlert.param1;
    [self dismissViewControllerAnimated:YES completion:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE SEUIL  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////


/// !!! ALERTE SEUIL
- (void)listeIndicTableView:(ListeIndicTableViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    NSLog(@"ON RECOIT DE LISTE INDIC LA NOUVELLE ALERTE : %@",newAlert);
  //  int newRowIndex = [self.valeurRecue.listeAlertes count];
   // NSLog(@"list alert count =  %i",newRowIndex);
       
   // GESTION D UN ECRAN D ALERTE POUVANT GENERER 2 ALERTES ( EX : SEUIL EN H et B )
    
    //SPECIFIC AUX ALERTES SEUIL (CAR SENS)
    if ([newAlert.param2 isEqual:@"ON"])
    {
        
        [self INSCRIPTION_ALERT:self envoiDemandeAlerte:newAlert pourUnSens:@"H"];
       
       /* [self.valeurRecue.listeAlertes addObject:newAlert];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        */
        //[self.delegate SAV_ALERT:self];
    }
    
    if ([newAlert.param4 isEqual:@"ON"])
    {
        
        Valeurs_Alertes *alerte_baisse=[[Valeurs_Alertes alloc] init];;
        
        //Copy ?
        
       
        alerte_baisse.id_Valeur = newAlert.id_Valeur;
        alerte_baisse.nom_alerte = newAlert.nom_alerte;
        alerte_baisse.id_indic = newAlert.id_indic;
        alerte_baisse.param1 = @"";
        alerte_baisse.param2 = @"";
        alerte_baisse.param3 = newAlert.param3;
        alerte_baisse.param4 = newAlert.param4;
        
        
        [self INSCRIPTION_ALERT:self envoiDemandeAlerte:alerte_baisse pourUnSens:@"B"];
       
        /*[self.valeurRecue.listeAlertes addObject:newAlert];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];*/
    }
 
   
    
    
    
    //[self.delegate SAV_ALERT:self];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}






- (void)INSCRIPTION_ALERT:(Detail_ActionViewController *)controller envoiDemandeAlerte:(Valeurs_Alertes *)newAlert pourUnSens:(NSString*)sens
{
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    // new_alert.id_Valeur
    //new_alert.id_alerte
    // new_alert.param1
    // new_alert.nom_alerte
    // NSLog(@"Valeur passé pour creation d alerte : %@", new_alert.cod );
    //LES PARAM PASSES EN POST
    
    
    
    NSLog(@"ENVOIE AU SERVEUR INCRIPTION ALERTE SUR VALEUR ID_VAL =%i,  codeBourso=%@,   NOM_ALERTE =%@, PARAM1 =%@ , PARAM2 =%@ , PARAM3 =%@ , PARAM4 =%@ ", self.valeurRecue.idValeur, self.valeurRecue.codeBourso, newAlert.nom_alerte, newAlert.param1,newAlert.param2,newAlert.param3,newAlert.param4);
    
    
    //GOOD ONE
    NSDictionary *params = nil;
    //SPECIFIC AUX ALERTES SEUIL (CAR SENS)
    
    if ([sens isEqual:@"H"]) // ALERTE A LA HAUSSE
    {
        
    
     params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"setNewAlert",@"action",
                            self.valeurRecue.codeBourso, @"codeyf",
                            @"2", @"idindic", //1 ou 2(seuil)
                            @"notif", @"typealert", //notif ou mail
                            newAlert.nom_alerte, @"namealert",
                            newAlert.param1, @"seuil", //
                            sens, @"sens", // H ou B
                            @"0", @"volume",///
                            nil];// Autre param a envoyer
    
    }
    else if ([sens isEqual:@"B"])  //ALERTE A LA BAISSE
             {
                 params = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"beblouis@gmail.com", @"user",
                                         @"beb", @"password",
                                         @"setNewAlert",@"action",
                                         self.valeurRecue.codeBourso, @"codeyf",
                                         @"2", @"idindic", //1 ou 2(seuil)
                                         @"notif", @"typealert", //notif ou mail
                                         newAlert.nom_alerte, @"namealert",
                                         newAlert.param3, @"seuil", //
                                         sens, @"sens", // H ou B
                                         @"0", @"volume",///
                                         nil];// Autre param a envoyer

             }
    //TEST ONE
   /* NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beb", @"user",
                            @"beb", @"password",
                            @"test",@"action",
                            nil];// Autre param a envoyer
*/
    
    
    
    
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"parameters:params];
    
    
    
    //MISE EN COMMENTAIRE EN VUE DE SUPPRESSION DE LECRAN et DU LOG
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
        NSLog(@"INSCRIPTION ALERTE OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        NSString *id_alert_recup =   [JSON objectForKey:@"result"];
        
        newAlert.id_alerte=id_alert_recup;
        newAlert.etat_alerte = @"ON";

        NSLog(@"alerte.id_alerte=%@",newAlert.id_alerte);

        int newRowIndex = [self.valeurRecue.listeAlertes count];
         NSLog(@"list alert count =  %i",newRowIndex);
        
        
        NSString *SAVparam1=@"";
        NSString *SAVparam2=@"";
        NSString *SAVparam3=@"";
        NSString *SAVparam4=@"";
        
        SAVparam1 = newAlert.param1;
        SAVparam2 = newAlert.param2;
        SAVparam3 = newAlert.param3;
        SAVparam4 = newAlert.param4;
        
        
        if ([sens isEqual:@"H"])// ALERTE A LA HAUSSE
        {
           
            newAlert.param3 =@"";
            newAlert.param4 =@"";
            
            [self.valeurRecue.listeAlertes addObject:newAlert];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.delegate SAV_ALERT:self];
            
            newAlert.param4 = SAVparam4 ;
            newAlert.param3 = SAVparam3 ;
            
            
            
        }
        else if ([sens isEqual:@"B"])  //ALERTE A LA BAISSE
        {
            
            
            newAlert.param1 =@"";
            newAlert.param2 =@"";
            [self.valeurRecue.listeAlertes addObject:newAlert];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.TableListAlert insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.delegate SAV_ALERT:self];
            newAlert.param1 = SAVparam1 ;
            newAlert.param2 =  SAVparam2 ;
         
            
        }
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte Seuil crée "
                                                            message:newAlert.id_alerte
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR INSCRIPTION ALERTE SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
    
    [operation start];
    
    
        
    
}



//RETOUR MODIF ALERTE SEUIL


- (void)alertSeuilViewController:(AlerteSeuilViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert{
    
    int index = [self.valeurRecue.listeAlertes indexOfObject:newAlert];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.TableListAlert cellForRowAtIndexPath:indexPath];
    
    UILabel *labelParam1 = (UILabel *)[cell viewWithTag:2000];
    
    
    
    UILabel *labelalert = (UILabel *)[cell viewWithTag:1000];
    NSString* compo=@"";
    
    NSLog(@"param 1 = %@  , param3 = %@   ", newAlert.param1, newAlert.param3);
    
    
    //CUSTO DU LIBELLE POUR ALERTE SEUIL
       if (![newAlert.param1 isEqual:@""]) {
        compo = [NSString stringWithFormat:@"%@%@", @"A + que : ",newAlert.param1];
    } else if (![newAlert.param3 isEqual:@""]) {
        compo = [NSString stringWithFormat:@"%@%@", @"A - que : ",newAlert.param3];
    }
    
    if ([newAlert.param2 isEqualToString:@"ON"]) {
            newAlert.etat_alerte = @"ON";
    }
    else if ([newAlert.param4  isEqualToString:@"ON"])
    {
        newAlert.etat_alerte = @"ON";
    }
    else newAlert.etat_alerte = @"OFF";
    
    
    
    UITextView *TextfieldEtat = (UITextView *)[cell viewWithTag:3000];
    if ([newAlert.etat_alerte isEqualToString:@"ON"]) {
        TextfieldEtat.backgroundColor = [UIColor greenColor];
    }
    else if ([newAlert.etat_alerte isEqualToString:@"OFF"])
    {
        TextfieldEtat.backgroundColor = [UIColor grayColor];
    }
    else
        TextfieldEtat.backgroundColor = [UIColor blackColor];

    
    
    ///NSLog(@"VALEUR = %@", valeur);
    labelalert.text =  newAlert.nom_alerte;
    labelParam1.text =   compo;
    
    
    
    [self.delegate SAV_ALERT:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


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






@end
