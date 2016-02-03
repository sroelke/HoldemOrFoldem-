//
//  ViewController.m
//  HoldemOrFoldem
//
//  Created by Seth Roelke on 10/6/15.
//  Copyright (c) 2015 Seth Roelke. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import "hand.h"
#import "Game.h"
#import "OddsTableViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray * myHandArray; //Array of cards to display from the hand
@property (nonatomic) hand * myHand; //The hand of cards in play

//Button declarations below
@property (nonatomic, weak) IBOutlet UIButton * oddsButton; //Button to display odds
@property (nonatomic, weak) IBOutlet UIButton* startButton; //Starts the game initially and after a reset
@property (nonatomic, weak) IBOutlet UIButton* resetButton; //Wipes all data and restarts the game
@property (nonatomic, weak) IBOutlet UIButton* nextButton;  //Progresses to the next stage, deals appropriate cards

@property (nonatomic, weak) IBOutlet UILabel* handLabel; //Displays what hand you have at the end of the game

//Card Images below -- They display either OriginalImage, or a normal playing card
//Images displayed initially
@property (nonatomic, weak) IBOutlet UIImageView* handCard1;
@property (nonatomic, weak) IBOutlet UIImageView* handCard2;
//Images displayed after first next
@property (nonatomic, weak) IBOutlet UIImageView* flopCard1;
@property (nonatomic, weak) IBOutlet UIImageView* flopCard2;
@property (nonatomic, weak) IBOutlet UIImageView* flopCard3;
//Image displayed after second next
@property (nonatomic, weak) IBOutlet UIImageView* turnCard;
//Image displayed after final next
@property (nonatomic, weak) IBOutlet UIImageView* riverCard;


@property (nonatomic) int gameState; //what phase the game is in.
    /*
     0 = not started
     1 = dealt initial hands
     2 = flop dealt
     3 = turn dealt
     4 = river dealt
     5 = Shows what your hand is, only option is to reset
     */

@property UIImage *originalImage; //The default display of a card

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myHandArray = [[NSMutableArray alloc] init];
    _gameState = [Game sharedGameData].gameState;
    _myHand = [Game sharedGameData].myHand;
    _myHandArray = [_myHand getCards];
    _originalImage = [UIImage imageNamed:@"cardback.png"];
    [self resumeFromGameState]; //Configures additional properties about the view by the game's state
}

- (void) resumeFromGameState //initializes the game screen by its state which is saved in the shared data
{
    switch (_gameState)
    {
        case 0: //Game has yet to start
        {
            [self.resetButton setAlpha: 0];
            [self.nextButton setAlpha: 0];
            [self.handLabel setAlpha: 0];
            [self.oddsButton setAlpha:0];
            [self.handLabel setText:@"Placeholder Label"];
            break;
        }
        case 1: //Initial two cards dealt
        {
            [self.startButton setAlpha:0];
            [self.resetButton setAlpha:1];
            [self.nextButton setAlpha:1];
            [self.handLabel setAlpha:0];
            [self.oddsButton setAlpha:0];
            Card *leftCard = _myHandArray[0];
            Card *rightCard = _myHandArray[1];
            _handCard1.image = [self createCardImage: leftCard];
            _handCard2.image = [self createCardImage: rightCard];
            break;
        }
        case 2: //Flop dealt
        {
            [self.startButton setAlpha:0];
            [self.resetButton setAlpha:1];
            [self.nextButton setAlpha:1];
            [self.handLabel setAlpha:0];
            [self.oddsButton setAlpha:1];
            //initial cards
            Card *leftCard = _myHandArray[0];
            Card *rightCard = _myHandArray[1];
            _handCard1.image = [self createCardImage: leftCard];
            _handCard2.image = [self createCardImage: rightCard];
            //flop cards
            Card *flopCard1 = _myHandArray[2];
            Card *flopCard2 = _myHandArray[3];
            Card *flopCard3 = _myHandArray[4];
            _flopCard1.image = [self createCardImage:flopCard1];
            _flopCard2.image = [self createCardImage:flopCard2];
            _flopCard3.image = [self createCardImage:flopCard3];
            break;
        }
        case 3: //Turn dealt
        {
            [self.startButton setAlpha:0];
            [self.resetButton setAlpha:1];
            [self.nextButton setAlpha:1];
            [self.handLabel setAlpha:0];
            [self.oddsButton setAlpha:1];
            //initial cards
            Card *leftCard = _myHandArray[0];
            Card *rightCard = _myHandArray[1];
            _handCard1.image = [self createCardImage: leftCard];
            _handCard2.image = [self createCardImage: rightCard];
            //flop cards
            Card *flopCard1 = _myHandArray[2];
            Card *flopCard2 = _myHandArray[3];
            Card *flopCard3 = _myHandArray[4];
            _flopCard1.image = [self createCardImage:flopCard1];
            _flopCard2.image = [self createCardImage:flopCard2];
            _flopCard3.image = [self createCardImage:flopCard3];
            //turn card
            Card * turnCard = _myHandArray[5];
            _turnCard.image = [self createCardImage:turnCard];
            break;
        }
        case 4: //River dealt
        {
            [self.startButton setAlpha:0];
            [self.resetButton setAlpha:1];
            [self.nextButton setAlpha:1];
            [self.handLabel setAlpha:0];
            [self.oddsButton setAlpha:0];
            //initial cards
            Card *leftCard = _myHandArray[0];
            Card *rightCard = _myHandArray[1];
            _handCard1.image = [self createCardImage: leftCard];
            _handCard2.image = [self createCardImage: rightCard];
            //flop cards
            Card *flopCard1 = _myHandArray[2];
            Card *flopCard2 = _myHandArray[3];
            Card *flopCard3 = _myHandArray[4];
            _flopCard1.image = [self createCardImage:flopCard1];
            _flopCard2.image = [self createCardImage:flopCard2];
            _flopCard3.image = [self createCardImage:flopCard3];
            //turn card
            Card * turnCard = _myHandArray[5];
            _turnCard.image = [self createCardImage:turnCard];
            //river card
            Card * riverCard = _myHandArray[5];
            _riverCard.image = [self createCardImage:riverCard];
            break;
            //there has to be a more efficient way to generate cards by case > x, while dealing with the buttons by case = x
        }
        case 5: //Game Finished
        {
            [self.startButton setAlpha:0];
            [self.resetButton setAlpha:1];
            [self.nextButton setAlpha:0];
            [self.oddsButton setAlpha:0];
            [self getHandLabel];
            //initial cards
            Card *leftCard = _myHandArray[0];
            Card *rightCard = _myHandArray[1];
            _handCard1.image = [self createCardImage: leftCard];
            _handCard2.image = [self createCardImage: rightCard];
            //flop cards
            Card *flopCard1 = _myHandArray[2];
            Card *flopCard2 = _myHandArray[3];
            Card *flopCard3 = _myHandArray[4];
            _flopCard1.image = [self createCardImage:flopCard1];
            _flopCard2.image = [self createCardImage:flopCard2];
            _flopCard3.image = [self createCardImage:flopCard3];
            //turn card
            Card * turnCard = _myHandArray[5];
            _turnCard.image = [self createCardImage:turnCard];
            //river card
            Card * riverCard = _myHandArray[5];
            _riverCard.image = [self createCardImage:riverCard];
            break;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // Not sure of what that would entail, or if a memory warning would come up for this app
}


//--------------------Button Implementations ---------------------------

- (IBAction)didTapStartButton:(id)sender
{
    //starts the game
    [[Game sharedGameData] shuffleDeck];
    [self.startButton setAlpha:0];
    [self.resetButton setAlpha:1];
    [self.nextButton setAlpha:1];
    [self.handLabel setAlpha:0];
    [self.oddsButton setAlpha:0];
    [[Game sharedGameData]dealInitial];
    _myHand = [Game sharedGameData].myHand;
    _myHandArray= _myHand.getCards;
    Card *leftCard = _myHandArray[0];
    Card *rightCard = _myHandArray[1];
    _handCard1.image = [self createCardImage: leftCard];
    _handCard2.image = [self createCardImage: rightCard];
   
    _gameState = [Game sharedGameData].gameState;
    
}

- (IBAction)didTapResetButton:(id)sender
{
    //resets the game
    _handCard1.image = _originalImage;
    _handCard2.image = _originalImage;
    _flopCard1.image = _originalImage;
    _flopCard2.image = _originalImage;
    _flopCard3.image = _originalImage;
    _turnCard.image = _originalImage;
    _riverCard.image = _originalImage;
    [_myHand wipe];
    [self.oddsButton setAlpha:0];
    [self.startButton setAlpha:1];
    [self.resetButton setAlpha:0];
    [self.nextButton setAlpha:0];
    [self.handLabel setAlpha:0];
    [self.handLabel setText:@"Placeholder Label"];
    _gameState = [Game sharedGameData].gameState;
}

- (IBAction)didTapNextButton:(id)sender
{
    //Progresses the game to the next state:
    switch (_gameState)
    {
        case 1: //deals flop
        {
            [[Game sharedGameData] dealFLop];
            _myHand = [[Game sharedGameData]myHand];
            _myHandArray= _myHand.getCards;
            Card *flopCard1 = _myHandArray[2];
            Card *flopCard2 = _myHandArray[3];
            Card *flopCard3 = _myHandArray[4];
            _flopCard1.image = [self createCardImage:flopCard1];
            _flopCard2.image = [self createCardImage:flopCard2];
            _flopCard3.image = [self createCardImage:flopCard3];
            [_myHand handCalc];
            [self.oddsButton setAlpha:1];
            _gameState = [Game sharedGameData].gameState;
            break;
        }
        case 2: //deals turn
        {
            [[Game sharedGameData] dealTurn];
            _myHand = [[Game sharedGameData] myHand];
            _myHandArray= _myHand.getCards;
            //make odds button visible
            Card *turnCard = _myHandArray[5];
            _turnCard.image = [self createCardImage:turnCard];
            [_myHand handCalc];
            _gameState = [Game sharedGameData].gameState;
            break;
        }
        case 3: //deals river
        {
            [[Game sharedGameData] dealRiver];
            _myHand = [[Game sharedGameData] myHand];
            _myHandArray= _myHand.getCards;
           [self.oddsButton setAlpha:0];
            Card *riverCard = _myHandArray[6];
            _riverCard.image = [self createCardImage:riverCard];
            _gameState = [Game sharedGameData].gameState;
            break;
        }
        case 4: //calculates the hand and labels it
        {
            [self getHandLabel];
            [self.nextButton setAlpha:0];
        }
        default:
        {
            NSLog(@"Next button pressed without valid gamestate");
        }
    }
}

-(void) getHandLabel //Generates the hand label's message by the strength of the hand.
{
    [_myHand handCalc];
    int i = [_myHand getHandStr];
    switch (i)
    {
        case 1:
            [_handLabel setText:@"High Card"];
            break;
        case 2:
            [_handLabel setText:@"Pair"];
            break;
        case 3:
            [_handLabel setText:@"Two Pair"];
            break;
        case 4:
            [_handLabel setText:@"Three of a Kind"];
            break;
        case 5:
            [_handLabel setText:@"Straight"];
            break;
        case 6:
            [_handLabel setText:@"Flush"];
            break;
        case 7:
            [_handLabel setText:@"Full House"];
            break;
            
        case 8:
            [_handLabel setText:@"Four of a Kind"];
            break;
            
        case 9:
            [_handLabel setText:@"Straight-Flush "];
            break;
        
            
    }
    [self.handLabel setAlpha:1];
   
}
//------------------------- other internal implementations ---------------------

-(char) valToChar: (int) val //converts a card's numeric value to a character for use in the image file name
{
    char c;
    switch (val)
    {
        case 10:
            c = 'T';
            break;
        case 11:
            c = 'J';
            break;
        case 12:
            c = 'Q';
            break;
        case 13:
            c = 'K';
            break;
        case 14:
            c = 'A';
            break;
        default:
            c = ((char) (val + 48));
    }
    return c;
}

-(UIImage *) createCardImage:(Card *) c //creates an image name for a given card. Technically, this wouldn't work with non-standard playing card values
{ //add exception for non-standard card
    NSMutableString *imgName = [[NSMutableString alloc] init];
    char suit = c.getSuit;
    int val = c.getVal;
    [imgName appendString:[NSString stringWithFormat:@"%c", [self valToChar:val]]];
    [imgName appendString:[NSString stringWithFormat:@"%c", suit]];
    [imgName appendString:[NSString stringWithFormat:@".png"]];
    UIImage *otherImage = [UIImage imageNamed:imgName];
    return otherImage;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{ //Prepares the odds table when the odds button is pressed
    if ([segue.identifier isEqualToString: @"oddsSegue"])
    {
    OddsTableViewController * controller = (OddsTableViewController *)segue.destinationViewController;
    //set controller's hand to the game's hand
    controller.myHand  = _myHand;
    }
}


@end
