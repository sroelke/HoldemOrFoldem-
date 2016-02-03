//
//  hand.h
//  CardsTest
//
//  Created by Seth on 4/29/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//
//  See cardstest for up-to-date documentation

#import <Foundation/Foundation.h>
#import "Card.h"
#import "oddsFlopStraight.h"

@interface hand : NSObject

@property (nonatomic) int handStr; //Strength of the hand, with 9 being the highest, and 1 being the lowest
@property (nonatomic) NSMutableArray * cards; //Array of cards
@property (nonatomic) NSMutableArray * odds; //Array of floating-point values for the percentage of you getting a specific hand, filled descending by hand Strength
@property (nonatomic) NSMutableArray * cardsSorted; //sorted copy of cards, to check hands with
-(instancetype) init; //initializes an empty hand
-(void)handCalc; //Calculates the strength of your hand if it's at six or seven cards, and if it's at six cards, it calculates the odds of getting other hands, eventually calculate at five
-(void)handAdd: (Card *) c; //adds a card to cards, does not add duplicate cards
-(void)output; //outputs the information of the hand including every card in the hand, the hand's strength, the number of cards, and the odds for every hand higher than what you have
-(NSArray *) getCards; //returns the array of cards for outside use
-(NSArray *) getOdds; //returns the array of odds for outside use, odds are un-rounded percentage values
-(void) wipe; //resets all the properties to deal in a fresh hand
-(int) getHandStr; // returns only handStr
@end
