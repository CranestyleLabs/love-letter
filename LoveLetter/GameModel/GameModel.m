//
//  GameModel.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "GameModel.h"
#import "LLPlayer.h"
#import "Deck.h"
#import "Card.h"


@interface GameModel ()

@property (readwrite) NSInteger playerCount;
@property (readwrite) NSArray* players;
@property (readwrite) Deck* deck;
@property (readwrite) Card* burnedCard;
@property (readwrite) NSInteger roundNumber;
@property (readwrite) BOOL isGameOver;
@property (readwrite) NSInteger currentPlayerNumber;

@end


@implementation GameModel

static GameModel* gameModel = nil;

+(GameModel*)sharedInstance
{
    if (gameModel == nil)
    {
        gameModel = [[self alloc] init];
    }
    return gameModel;
}

- (id)init
{
    if (self = [super init])
    {
        
        // defaults
        winningScore = 4;
        [self setIsGameOver:NO];
        
        // set roundNumber = 0
        [self setRoundNumber:0];
        
        // create players
        [self setPlayerCount:4];
        NSMutableArray* newPlayers = [[NSMutableArray alloc] initWithCapacity:self.playerCount];
        for (int i=0; i<self.playerCount; i++)
        {

            if (i == 0)
            {

                // Human player
                LLPlayer* player = [LLPlayer playerWithPlayerId:@"Human"];
                [player setIsAI:NO];
                [newPlayers addObject:player];
                
            }
            else
            {
                
                // AI players
                [newPlayers addObject:[LLPlayer playerWithPlayerId:[NSString stringWithFormat:@"AI%d", i]]];
                
            }
            self.players = [NSArray arrayWithArray:newPlayers];
        }
        
        // set current player number
        [self setCurrentPlayerNumber:0];
        
    }
    return self;
}

-(void)startRound
{
    
    NSInteger max = self.playerCount - 1;
    NSInteger min = 0;
    [self setCurrentPlayerNumber:((arc4random() % (max-min+1)) + min)];
    
    // set round number
    [self setRoundNumber:self.roundNumber++];
    
    // refresh the deck
    if (self.deck == nil)
    {
        [self setDeck:[[Deck alloc] init]];
    }
    else
    {
        [self.deck refresh];
    }
    
    // burn a card
    [self setBurnedCard:[self.deck drawCard]];
    
    // call startRound for each player
    [self.players enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        [player startRound];
        
    }];
    
}

-(void)endRound
{
    
    // see who still has cards in their hand
    NSMutableArray* playersWithCards = [self.players mutableCopy];
    NSMutableArray* playersWithoutCards = [[NSMutableArray alloc] init];
    [playersWithCards enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        if (player.cardsInHand.count == 0)
        {
            [playersWithoutCards addObject:player];
        }
        
    }];
    [playersWithCards removeObjectsInArray:playersWithoutCards];
    
    // see who has the highest card
    __block NSInteger highestHand = 0;
    __block LLPlayer* roundWinner = nil;
    [playersWithCards enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        Card* cardInHand = (Card*)[player.cardsInHand lastObject];
        if (cardInHand.cardValue > highestHand)
        {
            highestHand = cardInHand.cardValue;
            roundWinner = player;
        }
        
    }];
    
    // give the round winner a token
    if (roundWinner != nil)
    {
        [roundWinner ScoreUp];
    }
    
    // call endRound for each player
    [self.players enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        [player endRound];
        
    }];
    
    // see if someone has won the game
    [self.players enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        if (player.score == winningScore)
        {
            [self setIsGameOver:YES];
            [self gameOver:player];
        }
        
    }];
    
    if (!self.isGameOver)
    {
        [self startRound];
    }

}

-(void)startTurn
{
    
    // TODO: refresh ui
    
    LLPlayer* nextPlayer = [self getNextPayer];
    [nextPlayer startTurn];
    
}

-(void)endTurn
{
    LLPlayer* currentPlayer = [self getCurrentPlayer];
    [currentPlayer endTurn];
    
    if ([self isRoundOver])
    {
        [self endRound];
    }
    else
    {
        [self startTurn];
    }
}

-(BOOL)isRoundOver
{
    return !(self.deck.cards.count > 0);
}


-(Card*)drawBurnedCard
{
    
    [self setBurnedCard:nil];
    return self.burnedCard;
    
}

-(void)gameOver:(LLPlayer*)winner
{
    
    NSLog(@"GAME OVER!");
    NSLog(@"%@ won", winner.playerid);
    
}

-(LLPlayer*)getCurrentPlayer
{
    return (LLPlayer*)[self.players objectAtIndex:self.currentPlayerNumber];
}

-(LLPlayer*)getNextPayer
{
    if (self.currentPlayerNumber == self.players.count - 1)
    {
        [self setCurrentPlayerNumber:0];
    }
    else
    {
        [self setCurrentPlayerNumber:self.currentPlayerNumber + 1];
    }
    
    return [self getCurrentPlayer];
}

@end
