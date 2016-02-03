//
//  oddsFlopStraight.h
//  NewCardsTest
//
//  Created by Seth on 1/13/16.
//  Copyright (c) 2016 Seth Roelke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "PotentialStraight.h"

@interface oddsFlopStraight : NSObject

@property (nonatomic) float odds;
@property (nonatomic) bool SF;


-(id) initWithInfo: (NSMutableArray * ) cards straightFlush: (bool) straightFlush;
-(float) analyze; //analyzes the hand for the odds of potential straights, returns the odds

@end
