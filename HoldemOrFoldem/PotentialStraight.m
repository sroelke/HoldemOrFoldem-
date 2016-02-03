//
//  PotentialStraight.m
//  NewCardsTest
//
//  Created by Seth on 1/4/16.
//  Copyright (c) 2016 Seth Roelke. All rights reserved.
//

#import "PotentialStraight.h"

@implementation PotentialStraight

-(id) initWithInfo:(int)HV fourth:(bool)FC Required:(int)FR secondRequired:(int)SR
{
    self = [super init];
    self.highVal = HV;
    self.fourthCard = FC;
    self.firstReq = FR;
    self.secondReq = SR;
    return self;
}

-(void) output
{
    if (self.fourthCard == true)
    {
        NSLog(@"Potential straight's high value is: %d, and requires a %d to be dealt", self.highVal, self.firstReq);
    }
    else
    {
        NSLog(@"Potential straight's high value is: %d, and requires a %d and a %d to be dealt", self.highVal, self.firstReq, self.secondReq);
    }
}

-(bool) reqsUsed:(int)FR second:(int)SR
{
    return ((FR == self.firstReq && SR == self.secondReq) || (FR == self.secondReq && SR == self.firstReq));
}
@end
