//
//  SecondViewController.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
NSArray *_listVal;
    
}
@property (weak, nonatomic) IBOutlet UITableView *TableListVAL;
@property (nonatomic, retain) NSArray *listVal;
@end
