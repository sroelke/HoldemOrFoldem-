//
//  hand.m
//  CardsTest
//
//  Created by Seth on 4/29/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//
//crashed when running calculation for odds with a pair (or presumably other hands of value)
//something is using looking for an index beyond the bounds
//test with fixed hand: 9D, 4H, 9H, 12D, 11S, 11D, 7H
#import "hand.h"

@implementation hand

-(instancetype) init
{
    self = [super init];
    _cards = [[NSMutableArray alloc] init];
    _cardsSorted = [[NSMutableArray alloc] init];
    _odds = [[NSMutableArray alloc] init];
    _handStr = 0;
    return self;
}
-(NSArray *) getCards
{
    if ([_cards count] >= 1)
        return _cards;
    else
        return nil;
}
-(NSArray *) getOdds
{
    if ([_odds count] >= 1)
        return _odds;
    else
        return nil;
}
-(void) wipe
{
    if ([_cards count] > 0)
        [_cards removeAllObjects];
    if ([_odds count] > 0)
        [_odds removeAllObjects];
    if ([_cardsSorted count] > 0)
        [_cardsSorted removeAllObjects];
    _handStr = 0;
}
-(void) handAdd:(Card *)c
{
    BOOL duplicate = NO;
    for (int i = 0; i < [_cards count]; i++)
    {
        Card * c2 = [_cards objectAtIndex:i]; //card to compare with card to add
        if (c == c2)
        {
            duplicate = YES;
        }
    }
    if (duplicate == NO)
        [_cards addObject:c];
}
-(void) output
{
    if ([_cards count] == 0)
        NSLog(@"Hand is empty");
    
    for (Card *c in _cards) //outputs every individual card
    {
        [c output];
    }
    
    NSLog(@"Total array size: %lu", (unsigned long)[_cards count]);
    NSLog(@"Hand strength: %d", _handStr);//outputs strenght of hand
    if ([_odds count] >= 1) //if there are odds to report, reports on them
    {
        for (int i = 0; i < [_odds count]; i++)
        {
            NSNumber * n = [_odds objectAtIndex:i];
            NSString * handType = [[NSString alloc]init];
            switch (i)
            {
                case 0:
                    handType = @"Straight-Flush";
                    break;
                case 1:
                    handType = @"Four of a Kind";
                    break;
                case 2:
                    handType = @"Full House";
                    break;
                case 3:
                    handType = @"Flush";
                    break;
                case 4:
                    handType = @"Straight";
                    break;
                case 5:
                    handType = @"Three of a Kind";
                    break;
                case 6:
                    handType = @"Two-Pair";
                    break;
                case 7:
                    handType = @"Pair";
                    break;
                    
            }
            NSLog(@"Cards that can cause a %@: %@", handType, n);
        }
    }
}
-(void) handSort //Puts a sorted version of the hand into cardsSorted, in ascending order
{
    NSSortDescriptor * sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc ] initWithKey:@"val" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortedArray;
    sortedArray = [_cards sortedArrayUsingDescriptors:sortDescriptors];
    _cardsSorted = [sortedArray mutableCopy];
}
-(void)handCalc
{
    float i;
    _handStr = 0;
    [_odds removeAllObjects];
    [self handSort];
    if ([_cards count] >= 5 && [_cards count] < 8) //gets the strength of the hand
    {
        if ([self straightFlush])
        {
            _handStr = 9;
        }
        else if([self fourOfKind])
        {
            _handStr = 8;
        }
        else if([self fullHouse])
        {
            _handStr = 7;
        }
        else if([self flush])
        {
            _handStr = 6;
        }
        else if ([self straight])
        {
            _handStr = 5;
        }
        else if ([self threeOfKind])
        {
            _handStr = 4;
        }
        else if ([self twoPair])
        {
            _handStr = 3;
        }
        else if ([self twoOfKind])
        {
            _handStr = 2;
        }
        else
            _handStr = 1;
    }
    else if ([_cards count] < 5)
        NSLog(@"Error: Attempt to calculate hand with too few cards");
    else
        NSLog(@"Error: Attempt to calculate hand with more than seven cards");
    if ([_cards count] == 6) //gets the odds of getting a hand on the river
    {
        if (_handStr < 9)
        {
            i = [self oddsSF];
            i = i/46; //fifty-two cards total, six cards you know about, forty-six unaccounted for
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat:i]];
        }
        if (_handStr < 8)
        {
            i = [self odds4K];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 7)
        {
            i = [self oddsFH];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 6)
        {
            i = [self oddsFlush];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 5)
        {
            i = [self oddsStraight];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 4)
        {
            i = [self odds3K];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 3)
        {
            i = [self odds2P];
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
        }
        if (_handStr < 2)
        {
            i = 18;
            i = i/46;
            i *= 100;
            [_odds addObject:[NSNumber numberWithFloat: i]];
            //if you have six garbage cards, there's three more of each value floating around that will give you a pair
        }
        
    }
    if ([_cards count] == 5) //gets the odds of getting a hand on the turn and river
    {
        oddsFlopStraight* OFS;
        float f;
        if (_handStr < 9)
        {
            OFS = [[oddsFlopStraight alloc] initWithInfo:_cardsSorted straightFlush:true];
            f = [OFS analyze];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 8)
        {
            f = [self oddsFlop4K];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 7)
        {
            f = [self oddsFlopFH];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 6)
        {
            f = [self oddsFlopFlush];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 5)
        {
            OFS = [[oddsFlopStraight alloc]initWithInfo: _cardsSorted straightFlush:false];
            f = [OFS analyze];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 4)
        {
            f = [self oddsFlop3K];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 3)
        {
            f = [self oddsFlop2P];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        if (_handStr < 2)
        {
            f = [self oddsFlopPair];
            f *= 100;
            [_odds addObject:[NSNumber numberWithFloat: f]];
        }
        
    }
}
-(int) oddsSF //Gets the odds of a straight flush
{
    if (_handStr >= 7) //there cannot be a straight alongside a full house or four of a kind
        return 0;
    NSMutableArray *Vals = [[NSMutableArray alloc] init]; //Values that can cause a straight flush, count of which is returned
    Card * debug0 = [_cardsSorted objectAtIndex: 0]; //used to prevent repeats of the same straight flush
    Card * debug1 = [_cardsSorted objectAtIndex: 1]; //used to prevent repeats of the same straight flush
    Card * wheel5 = [_cardsSorted objectAtIndex: 5];
    Card * wheel4 = [_cardsSorted objectAtIndex: 4];
    Card * wheel3 = [_cardsSorted objectAtIndex: 3];
    int wheel;//determines what kind of wheel straight is possible
    //With one remaining card, there must either be a 2 or an Ace in play for htere to be a chance for a wheel straight
    //0 = no chance
    //1 = 2 and Ace dealt
    //2 = Ace only dealt
    //3 = 2 only dealt
    NSMutableArray *totVals;
    Card *c;
    BOOL repeated = NO;
    
    for (int i = 0; i < 3; i++)
    {
        c = [_cardsSorted objectAtIndex:i];
        wheel = 0;
        
        switch (i) //Wheel (A-2-3-4-5 straight) check
        {
            case 0:
                if ([c getVal] == 2 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit]) || ([wheel3 getVal] == 14 && [wheel3 getSuit] == [c getSuit])))
                    wheel = 1;
                //if the first value is 2, and one of the last three values is an ace, both of matching suits, then there is a chance of a wheel straight with a 2 and an ace already dealt
                else if ([c getVal] == 2)
                    wheel = 3;
                //if the first value is 2 and there is no appropriate ace, there is a slimmer chance of a wheel straight
                else if ([c getVal] == 3 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit]) || ([wheel3 getVal] == 14 && [wheel3 getSuit] == [c getSuit])))
                    wheel = 2;
                //if the first card is instead a 3, and there is an ace, then there is a chance of a hweel straight with an ace already dealt
                else
                    wheel = 0;
                break;
            case 1: //similar to first case but with fewer checks
                if([c getVal] == 2 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit])))
                    wheel = 1;
                else if ([ c getVal] == 2)
                    wheel = 3;
                else if ([c getVal] == 3 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit])) && ([debug0 getVal] != 2 || [debug0 getSuit] != [c getSuit]))
                    wheel = 2;
                //if the value is a 3 and there wasn't a 2 of appropriate suit previously
                else
                    wheel = 0;
                break;
            case 2://similar to previous case but with one more debug check, and only checking with the last card in the hand
                if([c getVal] == 2 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit])))
                    wheel = 1;
                else if ([c getVal] == 2)
                {
                    wheel = 3;
                }
                
                else if ([c getVal] == 3 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit])) && (([debug0 getVal] != 2 || [debug0 getSuit] != [c getSuit]) || ([debug1 getVal] != 2 || [debug1 getSuit] != [c getSuit]) ) )
                {
                    wheel = 2;
                }
                else
                    wheel = 0;
                break;
        } //end switch statement
        totVals = [[NSMutableArray alloc] initWithArray:[self seqSFO:i wheelRule:wheel]]; //uses seqSFO to get the total values
        for (int j = 0; j < [totVals count]; j++) //filters through totVals for repeats and only adds new values to the return array
        {
            NSNumber * temp = [totVals objectAtIndex:j];
            repeated = NO;
            for (int k = 0; k < [Vals count]; k++)
            {
                NSNumber * temp2 = [Vals objectAtIndex:k];
                if (temp == temp2)
                    repeated = YES;
            }
            if (repeated == NO)
                [Vals addObject:temp];
        }
    }//end for loop
    return [Vals count];
}

-(BOOL)straightFlush //Checks the hand to see if it is a straigiht flush;
{
    BOOL seq = NO;
    Card *c;
    
    if ([_cardsSorted count] == 7) //there are conditions for cardsSorted's size because checking for a wheel can involve the last, second to last, or third to last card in the hand depending on the size
    {
        Card * wheel6 = [_cardsSorted objectAtIndex: 6];
        Card * wheel5 = [_cardsSorted objectAtIndex: 5];
        Card * wheel4 = [_cardsSorted objectAtIndex: 4];
        for (int i = 0; i < [_cardsSorted count] - 4 && seq == NO; i++) //if any viable straight flush is found, it exits out
        {
            c = [_cardsSorted objectAtIndex:i];
            
            switch(i) //checks each of the first three cards under different circumstances
            {
                case 0:
                    if([c getVal] == 2 && (([wheel6 getVal] == 14 && [wheel6 getSuit] == [c getSuit]) || ([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit])))
                    { //if a potential wheel straight is found, start the check for a straight flush at one instead of zero
                        seq = [self sequenceSF:1 position: i];
                        break;
                    }
                    else
                    { //if no potential wheel straight is found, start the check for a straight flush.
                        seq = [self sequenceSF:0 position: i];
                        break;
                    }
                case 1:
                {
                    if([c getVal] == 2 && (([wheel6 getVal] == 14 && [wheel6 getSuit] == [c getSuit]) || ([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit])))
                    {
                        seq = [self sequenceSF:1 position: i];
                        break;
                    }
                    else
                    {
                        seq = [self sequenceSF:0 position: i];
                        break;
                    }
                }
                case 2:
                {
                    if([c getVal] == 2 && (([wheel6 getVal] == 14 && [wheel6 getSuit] == [c getSuit])))
                    {
                        seq = [self sequenceSF:1 position: i];
                        break;
                    }
                    else
                    {
                        seq = [self sequenceSF:0 position: i];
                        break;
                    }
                }
            }
            
        }
    }
    else if ([_cardsSorted count] == 6) //basically identical to count == 7 minus a variable that would cause a segfault, and one less iteration
    {
        Card * wheel5 = [_cardsSorted objectAtIndex: 5];
        Card * wheel4 = [_cardsSorted objectAtIndex: 4];

        for (int i = 0; i < [_cardsSorted count] - 4 && seq == NO; i++)
        {
            Card *c = [_cardsSorted objectAtIndex:i];
            
            switch (i)
            {
                case 0:
                    if([c getVal] == 2 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit]) || ([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit])))
                    {
                        seq = [self sequenceSF:1 position: i];
                        break;
                    }
                    else
                    {
                        seq = [self sequenceSF:0 position: i];
                        break;
                    }
                case 1:
                {
                    if([c getVal] == 2 && (([wheel5 getVal] == 14 && [wheel5 getSuit] == [c getSuit])))
                    {
                        seq = [self sequenceSF:1 position: i];
                        break;
                    }
                    else
                    {
                        seq = [self sequenceSF:0 position: i];
                        break;
                    }
                }
                    
            }
        }
    }
    else if ([_cardsSorted count] == 5) //basically identical to count == 7 minus a variable that would cause a segfault, and two less iterations
    {
        Card * wheel4 = [_cardsSorted objectAtIndex: 4];
        for (int i = 0; i < [_cardsSorted count] - 4 && seq == NO; i++)
        {
            Card *c = [_cardsSorted objectAtIndex:i];
            
            if([c getVal] == 2 && (([wheel4 getVal] == 14 && [wheel4 getSuit] == [c getSuit])))
            {
                seq = [self sequenceSF:1 position: i];
            }
            else
            {
                seq = [self sequenceSF: 0 position:i];
            }
            
        }
        
    }
    return seq;
}
-(int) odds4K //The odds of a four of a kind, requires one or two threes of a kind
{
    if (_handStr != 3 && _handStr != 7) //There must be a full house or a three of a kind already in play for this to even be possible
        return 0;
    int firstSet = 0;//value of the three-of-a-kind
    int counter = 0;// number of consecutive values
    int compVal = 0;//value to compare to for consecutive checks
    int retVal = 0; //number of values that can give a four of a kind
    int pos; //position index in the hand
    BOOL seq; //whether or not there is a valid sequence
    Card *c;
    for (int i = 0; i < [_cardsSorted count] - 2 && counter < 3; i++)
    { //since preliminary calculations can't tell whether or not there is more than one set of threes of a kind, a set of three must be found
        counter = 0;
        pos = i;
        seq = YES;
        c = [_cardsSorted objectAtIndex:i];
        compVal = [c getVal];
        while (seq && pos < [_cardsSorted count] && counter < 3)
        {//checks the next card and compares it to the base card
            c = [_cardsSorted objectAtIndex:pos];
            if (compVal == [c getVal])
                counter++;
            else
                seq = NO;
            pos++;
        }
    }
    if (counter == 3)
    {//checks for a second set of three
        counter = 0;
        firstSet = compVal;
        for (int i = 0; i < [_cardsSorted count] - 2 && counter < 3; i++)
        {
            counter = 0;
            c = [_cardsSorted objectAtIndex:i];
            compVal = [c getVal];
            seq = YES;
            pos = i;
            while (seq && pos < [_cardsSorted count] && counter < 3 && firstSet != compVal)
            {
                c = [_cardsSorted objectAtIndex: pos];
                if (compVal == [c getVal])
                    counter++;
                else
                    seq = NO;
                pos++;
            }
            
        }
        if (counter == 3)//if a second set of 3 has been found, there are two potential cards for a four of a kind
            retVal = 2;
        else retVal = 1; //otherwise, there is only one
    }
    return retVal;
}
-(float) oddsFlop4K //gets the odds of a four of a kind after a flop
{
    float odds1; //the odds of the hand
    float odds2 = 1; //a value multiplied to odds1 under certain conditions
    
    if (_handStr == 7)//can get a four of a kind from the triplet or the pair on a full house.
    {
        odds1 = 2; //the paired value
        odds1 /= (47);
        odds2 *= 46; //2/47 chance of getting hte paired value * 1/46 chance of getting the last card of that value
        odds1 *= odds2;
        return ([self oddsFromOuts:1] + odds1);
    }
    if (_handStr == 4) //exactly one out
    {
        return ([self oddsFromOuts:1]);
    }
    if (_handStr == 3) //two paired values to work with -- odds of getting one of the paired value, then getting a fourth of that value
    {
        odds1 = 4;
        odds1 /= (47);
        odds2 /= 46;
        odds1 *= odds2;
        return (odds1);
    }
    if (_handStr == 2) //need the paired value twice
    {
        odds1 = 2;
        odds1 /= (47);
        odds2 /= 46;
        odds1 *= odds1;
        return odds1;
    }
    return 0.0;
}
-(BOOL)fourOfKind
{
    int counter = 0;//counter of consecutive values
    for (int i = 0; i < [_cardsSorted count] - 3 && counter < 4; i++)
    {//keeps trying cards looking for matches until there are no more valid cards to try
        counter = 0;
        Card *c = [_cardsSorted objectAtIndex:i];
        int compVal = [c getVal];
        BOOL seq = YES;
        int pos = i;
        while (seq && pos < [_cardsSorted count] && counter < 4)
        { //keeps looking for matches of the card until four are found or a mismatch is found
            c = [_cardsSorted objectAtIndex:pos];
            if (compVal == [c getVal])
                counter++;
            else
                seq = NO;
            pos++;
        }
    }
    if (counter == 4)
        return YES;
    return NO;
}
-(int) oddsFH
{
    if (_handStr == 4) //if you have a three of a kind, all you need is a duplicate of one of your other cards
        return 6;
    else if (_handStr == 3) //if instead you have two (or more) pairs, you need a duplicate of any of those pairs, 4 or 6 cards
    {//no way to tell from previous calculations if there is a third pair, so the first two must be found
        int numPairs = 0;
        int counter = 0;
        int compVal = 0;
        for (int i = 0; i < [_cardsSorted count] - 1 && numPairs < 3; i++)
        {
            counter = 0;
            int pos = i;
            BOOL seq = YES;
            Card *c = [_cardsSorted objectAtIndex: i];
            compVal = [c getVal];
            while (seq && pos < [_cardsSorted count] && counter < 2)
            {
                c = [_cardsSorted objectAtIndex:pos];
                if (compVal == [c getVal])
                    counter++;
                else
                    seq = NO;
                pos++;
            }
            if (counter == 2)
            {
                numPairs++;
            }
        }
        return (numPairs * 2);
    }
    return 0;
}
-(float) oddsFlopFH
{
    //can only happen if there is: a two-pair, a three of a kind, or a pair,
    if (_handStr == 4)//if there is a three of a kind
    {
        //...then any duplicate of the other two cards gives you a full hosue, and there are three of each
        //add the miniscule chance of getting a pair with nothing
        float odds1 = 40;
        odds1 /= 47;
        float odds2 = 3; //cards that will be the same value as the non-out card
        odds2 /= 46;
        //40/47 cards will not give you a full house or a four of a kind
        return ([self oddsFromOuts:6] + (odds1 * odds2));
    }
    if (_handStr == 3)//if there is a two-pair:
    {
        //...then there are four outs from the paired cards, plus the odds of getting a card of the third value twice in a row, oddsfromouts:4 + (3/47 * 2/46)
        float odds1 = 3;
        odds1 /= 47;
        float odds2 = 2;
        odds2 /= 46;
        
        return ([self oddsFromOuts:4] + (odds1 * odds2));
    }
    if (_handStr == 2)//if there is only one pair:
    {
        //...then you get the odds of the turn being the paired value and the river being a non-paired value, and the odds of the turn value being one a pairable value and then the river being one of either paired values (3/47 * 9/46) + (9/47 * 6/46)
        float odds1 = 3;
        odds1 /= 47;
        float odds2 = 9;
        odds2 /= 46;
        odds1 *= odds2;
        
        float odds3 = 9;
        odds3 /= 47;
        float odds4 = 6;
        odds4 /= 46;
        odds3 *= odds4;
        
        return (odds1 + odds3);
    }
    return 0.0;
}
-(BOOL) fullHouse
{
    int tripVal = 0;//value of the three-of-a-kind
    int counter = 0;
    int compVal = 0;
    int pos;
    BOOL seq;
    Card *c;
    for (int i = 0; i < [_cardsSorted count] - 2 && counter < 3; i++)
    {//finds the three of a kind
        counter = 0;
        pos = i;
        seq = YES;
        c = [_cardsSorted objectAtIndex:i];
        compVal = [c getVal];
        while (seq && pos < [_cardsSorted count] && counter < 3)
        {
            c = [_cardsSorted objectAtIndex:pos];
            if (compVal == [c getVal])
                counter++;
            else
                seq = NO;
            pos++;
        }
    }
    if (counter == 3)
    {//finds the pair, taking care not to count the three of a kind's value as a pair
        counter = 0;
        tripVal = compVal;//sets the three of a kind's value
        for (int i = 0; i < [_cardsSorted count] - 1 && counter < 2; i++)
        {
            counter = 0;
            c = [_cardsSorted objectAtIndex:i];
            compVal = [c getVal];
            seq = YES;
            pos = i;
            while (seq && pos < [_cardsSorted count] && counter < 2 && tripVal != compVal)
            {
                c = [_cardsSorted objectAtIndex: pos];
                if (compVal == [c getVal])
                    counter++;
                else
                    seq = NO;
                pos++;
            }
            
        }
        if (counter == 2)
            return YES;
    }
    return NO;
}
-(int) oddsFlush
{
    //same check as flush, but count to four
    int numS = 0, numC = 0, numD = 0, numH = 0; //number of each suit
    for (int i = 0; i < [_cardsSorted count] && numS < 4 && numC < 4 && numD < 4 && numH < 4; i++)
    {//counts each suit, if the counter gets to 4, there is a potential flush
        Card *c = [_cardsSorted objectAtIndex: i];
        switch ([c getSuit])
        {
            case 's': case 'S':
            {
                numS++;
                break;
            }
            case 'c': case 'C':
            {
                numC++;
                break;
            }
            case 'd': case 'D':
            {
                numD++;
                break;
            }
            case 'h': case 'H':
            {
                numH++;
                break;
            }
        }
    }
    if (numS >= 4 || numC >=4 || numD >=4 || numH >=4)
    {
        return 9;
    }
    return 0;
}
-(float) oddsFlopFlush
{
    //flush, but count to four
    int numS = 0, numC = 0, numD = 0, numH = 0;
    for (int i = 0; i < [_cardsSorted count] && numS < 4 && numC < 4 && numD < 4 && numH < 4; i++)
    {
        Card *c = [_cardsSorted objectAtIndex: i];
        switch ([c getSuit])
        {
            case 's': case 'S':
            {
                numS++;
                break;
            }
            case 'c': case 'C':
            {
                numC++;
                break;
            }
            case 'd': case 'D':
            {
                numD++;
                break;
            }
            case 'h': case 'H':
            {
                numH++;
                break;
            }
        }
    }
    if (numC == 3 || numD == 3 || numH == 3 || numS == 3)
    { //there have to be two of a suit, so they aren't necessarily outs
        //odds are: 10/47 * 9/46
        float odds1 = 10; //number of cards of the correct suit
        odds1 /= 47;
        float odds2 = 9; //number of cards of the correct suit on the river if a fourth card was drawn
        odds2 /= 46;
        return (odds1 * odds2);
    }
    else if (numC == 4 || numD == 4 || numH == 4 || numS == 4)
    { //with only one card needed to complete the hand, outs can be used
        return [self oddsFromOuts:9];
    }
    
    return 0.0;
}
-(BOOL) flush
{
    //counts the number of times each suit occurs, if any counter reaches 5, returns true
    int numS = 0, numC = 0, numD = 0, numH = 0;
    for (int i = 0; i < [_cardsSorted count] && numS < 5 && numC < 5 && numD < 5 && numH < 5; i++)
    {
        Card *c = [_cardsSorted objectAtIndex: i];
        switch ([c getSuit])
        {
            case 's': case 'S':
            {
                numS++;
                break;
            }
            case 'c': case 'C':
            {
                numC++;
                break;
            }
            case 'd': case 'D':
            {
                numD++;
                break;
            }
            case 'h': case 'H':
            {
                numH++;
                break;
            }
        }
    }
    if (numS >= 5 || numC >=5 || numD >=5 || numH >=5)
    {
        return YES;
    }
    return NO;
}
-(int) oddsStraight //wheel check could be redone
{ //counts up hand looking for a potential straight sequence
    NSMutableArray *Vals = [[NSMutableArray alloc] init]; //array of card values that CAN get you a straight
    Card * debug0 = [_cardsSorted objectAtIndex: 0]; //the card in index 0
    Card * wheel = [_cardsSorted objectAtIndex: 5]; //the card in the last index
    int counter = 0; //The number of cards in a sequence. Goes to three because the card you start with counts as one.
    int wheelRule = 0; //Wheel Rule is the use of the ace to start a straight as a low card, its value acts as a switch for which cards are potential straight makers,
    //1= have 2 and A
    //2= have 2 but no A
    //3= have A and 3, need 2
    
    NSMutableArray *compVals = [[NSMutableArray alloc] init]; //Values to compare
    if ([debug0 getVal] == 2 && [wheel getVal] == 14) //have a 2 and an ace
        wheelRule = 1;
    else if ([debug0 getVal] == 3 && [wheel getVal] == 14) //have an ace and a 3
        wheelRule = 2;
    else if ([debug0 getVal] == 2) //have a 2 but no ace
        wheelRule = 3;
    for (int i = 0; i < 3; i++)
    {
        
        
        Card *c = [_cardsSorted objectAtIndex:i];
        //wheel rule setup
        if (wheelRule == 1 && i == 0) //sets up for the Ace and 2 wheel rule because that's the only one where you KNOW you have a shot
            counter = 1;
        else
            counter = 0;
        if (i > 0)
            wheelRule = 0;
        //variable initialization
        BOOL seq = YES; //means a sequence is possible
        int pos = i; //position in the hand we will use
        int MBVal = 0; //value of a potential missing card in the middle of the sequence
        int finalVal = [c getVal]; //this will increment, final COMPARED value
        int origVal = finalVal; //this will not
        //
        while (seq && pos < [_cardsSorted count] - 1 && counter < 3) //while we have a sequence, and our position isn't going to cause a segfault and we haven't confirmed there is a chance for a straight
        {
            Card * nextCard = [_cardsSorted objectAtIndex:pos+1]; //gets the next card in the hand
            c = [_cardsSorted objectAtIndex:pos]; //sets the card we're using as a comparison
            int nextVal = [nextCard getVal]; //pulls the value from the next card
            if (([c getVal] - nextVal) == -1) //if it's a difference of one, then move forward and increment the counter
            {
                counter++;
                finalVal = nextVal;
            }
            else if ([c getVal] == nextVal || MBVal == nextVal) //if they are the same value, ignore it
            {
                //  NSLog(@"filler"); do not delete, this serves a purpose by doing nothing due to how I set the conditions up
            }
            else if (MBVal == 0 && (([c getVal] - nextVal) == -2)) //if we haven't already determined a middle value, set it up
            {
                MBVal = [c getVal] + 1;
                counter++;
                finalVal = nextVal;
            }
            else
                seq = NO; //kills the loop
            pos++; //moves on to the next card
        }
        if (counter >= 3) //if there is a potential straight
        {
            if (MBVal != 0) //If there's a missing middle card
            {
                [compVals addObject: [NSNumber numberWithInt:MBVal]];
            }
            else if (wheelRule == 3) //if you have 2-3-4-5, must be no middle card
            {
                [compVals addObject: [NSNumber numberWithInt:6]];
                [compVals addObject: [NSNumber numberWithInt:14]];
                //sets up for an A-2-3-4-5 straight or a 2-3-4-5-6 straight
            }
            else if (wheelRule == 1) //if you have A-2-3-4, should be support for A-2 4-5 or A-2-3, 5
            {
                [compVals addObject: [NSNumber numberWithInt:5]];
                //sets up for an A-2-3-4-5 straight
            }
            else if (wheelRule == 0 || wheelRule == 2)//handling for no wheel and no missing middles, or one with an Ace but no 2
            {
                if (origVal > 2)
                    [compVals addObject: [NSNumber numberWithInt:origVal - 1]];
                if (finalVal < 14)
                    [compVals addObject: [NSNumber numberWithInt:finalVal + 1]];
                //adds a card on either end if possible
            }
        }
        
        if (counter == 2 && wheelRule == 2) //you only have the starting card and two others, and an Ace and a 3 wheel setup
        {
            [compVals addObject: [NSNumber numberWithInt:2]];
            //sets up for an A-2-3-4-5 straight
        }
        //now to get your odds
        for (int i = 0; i < [compVals count]; i++) //iterating through the array of compvals
        {
            NSNumber * temp = [compVals objectAtIndex:i]; //take the number at i
            BOOL repeated = NO; //if the nubmer is repeated in compVals, throws it out
            for (int j = 0; j < [Vals count]; j++) //increments upwards, comparing the values
            {
                NSNumber * temp2 = [Vals objectAtIndex:j];
                if (temp == temp2)
                    repeated = YES;
            } //if at any point there is a repeat, throw it out, eventually the same value will not repeat
            if (repeated == NO)
                [Vals addObject:temp]; //put the vlaue into temp if there were no repeats whatsoever
        }
    }
    return [Vals count];
}
-(BOOL) straight
{//walks through the hand to see if there is a sequence of five cards
    BOOL seq = YES;
    int counter = 0;
    for (int i = 0; i < [_cardsSorted count] - 4 && counter < 4; i++)
    { //sets the card to start iterating from
        counter = 0;
        seq = YES;
        int pos = i;
        Card *c = [_cardsSorted objectAtIndex:i];
        Card * wheel = [_cardsSorted objectAtIndex:[_cardsSorted count] - 1];
        if ([c getVal] == 2 && [wheel getVal] == 14)
            counter++;
        while (seq && counter < 4 && pos < [_cardsSorted count] - 1)
        {//iterates up until a straight is found or invalidated
            c = [_cardsSorted objectAtIndex: pos];
            Card * next = [_cardsSorted objectAtIndex: pos+1];
            if ([c getVal] - [next getVal] == -1)
                counter++;
            else if ([c getVal] == [next getVal])
            {
            }
            else
                seq = NO;
            pos++;
        }
    }
    if (counter >= 4)
    {
        return YES;
    }
    return NO;
}
-(int) odds3K //gets the odds of a three of a kind on the river
{
    if (_handStr == 2)//there has to be a pair, and only one pair. If there were two pairs, then it would become a full house
        return 2;
    return 0;
}

-(float) oddsFlop3K //gets the odds of a three of a kind over the turn and river
{
    float odds1;
    float odds2;
    if (_handStr == 2) //if you have a pair already:
    {
        //then your odds of getting a three of a kind are two outs, plus the fact that there are three other cards that you can get two of
        odds1 = 9;
        odds1 /= 47;
        odds2 = 2;
        odds2 /= 46;
        return ([self oddsFromOuts:2] + (odds1 * odds2));
    }
    //otherwise: 15/47 * 2/46, odds of getting a value already dealt * odds of getting that value again
    odds1 = 15;
    odds1 /= 47;
    odds2 = 2;
    odds2 /= 46;
    return (odds1 * odds2);
}
-(BOOL) threeOfKind
{
    int counter = 0;//counts for three cards
    for (int i = 0; i < [_cardsSorted count] - 2 && counter < 3; i++)
    {
        counter = 0;
        Card *c = [_cardsSorted objectAtIndex: i];
        int compVal = [c getVal];
        BOOL seq = YES;
        int pos = i;
        while (seq && pos < [_cardsSorted count] && counter < 3)
        {
            c = [_cardsSorted objectAtIndex:pos];
            if (compVal == [c getVal])
                counter++;
            else
                seq = NO;
            pos++;
        }
    }
    if (counter == 3)
        return YES;
    return NO;
}
-(int) odds2P
{
    if (_handStr == 2) //checking if there's a pair, since handStr can be either 2 or 1 in this situation
        return 12; //four cards not part of that pair, three copies of each card
    return 0;
}
-(float) oddsFlop2P
{
    if (_handStr == 2)
    {
        float odds1 = 36; //number of cards that will not give three of a kind or two-pair
        odds1 /= 47;
        float odds2 = 3; //number of cards that can then give a second pair
        odds2 /= 46;
        return ([self oddsFromOuts:9] + (odds1 * odds2)); //odds of getting a second pair from what's already there + odds of getting an entirely new pair
    }
    float odds1 = 15; //odds of pairing one value
    odds1 /= 47;
    float odds2 = 12; //odds of pairing the other one on the river
    odds2 /= 46;
    //failing that, (15/47 * 12/46) + (32/47 * 3/46)
    return (odds1 * odds2);
}
-(float) oddsFlopPair
{
    float odds1 = 32; //odds of getting ANY value but one already in the hand
    odds1 /= 47;
    float odds2 = 3; //odds of that value being drawn again
    odds2 /= 46;
    return ([self oddsFromOuts:15] + (odds1 * odds2)); //there is no room for variation here in the current design, so this function can be scrapped for the nubmer it produces
}

-(BOOL) twoPair
{
    int firstPair = 0;//value of the first pair found
    int counter = 0;
    int compVal = 0;
    for (int i = 0; i < [_cardsSorted count] - 2 && counter < 2; i++) //starting at the beginning, and going until it's impossible to get a two-pair or the first pair hasn't been spotted
    {
        counter = 0; //resets counter
        int pos = i; //gets the position in the array that i is in
        BOOL seq = YES; //pretends there is a sequence
        Card *c = [_cardsSorted objectAtIndex:i]; //gets the card at i
        compVal = [c getVal]; //sets the comparison value to c
        while (seq && pos < [_cardsSorted count] && counter < 2) //while we haven't gone over and we haven't found a card that breaks the pair
        {
            c = [_cardsSorted objectAtIndex:pos]; //set get the card at pos, the first one is the initial card
            if (compVal == [c getVal])
                counter++; //increments the counter if it's a match, reminder that the initial card trips this condition
            else
                seq = NO; //otherwise soft-breaks out of the while loop
            pos++; //moves forward a position to check again
        }
    }
    if (counter == 2)
    { //checks again for a pair that isn't of the same value as firstPair
        counter = 0;
        firstPair = compVal;
        for (int i = 0; i < [_cardsSorted count] - 1 && counter < 2; i++)
        {
            counter = 0;
            Card *c = [_cardsSorted objectAtIndex:i];
            compVal = [c getVal];
            bool seq = YES;
            int pos = i;
            while (seq && pos < [_cardsSorted count] && counter < 2 && firstPair != compVal)
            {
                c = [_cardsSorted objectAtIndex: pos];
                if (compVal == [c getVal])
                    counter++;
                else
                    seq = NO;
                pos++;
            }
            
        }
        
        if (counter == 2)
        {
            return YES;
        }
        
    }
    return NO;
}
-(BOOL) twoOfKind
{//checks for just one pair, functoin layout has been used already many times
    int counter = 0;
    for (int i = 0; i < [_cardsSorted count] - 1 && counter < 2; i++)
    {
        counter = 0;
        Card *c = [_cardsSorted objectAtIndex: i];
        int compVal = [c getVal];
        BOOL seq = YES;
        int pos = i;
        while (seq && pos < [_cardsSorted count] && counter < 2)
        {
            c = [_cardsSorted objectAtIndex:pos];
            if (compVal == [c getVal])
                counter++;
            else
                seq = NO;
            pos++;
        }
    }
    if (counter == 2)
        return YES;
    return NO;
}
-(NSArray *) seqSFO: (int) pos wheelRule: (int) wheel
{ //gets all the values that can potentially be straight flushes
    NSMutableArray * retArray = [[NSMutableArray alloc] init]; //array of potential straight flush values
    BOOL seq = YES; //whether or not there is a sequence
    Card * origCard = [_cardsSorted objectAtIndex:pos];//original card to compare
    char origSuit = [origCard getSuit]; //suit to compare
    int currVal = [origCard getVal];//value currently being compared
    int MBVal = 0; //middle value if a one-number gap is found
    int finalVal = 0; //value tat the sequence ends on/current highet value
    int c = 0; //counter
    if (wheel == 1)
        c = 1; //primes the counter if there is a potential wheel straight
    while (seq == YES && c < 3 && pos < [_cardsSorted count] - 1)
    {//much like straight's, but with a suit check
        Card * nextCard = [_cardsSorted objectAtIndex:pos+1];
        int nextVal = [nextCard getVal];
        char nextSuit = [nextCard getSuit];
        if ((currVal - nextVal) == -1 && origSuit == nextSuit )
        {
            c++; //insert pun
            finalVal = nextVal;
            currVal++;
        }
        else if (currVal == nextVal || (currVal - nextVal == -1 && origSuit != nextSuit))
        {
            //  NSLog(@"filler");
        }
        else if (MBVal == 0 && ((currVal - nextVal) == -2))
        {
            currVal++;
            MBVal = currVal;
            if (nextSuit == origSuit)
            {
                c++;
                currVal++;
                finalVal = nextVal;
            }
        }
        else
            seq = NO;
        pos++;
    }
    if (c >= 3)
    {
        if (MBVal != 0)
        {
            [retArray addObject:[NSNumber numberWithInt:MBVal]];
            return retArray;
        }
        if (wheel == 3)
        {
            [retArray addObject:[NSNumber numberWithInt:14]];
            [retArray addObject:[NSNumber numberWithInt:6]];
            return retArray;
        }
        if (wheel == 1)
        {
            [retArray addObject:[NSNumber numberWithInt:5]];
            return retArray;
        }
        if (wheel == 0 || wheel == 2)
        {
            [retArray addObject:[NSNumber numberWithInt:finalVal + 1]];
            [retArray addObject:[NSNumber numberWithInt:[origCard getVal] - 1]];
            return retArray;
        }
    }
    if (c == 2 && wheel == 2)
    {
        [retArray addObject:[NSNumber numberWithInt:2]];
    }
    return retArray;
}
-(BOOL) sequenceSF: (int) c position: (int) pos //does the real leg work for finding a straight flush, c represetns what number the potential straight flush starts at, due to the ability of the ace toe be either high or low
{
    BOOL seq = YES;
    Card *origCard = [_cardsSorted objectAtIndex:pos];
    char origSuit = [origCard getSuit];
    int currVal = [origCard getVal];
    while (seq == YES && c < 4 && pos < [_cardsSorted count] - 1)
    {
        Card * nextCard = [_cardsSorted objectAtIndex:pos+1];
        int nextVal = [nextCard getVal];
        char nextSuit = [nextCard getSuit];
        if ((currVal - nextVal) == -1 && origSuit == nextSuit )
        {
            c++; //insert pun
            currVal++;
        }
        else if (currVal == nextVal || (currVal - nextVal == -1 && origSuit != nextSuit))
        {
            //   NSLog(@"filler"); do not delete this, it serves a vital purpose by doing nothing
        }
        else
            seq = NO;
        pos++;
        
    }
    return(c >= 4);
}
-(int) getHandStr
{
    return _handStr;
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


@end
