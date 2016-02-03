//
//  Game.m
//  HoldemOrFoldem
//
//  Created by Seth on 10/6/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//

#import "Game.h"
#import "Card.h"

@implementation Game

-(instancetype) init
{
    self = [super init];
    _deck = [[NSMutableArray alloc] init];
    _myHand = [[hand alloc] init];
    for (NSInteger i = 0; i <= 51; i++)
    {
        [_deck addObject: [NSNumber numberWithInteger:i]];
    }
    return self;
}

+ (instancetype)sharedGameData {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void) shuffleDeck
{
    //walk up and swap each card with one of the other cards
    for (int i = 0; i < 52; i++)
    {
        int j = arc4random_uniform(52);
        [_deck exchangeObjectAtIndex:i withObjectAtIndex: j]/*swap with a value at a random index between 0 and 51*/;
    }
    [_myHand wipe]; //in case there's a hand, I didn't seem to need this method, but I'm not sure why since I don't see the hand ever being cleared
    _gameState = 0; //the shuffle can only occur before the game starts, ergo it can be used to set the state to pre-start
    
}

-(void) dealInitial //Sets the first two cards in the hand, changes the game state
{
    Card *c1 = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:0] integerValue]];
    Card *c2 = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:1] integerValue]];
    [_myHand handAdd:c1];
    [_myHand handAdd:c2];
    
    _gameState = 1;
}
-(void) dealFLop //Sets the third, fourth and fifth cards in the hand, changes the game state
{
    Card *c1 = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:2] integerValue]];
    Card *c2 = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:3] integerValue]];
    Card *c3 = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:4] integerValue]];
    [_myHand handAdd:c1];
    [_myHand handAdd:c2];
    [_myHand handAdd:c3];
    _gameState = 2;
}

-(void) dealTurn //Sets the sixth card in the hand, changes the game state
{
    Card *c = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:5] integerValue]];
    [_myHand handAdd:c];
    
    _gameState = 3;
}

-(void) dealRiver //Sets the seventh card in the hand, changes the game state
{
    Card *c = [[Card alloc] initWithInteger:[(NSNumber *) [ _deck objectAtIndex:6] integerValue]];
    [_myHand handAdd:c];
    
    _gameState = 4;
}
@end
