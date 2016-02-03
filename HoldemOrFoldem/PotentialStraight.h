//
//  PotentialStraight.h
//  NewCardsTest
//
//  Created by Seth on 1/4/16.
//  Copyright (c) 2016 Seth Roelke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotentialStraight : NSObject

@property (nonatomic) int highVal; //the highest value of the straight
@property (nonatomic) bool fourthCard; //whether or not this straight has a fourth card already dealt
//@property (nonatomic) int fourthCardReq; //the value required for this potential straight with a fourth
@property (nonatomic) int firstReq; //the first required value to be dealt for a straight, can also be the only value if four cards in the straight were dealt
@property (nonatomic) int secondReq; //the second required value to be dealt for a straight, can be zero

-(void) output; //tells whether the Potential Straighthas four cards, its high value, and what its requirements are.


-(id) initWithInfo: (int) HV fourth: (bool) FC Required: (int) FR secondRequired: (int) SR; //creates a potential straight with the info provided

-(bool) reqsUsed: (int) FR second: (int) SR;

//hand first get an array of these, then discounts any who have requirements that are the same as fourthcardreq, and there can be at most only one fourthcardreq    

@end
