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


@interface LLPlayer ()

@property (readwrite) NSString* playerid;
@property (readwrite) NSArray* secrets;
@property (readwrite) NSArray* cardsInHand;
@property (readwrite) NSArray* cardsPlayed;
@property (readwrite) NSInteger score;

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
    }
    return self;
}


#pragma mark
#pragma mark Cards

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

-(void)turnStart
{
    
    [self addCard:[[GameModel sharedInstance].deck drawCard]];
    
}

-(void)turnEnd
{
    
    // end turn clean up
    
}


#pragma mark
#pragma mark Play

-(Play*)makePlay
{
    
    Play* play = nil;
    
    //
    
    return play;
    
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
    [self setScore:self.score++];
    return self.score;
}


#pragma mark
#pragma mark Secrets

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

@end
