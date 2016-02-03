//
//  Card.m
//  CardsTest
//
//  Created by Seth on 4/29/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//
//  See cardstest for up-to-date documentation

#import "Card.h"

@implementation Card

//do the getters and init
-(instancetype) initWithInteger: (NSInteger) cardNum {
    self = [super init];
    if (cardNum < 0) //this condition will not occur in the current build unless the code is tampered with
        cardNum *= -1;
    
    switch (cardNum % 4) { //assigns the card's suit by its modulo of 4
        case 0:
            _suit = 'C';
            break;
        case 1:
            _suit = 'S';
            break;
        case 2:
            _suit = 'H';
            break;
        case 3:
            _suit = 'D';
            break;
        default:
            break;
    }
    _val = ((cardNum % 13) +2); //assigns the card's value by its modulo of 13
    //This leads to 52 unique outcomes
    return (self);
    
}

-(instancetype) initWithInfo: (int) value suit:(char) s 
{
    self = [super init];
    _val = value;
    _suit = s;
    return (self);
}

-(int) getVal
{
    return self.val;
}
-(char) getSuit
{
    return self.suit;
}
-(void) output
{
    NSLog(@"%d%c",_val, _suit);
}


@end
