//
//  OddsTableViewController.m
//  HoldemOrFoldem
//
//  Created by Seth on 11/10/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//

#import "OddsTableViewController.h"


@interface OddsTableViewController ()

@property (nonatomic) NSMutableArray * odds; //Array of odds for the hand, displayed as a percentage value rounded to the nearest tenth

@end

@implementation OddsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hands = [[NSArray alloc] initWithObjects:@"Straight Flush:", @"Four of a Kind:", @"Full House:", @"Flush:", @"Straight:", @"Three of a Kind:", @"Two Pair:", @"Pair:", nil];
    self.odds = _myHand.getOdds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.odds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     NSString* formattedNumber = [NSString stringWithFormat:@"%.01f%%", [[self.odds objectAtIndex:indexPath.row] floatValue]];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", [self.hands objectAtIndex:indexPath.row],formattedNumber];
   return cell;
}

@end

