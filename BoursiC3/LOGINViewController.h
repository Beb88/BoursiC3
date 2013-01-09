//
//  LOGINViewController.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOGINViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *TextLOG;
@property (strong, nonatomic) IBOutlet UITextField *TextPWD;

@property (strong, nonatomic) NSString *TextID;

@property (strong,nonatomic) NSString *LOGID;
@end
