//
//  FirstViewController.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
NSArray *_ArraylistPTF;
}
@property (weak, nonatomic) IBOutlet UITableView *ListPTF;
@property (nonatomic, retain) NSArray *ArraylistPTF;

@end
