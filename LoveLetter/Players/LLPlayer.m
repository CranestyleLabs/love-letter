//
//  LLPlayer.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "LLPlayer.h"
#import "Play.h"
#import "Secret.h"
#import "GameModel.h"
#import "Deck.h"
#import "AIUtilities.h"
#import "PlayResult.h"


@interface LLPlayer ()

@property (readwrite) NSString* playerid;
@property (readwrite) NSArray* secrets;
@property (readwrite) NSArray* cardsInHand;
@property (readwrite) NSArray* cardsPlayed;
@property (readwrite) NSInteger score;
@property (readwrite) BOOL isProtected;

@end


@implementation LLPlayer

+(id)playerWithPlayerId:(NSString*)playerId
{
    return [[self alloc] initWithPlayerId:playerId];
}

- (id)initWithPlayerId:(NSString*)playerid
{
    if (self = [super init])
    {
        [self setPlayerid:playerid];
        [self setIsAI:YES];
        [self setScore:0];
        
        [self setCardsInHand:[[NSArray alloc] init]];
        [self setCardsPlayed:[[NSArray alloc] init]];
        
//        cardsPlayed
        
//        // make a score for testing
//        NSString* playerID = self.playerid;
//        NSString* playerIDNumber = [playerID substringFromIndex:[playerID length] -1];
//        CCLOG(@"player id number = %@", playerIDNumber);
//        int max = playerIDNumber.intValue + 2;
//        CCLOG(@"max = %d", max);
//        for (int i = 0; i < max; i++)
//        {
//            [self ScoreUp];
//            CCLOG(@"updated player %@'s score", playerid);
//        }
//        CCLOG(@"player %@'s score is %d", self.playerid, self.score);
        
    }
    return self;
}


#pragma mark
#pragma mark Cards

-(void)playCard:(Card*)playedCard
{
    
    // this is ugly, but call this to move a card from the player's hand
    // to thier played cards array
    
    // find the card in cardsInHand
    __block Card* card = nil;
    [self.cardsInHand enumerateObjectsUsingBlock:^(Card* cardInHand, NSUInteger idx, BOOL *stop) {
       
        if (cardInHand.cardNumber == playedCard.cardNumber)
        {
            card = cardInHand;
        }
        
    }];
    
    // remove the card from cardsInHand
    if (card != nil)
    {
        NSMutableArray* copyCardsInHand = [self.cardsInHand mutableCopy];
        [copyCardsInHand removeObject:card];
        [self setCardsInHand:[NSArray arrayWithArray:copyCardsInHand]];
    }
    
    // put card into cards played
    NSMutableArray* copyCardsPlayed = [self.cardsPlayed mutableCopy];
    [copyCardsPlayed addObject:card];
    [self setCardsPlayed:[NSArray arrayWithArray:copyCardsPlayed]];
    
}

-(NSInteger)addCard:(Card*)card
{
    
    // if cards array hasn't been initialized yet, init it now
    if (self.cardsInHand == nil)
    {
        [self setCardsInHand:[[NSArray alloc] init]];
    }
    
    // can't have more than 2 cards
    if (self.cardsInHand.count < 2)
    {
        
        if (card != nil)
        {
        
            NSMutableArray* copyCardsInHand = [NSMutableArray arrayWithArray:self.cardsInHand];
            [copyCardsInHand addObject:card];
            
            [self setCardsInHand:[NSArray arrayWithArray:copyCardsInHand]];
            
        }
        
    }
    
    return self.cardsInHand.count;
    
}

-(NSInteger)removeCard:(Card*)card
{
    return [self removeCardByNumber:card.cardNumber];
}

-(NSInteger)removeCardByNumber:(NSInteger)cardNumber
{
    
    NSMutableArray* copyCardsInHand = [NSMutableArray arrayWithArray:self.cardsInHand];
    NSMutableArray* cardsToRemove = [[NSMutableArray alloc] init];
    for (Card* card in self.cardsInHand)
    {
        if (card.cardNumber == cardNumber)
        {
            [cardsToRemove addObject:card];
        }
    }
    
    [copyCardsInHand removeObjectsInArray:cardsToRemove];
    
    [self setCardsInHand:[NSArray arrayWithArray:copyCardsInHand]];
    
    return self.cardsInHand.count;
    
}

-(void)invalidateAllCards
{
    [self setCardsInHand:[[NSArray alloc] init]];
    [self setCardsPlayed:[[NSArray alloc] init]];
}



#pragma mark
#pragma mark Turns

-(void)startTurn
{
    
    NSLog(@"[LLPlayer startTurn][%@]", self.playerid);
    
    // start turn
    [self setIsProtected:NO];
    
    // draw a card
    [self addCard:[[GameModel sharedInstance].deck drawCard]];
    
    
    if (self.isAI)
    {
        Play* play = [AIUtilities makePlayForPlayer:self];
        [PlayResult player:self makesPlay:play];
        [self endTurn];
    }
    
}

-(void)endTurn
{
    
    NSLog(@"[LLPlayer endTurn][%@]", self.playerid);
    
    // end turn
    
    [[GameModel sharedInstance] endTurn];
    
}

-(void)startRound
{
    
    NSLog(@"[LLPlayer startRound][%@]", self.playerid);
    
    // draw a card
    [self addCard:[[GameModel sharedInstance].deck drawCard]];
    
}

-(void)endRound
{
    
    NSLog(@"[LLPlayer endRound][%@]", self.playerid);
    
    // ditch cards in hand
    NSMutableArray* ditchCardsInHand = [self.cardsInHand mutableCopy];
    [ditchCardsInHand removeAllObjects];
    [self setCardsInHand:[NSArray arrayWithArray:ditchCardsInHand]];
    
    // ditch cards played
    NSMutableArray* ditchCardsPlayed = [self.cardsPlayed mutableCopy];
    [ditchCardsPlayed removeAllObjects];
    [self setCardsPlayed:[NSArray arrayWithArray:ditchCardsPlayed]];
    
}


#pragma mark
#pragma mark Play

-(Play*)makePlay
{
    
    return [AIUtilities makePlayForPlayer:self];
    
}

-(NSString*)cardPatternForCards:(NSArray*)cards
{
    
    // zero out counts
    NSInteger guards    = 0;
    NSInteger priests   = 0;
    NSInteger barons    = 0;
    NSInteger handmaids = 0;
    NSInteger princes   = 0;
    NSInteger king      = 0;
    NSInteger countess  = 0;
    NSInteger princess  = 0;
    
    // count cards
    for (Card* card in cards)
    {
        
        switch (card.cardValue)
        {
        
            case kCardValue_Guard:
                guards++;
                break;
                
            case kCardValue_Priest:
                priests++;
                break;
                
            case kCardValue_Baron:
                barons++;
                break;
                
            case kCardValue_Handmaid:
                handmaids++;
                break;
                
            case kCardValue_Prince:
                princes++;
                break;
                
            case kCardValue_King:
                king++;
                break;
                
            case kCardValue_Countess:
                countess++;
                break;
                
            case kCardValue_Princess:
                princess++;
                break;
                
        }
        
    }
    
    return [NSString stringWithFormat:@"%d%d%d%d%d%d%d%d",
              guards,
              priests,
              barons,
              handmaids,
              princes,
              king,
              countess,
              princess
              ];
    
}


#pragma mark
#pragma mark Score

-(NSInteger)ScoreUp
{
    [self setScore:self.score+1];
    return self.score;
}


#pragma mark
#pragma mark Secrets

-(NSInteger)addSecret:(Secret*)secret
{
    NSMutableArray* copySecrets = [self.secrets mutableCopy];
    [copySecrets addObject:secret];
    [self setSecrets:[NSArray arrayWithArray:copySecrets]];
    return self.secrets.count;
}

-(NSInteger)addSecretForPlayer:(LLPlayer*)player andCardValue:(NSInteger)cardValue
{

    // if secrets array hasn't been initialized yet, init it now
    if (self.secrets == nil)
    {
        [self setSecrets:[[NSArray alloc] init]];
    }
         
    
    if (player != nil)
    {
        
        // does this secret already exist?
        for (Secret* secret in self.secrets)
        {
            if ([secret.player.playerid isEqualToString:player.playerid] && secret.cardValue == cardValue)
            {
                // secret already in array, return
                return self.secrets.count;
            }
        }
            
        // secret not in array, add it
        NSMutableArray* copySecrets = [NSMutableArray arrayWithArray:self.secrets];
        [copySecrets addObject:[Secret secretForPlayer:player andCardValue:cardValue]];
        
    }
    
    return self.secrets.count;
    
}

-(NSInteger)removeSecretForPlayer:(LLPlayer*)player andCard:(NSInteger)cardValue
{
    
    if (self.secrets != nil)
    {
        
        if (player != nil)
        {
            
            NSMutableArray* copySecrets = [NSMutableArray arrayWithArray:self.secrets];
            NSMutableArray* secretsToRemove = [[NSMutableArray alloc] init];
            
            for (Secret* secret in self.secrets)
            {
                if ([secret.player.playerid isEqualToString:player.playerid] && secret.cardValue == cardValue)
                {
                    [secretsToRemove addObject:secret];
                }
            }
            
            [copySecrets removeObjectsInArray:secretsToRemove];
            [self setSecrets:[NSArray arrayWithArray:copySecrets]];
            
        }
        
    }
    
    return self.secrets.count;
    
}

-(NSInteger)removeAnySecretsForPlayer:(LLPlayer*)player
{
    
    if (self.secrets != nil)
    {
        
        if (player != nil)
        {
            
            NSMutableArray* copySecrets = [NSMutableArray arrayWithArray:self.secrets];
            NSMutableArray* secretsToRemove = [[NSMutableArray alloc] init];
            
            for (Secret* secret in self.secrets)
            {
                if ([secret.player.playerid isEqualToString:player.playerid])
                {
                    [secretsToRemove addObject:secret];
                }
            }
            
            [copySecrets removeObjectsInArray:secretsToRemove];
            [self setSecrets:[NSArray arrayWithArray:copySecrets]];
            
        }
        
    }
    
    return self.secrets.count;
    
}

-(NSArray*)getAnySecretsForPlayer:(LLPlayer*)player
{
    
    NSMutableArray* secretsToReturn = [[NSMutableArray alloc] init];
    
    if (self.secrets != nil)
    {
        
        if (player != nil)
        {
            
            for (Secret* secret in self.secrets)
            {
                if ([secret.player.playerid isEqualToString:player.playerid])
                {
                    [secretsToReturn addObject:secret];
                }
            }
            
        }
        
    }
    
    return [NSArray arrayWithArray:secretsToReturn];
    
}


#pragma mark
#pragma mark AI Stuff

-(NSArray*)nonSecretedPlayers
{
    
    NSMutableArray* allPlayers = [NSMutableArray arrayWithArray:[GameModel sharedInstance].players];
    NSMutableArray* secretedPlayers = [[NSMutableArray alloc] init];
    
    // find players that I have a secret on and mark them for removal
    [allPlayers enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        [self.secrets enumerateObjectsUsingBlock:^(Secret* secret, NSUInteger idx, BOOL *stop) {
            
            if ([secret.player.playerid isEqualToString:player.playerid])
            {
                [secretedPlayers addObject:player];
            }
            
        }];
        
    }];
    
    // remove players I have a secret on
    [allPlayers removeObjectsInArray:secretedPlayers];
    
    // return result
    return [NSArray arrayWithArray:allPlayers];
    
}

#pragma mark
#pragma mark Misc

-(void)protectWithHandmaid
{
    [self setIsProtected:YES];
}


@end
