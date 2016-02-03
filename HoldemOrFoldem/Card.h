//
//  Card.h
//  CardsTest
//
//  Created by Seth Roelke on 4/29/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//
//  See cardsTest for up-to-date documentation
#import <Foundation/Foundation.h>

@interface Card : NSObject
//getters and setters

@property (nonatomic) int val;
@property (nonatomic) char suit;

-(instancetype) initWithInfo: (int) value suit:(char) s; //initializes a card given a suit and a value -- not used in current build
-(instancetype) initWithInteger: (NSInteger) cardNum; //initializes a card given a number 0-51
-(int) getVal; //Returns the value -- not needed due to a misunderstanding on how objective-c classes work
-(char) getSuit; //Returns the suit -- not needed due to a misunderstanding on how objective-c classes work
-(void) output; //outputs card info to NSLog


@end
