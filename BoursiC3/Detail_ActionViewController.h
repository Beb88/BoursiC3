//
//  Detail_ActionViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 27/09/12.
//
//

#import <UIKit/UIKit.h>
#import "Valeurs.h"

@interface Detail_ActionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *TextValo;

@property (nonatomic, strong) Valeurs *valeurs;

@end
