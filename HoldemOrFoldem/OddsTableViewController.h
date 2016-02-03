//
//  OddsTableViewController.h
//  HoldemOrFoldem
//
//  Created by Seth on 11/10/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hand.h"

@interface OddsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *hands; //List of hands you can possibly have

@property (nonatomic) hand * myHand; //Hand of cards to work with
@end
