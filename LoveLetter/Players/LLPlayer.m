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


@interface LLPlayer ()

@property (readwrite) NSString* playerid;
@property (readwrite) NSArray* secrets;
@property (readwrite) NSArray* cardsInHand;
@property (readwrite) NSArray* cardsPlayed;

@end


@implementation LLPlayer

+(id)player
{
    return [[self alloc] init];
}

- (id)initWithPlayerId:(NSString*)playerid
{
    if (self = [super init])
    {
        [self setPlayerid:playerid];
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


#pragma mark
#pragma mark Play

-(Play*)makePlay
{
    
    if (self.cardsInHand.count == 2)
    {
        
        //
        
    }
    
}


#pragma mark
#pragma mark Secrets

-(NSInteger)addSecretForPlayer:(LLPlayer*)player andCard:(id)card
{

    // if secrets array hasn't been initialized yet, init it now
    if (self.secrets == nil)
    {
        [self setSecrets:[[NSArray alloc] init]];
    }
         
    
    if (player != nil && card != nil)
    {
        
        // does this secret already exist?
        for (Secret* secret in self.secrets)
        {
            if ([secret.player.playerid isEqualToString:player.playerid] && [secret.card isEqual:card])
            {
                // secret already in array, return
                return self.secrets.count;
            }
        }
            
        // secret not in array, add it
        NSMutableArray* copySecrets = [NSMutableArray arrayWithArray:self.secrets];
        [copySecrets addObject:[Secret secretForPlayer:player andCard:card]];
        
    }
    
    return self.secrets.count;
    
}

-(NSInteger)removeSecretForPlayer:(LLPlayer*)player andCard:(id)card
{
    
    if (self.secrets != nil)
    {
        
        if (player != nil && card != nil)
        {
            
            NSMutableArray* copySecrets = [NSMutableArray arrayWithArray:self.secrets];
            NSMutableArray* secretsToRemove = [[NSMutableArray alloc] init];
            
            for (Secret* secret in self.secrets)
            {
                if ([secret.player.playerid isEqualToString:player.playerid] && [secret.card isEqual:card])
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

@end
