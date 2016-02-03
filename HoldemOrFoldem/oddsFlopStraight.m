//
//  oddsFlopStraight.m
//  NewCardsTest
//
//  Created by Seth on 1/13/16.
//  Copyright (c) 2016 Seth Roelke. All rights reserved.
//


/*
 PrevVals is an array that tracks the previous values and requires any strait to not need a previous value, to prevent redundancy
 the problem is that it doesn't check suit
 prevSuits could work as well, if prevVals in index X
 if SF == true, if index...
 alternatively, make it an array of cards
 */
#import "oddsFlopStraight.h"

@interface oddsFlopStraight ()

@property (nonatomic) NSMutableArray* cards;
@property (nonatomic) NSMutableArray* potentialStraights;
@property (nonatomic) NSMutableArray* prevVals; //does this need to be global?
@property (nonatomic) int firstFourth;
@property (nonatomic) int secondFourth;


@end

@implementation oddsFlopStraight

-(id) initWithInfo: (NSMutableArray * ) cards straightFlush: (bool) straightFlush
{
    self = [super init];
    _cards = [[NSMutableArray alloc] initWithArray: cards];
    _SF = straightFlush;
    _potentialStraights = [[NSMutableArray alloc] init];
    _firstFourth = 0;
    _secondFourth = 0;
    _prevVals = [[NSMutableArray alloc] init];//an array of previous values, to prevent straights that require values already dealt
    return self;
}

-(float) analyze //analyzes the hand and creates odds
{
    [self getWheel];
    [self getPotentialStraights];
    [self makeOdds];
    return _odds;
}
-(void) getWheel
{
    //Variables related to the card in question
    bool haveAce = false;
    bool haveTwo = false;
    bool haveThree = false;
    bool haveFour = false;
    bool haveFive = false;
    int totalWheelCards = 0;
    char suit = 'c'; //used only in straightFlush
    int firstReq = 0;
    int secondReq = 0; //these variables will see a lot of use, but their value doesn't need to be global like the fourths
    
    for (int i = 0; i < [_cards count]; i++) //finds wheel straight if possible
    {
        //for suit-checking this, we will have to run this again in multiple suits
        Card *c= [_cards objectAtIndex:i];
        if ([c getVal] == 2 && haveTwo == false && (_SF == false || [c getSuit] == suit))
        {
            totalWheelCards++;
            haveTwo = true;
        }
        if ([c getVal] == 3 && haveThree == false && (_SF == false || [c getSuit] == suit))
        {
            totalWheelCards++;
            haveThree = true;
        }
        if ([c getVal] == 4 && haveFour == false && (_SF == false || [c getSuit] == suit))
        {
            totalWheelCards++;
            haveFour = true;
        }
        if ([c getVal] == 5 && haveFive == false && (_SF == false || [c getSuit] == suit))
        {
            totalWheelCards++;
            haveFive = true;
        }
        if ([c getVal] == 14 && haveAce == false && (_SF == false || [c getSuit] == suit))
        {
            totalWheelCards++;
            haveAce = true;
        }
        if (i == ([_cards count] - 1) && _SF == true && totalWheelCards < 3) //trying different suits as a straight flush if no potential straight was found
        {
            switch (suit) {
                case 'c':
                {
                    i = -1; //this is so that it increments to 0 after the loop
                    suit = 's';
                    haveAce = false;
                    haveTwo = false;
                    haveThree = false;
                    haveFour = false;
                    haveFive = false;
                    totalWheelCards = 0;
                    break;
                }
                case 's':
                {
                    i = -1;
                    suit = 'd';
                    haveAce = false;
                    haveTwo = false;
                    haveThree = false;
                    haveFour = false;
                    haveFive = false;
                    totalWheelCards = 0;
                    break;
                }
                case 'd':
                {
                    i = -1;
                    suit = 'h';
                    haveAce = false;
                    haveTwo = false;
                    haveThree = false;
                    haveFour = false;
                    haveFive = false;
                    totalWheelCards = 0;
                    break;
                }
                //does not do anything for 'h'
                default:
                    break;
            }
        }
    }
    //figuring out the requirements for a potential straight -- none of this matters if there is no potential at all
    if (totalWheelCards >= 3)
    {
        if (haveTwo == false)
            firstReq = 2;
        if (haveThree == false)
        {
            if (firstReq == 0)
                firstReq = 3;
            else
                secondReq = 3;
        }
        if (haveFour == false)
        {
            if (firstReq == 0)
                firstReq = 4;
            else
                secondReq = 4;
        }
        if (haveFive == false)
        {
            if (firstReq == 0)
                firstReq = 5;
            else
                secondReq = 5;
        }
        if (haveAce == false)
        {
            if (firstReq == 0)
                    firstReq = 14;
            else
                secondReq = 14;
        }
        if (totalWheelCards == 3)
        {
            //create a wheel straight with 3 cards
            [_potentialStraights addObject:[[PotentialStraight alloc] initWithInfo:5 fourth:false Required:firstReq secondRequired:secondReq]];
        }
        if (totalWheelCards == 4)
        {
            [_potentialStraights addObject:[[PotentialStraight alloc] initWithInfo:5 fourth:true Required:firstReq secondRequired:0]];
            _firstFourth = firstReq;
        }

        
    }
   
}
-(void) getPotentialStraights
{
    //loop-related variables
    int counter;
    bool seq; //if we are still in a valid sequence
   
    //card and array-related variables
    int pos; //position in the array of the card presently being worked with
    int nextPos; //position of the next card, used for straight flush detection
    Card * c; //card presently being worked with
    Card * nextCard; //the next card that will be worked with
    Card * nextSFCard; //a special card for straight flush comparisons
    int origVal; //value of the starting card in the search
    int finalVal = 0; //the final compared card value
    int nextVal; //the value of nextCard
    char suit; //suit the loops will be looking for in a straight flush

    //potential straight-related variables
    bool fourthCard; //whether or not there is a fourth card
    int firstReq = 0;
    int secondReq = 0;
    
    Card * origCard; //put into prevVals
    
    for (int i = 0; i < 3; i++)
    {
        //required initializations
        suit = [[_cards objectAtIndex: i] getSuit];
        origVal = [[_cards objectAtIndex: i] getVal];
        c = [_cards objectAtIndex:i];
        origCard = c;
        counter = 0;
        seq = true;
        pos = i;
        fourthCard = false;
        nextPos = i;
        firstReq = 0;
        secondReq = 0;
        
        while (seq && pos < [_cards count] -1 && counter < 2)
        {
            
            c = [_cards objectAtIndex:pos];
            nextCard = [_cards objectAtIndex: pos+1];
            nextPos = nextPos + 1;
            nextVal = [nextCard getVal];
            
            if (([c getVal] - nextVal) == -1 && (_SF == false || [nextCard getSuit] == suit)) //increment the counter with no strings attached if it's a difference of one number
            {
                counter++;
                finalVal = nextVal;
            }

            else if ([c getVal] == nextVal || firstReq == nextVal || secondReq == nextVal) //if two of the same value are encountered
            {
                //just keeps going
            }
            else if (firstReq == 0 && (([c getVal] - nextVal) == -2) && (_SF == false || [nextCard getSuit] == suit)) //uses one skip
            {
                firstReq = [c getVal] +1;
                counter++;
                finalVal = nextVal;
            }
            
            else if (firstReq == 0 && (([c getVal] - nextVal) == -3) && (_SF == false || [nextCard getSuit] == suit)) //uses both skips
            {
                firstReq = [c getVal] +1;
                secondReq = firstReq +1;
                counter++;
                finalVal = nextVal;
            }
        
            else if (firstReq > 0 && (([c getVal] - nextVal) == -2) && secondReq == 0 && (_SF == false || [nextCard getSuit] == suit))//uses second skip
            {
                secondReq = [c getVal] +1;
                counter++;
                finalVal = nextVal;
            }
            
            else if (_SF == true)
            {
                if (pos < [_cards count] - 2)//deals with straight flush skipping
                {
                    nextSFCard = [_cards objectAtIndex:pos + 2];
                    if ([nextSFCard getSuit] == suit)
                    {
                        if( [c getVal] - [nextSFCard getVal] == -1) // this is assuming that a standard straight flush is already out
                        {
                            counter++;
                            pos++;
                            finalVal = [nextSFCard getVal];
                        }
                        
                        else if ([c getVal] - [nextSFCard getVal] == -2)
                        {
                            if (firstReq == 0)
                            {
                                firstReq = [c getVal] +1;
                                counter++;
                                pos++;
                                finalVal = [nextSFCard getVal];
                            }
                            else if (secondReq == 0)
                            {
                                secondReq = [c getVal] +1;
                                counter++;
                                pos++;
                                finalVal = [nextSFCard getVal];
                            }
                            else seq = NO;
                        }
                        else if (firstReq == 0 && secondReq == 0 && [c getVal] - [nextSFCard getVal] == -3)
                        {
                            firstReq = [c getVal] +1;
                            secondReq = [c getVal] +2;
                            counter++;
                            pos++;
                            finalVal = [nextSFCard getVal];
                        }
                        else seq = NO;
                    }
                    else if (pos < [_cards count] - 3)
                    {
                        nextSFCard = [_cards objectAtIndex:pos + 3];
                        if ([nextSFCard getSuit] == suit)
                        {
                            if( [c getVal] - [nextSFCard getVal] == -1) // this is assuming that a standard straight flush is already out
                            {
                                counter++;
                                pos+= 2;
                                finalVal = [nextSFCard getVal];
                            }
                            
                            else if ([c getVal] - [nextSFCard getVal] == -2)
                            {
                                if (firstReq == 0)
                                {
                                    firstReq = [c getVal] +1;
                                    counter++;
                                    pos+= 2;
                                    finalVal = [nextSFCard getVal];
                                }
                                else if (secondReq == 0)
                                {
                                    secondReq = [c getVal] +1;
                                    counter++;
                                    pos+= 2;
                                    finalVal = [nextSFCard getVal];
                                }
                                else seq = NO;
                            }
                            else if (firstReq == 0 && secondReq == 0 && [c getVal] - [nextSFCard getVal] == -3)
                            {
                                firstReq = [c getVal] +1;
                                secondReq = [c getVal] +2;
                                counter++;
                                pos+= 2;
                                finalVal = [nextSFCard getVal];
                            }
                            else
                                seq = NO;
                        }//closes nextSFCard suit check
                        else
                            seq = NO;
                    }//closes big pos check
                    else
                        seq = NO;
                }//closes small pos check
                else
                    seq = NO;
            }//closes contingency
            else
            {
                seq = NO;
            }
            pos++;
        }
        if (counter == 2) //creates a potential straight, requires too many vars in this function to make its own function
        {
            bool canUse = true;
            if (pos < [_cards count] - 1 && secondReq == 0) //if it's possible to look for a fourth card
            {
                
                [self getFourthCard:firstReq position:pos orig:origVal suit:suit];
            }
            if (firstReq == 0)
            {
                if (origVal > 3)//Checks for potential straight with two extra cards on the bottom, can apply even with a fourth card
                {
                    canUse = true;
                    
                    for (PotentialStraight * PS in _potentialStraights)
                        if ([PS reqsUsed:origVal -1 second:origVal -2])
                                canUse = false;
                    
                    for (Card *j in _prevVals)
                        if (origVal - 1 == [j getVal] || origVal - 2 == [j getVal])
                        {
                            if (_SF == false)
                                canUse = false;
                            
                            else if ([j getSuit] == suit)
                                canUse = false;
                        }
                    if (origVal - 1 == _firstFourth || origVal -1 == _secondFourth || origVal - 2 == _firstFourth || origVal - 2 == _secondFourth)//invalidate if a value used is a fourth card--only possible if there's a wheel four-card potential flush
                        canUse = false;
                    
                    if (canUse)
                        [_potentialStraights addObject: [[PotentialStraight alloc] initWithInfo:finalVal fourth:false Required:(origVal -1) secondRequired:(origVal - 2)]];
                }
                canUse = true;
                
                if (finalVal < 13)//Checks for potential straight with two extra cards on the top
                {
                
                    canUse = true;
                    
                    for (PotentialStraight * PS in _potentialStraights) //vet it for previous potential straights using these requirements
                        if ([PS reqsUsed:origVal -1 second:finalVal +1])
                            canUse = false;
                    
                    for (Card *j in _prevVals) //vet it for the requirements being previous values in the hand
                        if (origVal - 1 == [j getVal] || finalVal +1 == [j getVal])
                        {
                            if (_SF == false)
                                canUse = false;
                            
                            else if ([j getSuit] == suit)
                                canUse = false;
                        }
                    
                    if (finalVal + 2 == _firstFourth || finalVal + 2 == _secondFourth || finalVal + 1 == _firstFourth || finalVal +1 == _secondFourth)
                        canUse = false;
                    
                    if (canUse)
                        [_potentialStraights addObject: [[PotentialStraight alloc] initWithInfo:(finalVal + 1) fourth:false Required:(origVal -1) secondRequired:(finalVal +1)]];
                }
                canUse = true;
                
                if (origVal > 2 && finalVal < 14) //Checks for potential straight with one card on each end
                {
                    canUse = true;
                    for (PotentialStraight * PS in _potentialStraights) //vet it for previous potential straights using these requirements
                        if ([PS reqsUsed:origVal -1 second:finalVal +1])
                            canUse = false;
                    
                    for (Card *j in _prevVals) //vet it for the requirements being previous values in the hand
                        if (origVal - 1 == [j getVal] || finalVal +1 == [j getVal])
                        {
                            if (_SF == false)
                                canUse = false;
                            
                            else if ([j getSuit] == suit)
                                canUse = false;
                        }
                    
                    if (origVal - 1 == _firstFourth || origVal - 1 == _secondFourth || finalVal + 1 == _firstFourth || finalVal +1 == _secondFourth) //and finally: vet it for using a fourth value again
                        canUse = false;
                   
                    if (canUse)
                        [_potentialStraights addObject: [[PotentialStraight alloc] initWithInfo:(finalVal + 1) fourth:false Required:(origVal -1) secondRequired:(finalVal +1)]];
                }
                canUse = true;

            }//ends if (firstReq == 0)
            
            if (firstReq > 0 && secondReq == 0)
            {
                if (origVal > 2) //checks to see if a card can be added on the bottom
                {
                    for (PotentialStraight * PS in _potentialStraights)
                        if ([PS reqsUsed:firstReq second:origVal -1])
                            canUse = false;
                    
                    if (firstReq == _firstFourth || firstReq == _secondFourth || origVal - 1 == _firstFourth || origVal - 1 == _secondFourth)
                        canUse = false;
                    
                    for (Card *j in _prevVals) //prevVals
                        if (origVal - 1 == [j getVal])
                        {
                            if (_SF == false)
                                canUse = false;
                            
                            else if ([j getSuit] == suit)
                                canUse = false;
                        }
                    
                    if (canUse)
                        [_potentialStraights addObject: [[PotentialStraight alloc] initWithInfo:finalVal fourth:false Required: firstReq secondRequired:(origVal -1)]];
                }
                canUse = true;
                
                if (finalVal < 14)
                {
                    for (PotentialStraight * PS in _potentialStraights)
                        if ([PS reqsUsed:finalVal +1 second:finalVal +2])
                            canUse = false;
                    
                    if (firstReq == _firstFourth || firstReq == _secondFourth || finalVal + 1 == _firstFourth || finalVal + 1 == _secondFourth)
                        canUse = false;

                    if (canUse)
                        [_potentialStraights addObject:[[PotentialStraight alloc] initWithInfo:finalVal + 1 fourth:false Required: firstReq secondRequired:(finalVal +1)]];
                }
                canUse = true;
                
            }//ends if (firstReq > 0 && secondReq == 0)
            if (secondReq > 0)
            {
                for (PotentialStraight * PS in _potentialStraights)
                    if ([PS reqsUsed:firstReq second:secondReq])
                        canUse = false;
                
                if (firstReq == _firstFourth || firstReq == _secondFourth || secondReq == _firstFourth || secondReq == _secondFourth)
                    canUse = false;
                
                if (canUse)
                    [_potentialStraights addObject: [[PotentialStraight alloc] initWithInfo:finalVal fourth:false Required: firstReq secondRequired:secondReq]];
            }//ends if secondReq > 0
        }//ends if counter == 2
        
        [_prevVals addObject: origCard];
        
    }//ends for loop
    
}

-(void) getFourthCard: (int) firstReq position: (int) pos orig: (int) origVal suit: (char) suit
{
    Card* c = [_cards objectAtIndex:pos];
    Card* nextCard = [_cards objectAtIndex:pos + 1];
    int nextCardVal = [nextCard getVal];
    PotentialStraight* PS;
    bool fourthCard = false; //true if a fourth card has been found
    
    if (pos < [_cards count] - 2 && (([c getVal] - nextCardVal) == 0 || (_SF == true && [nextCard getSuit] != suit && [c getVal] - nextCardVal == -1))) //situation where this could occur: 2-3-4-4-5
        nextCard = [_cards objectAtIndex:pos+2]; //get the next card in searh of a fourth
    
    nextCardVal = [nextCard getVal];
    
    if (([c getVal] - nextCardVal) == -1 && (_SF == false || [nextCard getSuit] == suit))
    {
        fourthCard = true;
    }
    else if (firstReq == 0 && (([c getVal] - nextCardVal)== -2) && (_SF == false || [nextCard getSuit] == suit)) //uses one skip
    {
        firstReq = [c getVal] +1;
        fourthCard = true;
    }
    
    if (fourthCard == true)
    {
        bool canUse;
        if(firstReq == 0)
        {
            if (origVal > 2)
            {
                canUse = true;
                firstReq = origVal - 1;
                if (_firstFourth == 0)
                    _firstFourth = firstReq;
                else if (_firstFourth != firstReq && _secondFourth != firstReq) //duplicate filtering
                    _secondFourth = firstReq;
                else
                    canUse = false;
                if (canUse)
                {
                    PS = [[PotentialStraight alloc] initWithInfo:nextCardVal fourth:true Required:firstReq secondRequired:0];
                    [_potentialStraights addObject:PS];
                }
            }
            if (nextCardVal < 14)
            {
                canUse = true;
                firstReq = nextCardVal + 1;
                if (_firstFourth == 0)
                    _firstFourth = firstReq;
                else if (_secondFourth != firstReq && _firstFourth != firstReq)
                    _secondFourth = firstReq;
                else
                    canUse = false;
                if (canUse)
                {
                    PS = [[PotentialStraight alloc] initWithInfo:firstReq fourth:true Required:firstReq secondRequired:0];
                    [_potentialStraights addObject:PS];
                }
            }
        }
        else
        {
            if (_firstFourth == 0)
                _firstFourth = firstReq;
            else
                _secondFourth = firstReq;
            PS = [[PotentialStraight alloc] initWithInfo:nextCardVal fourth:true Required:firstReq secondRequired:0];
            [_potentialStraights addObject:PS];
        }
    }
}

-(void) makeOdds
{
    int oddsModifier = 4; //all potential straights require a specific value, of which there are four cards
    if (_SF == true)
        oddsModifier = 1; //but there is only one card of a specific value and suit
    
    if (_firstFourth > 0) //odds from four-card potential straights
    {
        if (_secondFourth > 0)
        {
            oddsModifier *= 2;
        }
        _odds += [self oddsFromOuts:oddsModifier];
    }
    
    NSMutableArray * numbers = [[NSMutableArray alloc] init];
    //sort potential straights by whether fourthcard is true
    for (PotentialStraight * PS in _potentialStraights)//go through potential straights
    {
        if (PS.fourthCard == false)
        {
            [numbers addObject: [NSNumber numberWithInt: PS.firstReq]];
            [numbers addObject: [NSNumber numberWithInt: PS.secondReq]];
        }
    }
    
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [numbers sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
    for (int i = 0; i < [numbers count]; i++)
    {
        int occurrences = 1;
        int j = [[numbers objectAtIndex:i]intValue];
        while (i < [numbers count] - 1 && [[numbers objectAtIndex:i+1] intValue] == j)
        {
            occurrences++;
            i++;
        }
        float odds1 = oddsModifier;
        odds1 /= 47;
        float odds2 = oddsModifier * occurrences;
        odds2 /= 46;
        _odds += (odds1 * odds2);
        
    }
}

-(float) oddsFromOuts: (float) outs //gets the odds of a hand based on the texas holdem concept of "outs"
{
    float odds1 = outs;
    odds1 /= 47;
    float odds2 = (47 - outs);
    odds2 /= 47;
    float odds3 = outs;
    odds3 /= 46;
    return (odds1 + (odds2 * odds3));
    
}


//makeOdds
//makeOddsSF

@end

