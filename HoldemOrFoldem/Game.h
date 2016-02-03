//
//  Game.h
//  HoldemOrFoldem
//
//  Created by Seth on 10/6/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "hand.h"

@interface Game : NSObject

@property (nonatomic) NSMutableArray* deck; //An array of integers 0-51, each one representing a unique card
@property (nonatomic) hand * myHand; //The hand the player will be using
@property (nonatomic) int gameState; //The state the game is in, determines what certain functions do

-(instancetype) init; 
-(void) shuffleDeck; //Shuffles the deck
-(void) dealInitial; //deals the first two cards and allows the game to progress
-(void) dealFLop; //deals the next three cards and allows the game to progress
-(void) dealTurn; //deals the sixth card and allows the game to progress
-(void) dealRiver; //deals the seventh and final card and allows the game to progress

+(instancetype) sharedGameData; //Shared data that does not get wiped when the view that initializes it put out of focus


@end
