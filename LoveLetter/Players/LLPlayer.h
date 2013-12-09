//
//  LLPlayer.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;
@class Play;
@class Secret;

@interface LLPlayer : NSObject
{
    //
}


// properties
@property (readonly) NSString* playerid;
@property (readonly) NSArray* secrets;
@property (readonly) NSArray* cardsInHand;
@property (readonly) NSArray* cardsPlayed;
@property (readonly) NSInteger score;
@property (readonly) BOOL isProtected;
@property (readwrite) BOOL isAI;



// selectors
+(id)playerWithPlayerId:(NSString*)playerId;
-(NSInteger)addCard:(Card*)card;
-(NSInteger)removeCard:(Card*)card;
-(NSInteger)removeCardByNumber:(NSInteger)cardNumber;
-(void)invalidateAllCards;
-(void)startTurn;
-(void)endTurn;
-(void)startRound;
-(void)endRound;
-(Play*)makePlay;
-(NSInteger)ScoreUp;
-(NSInteger)addSecret:(Secret*)secret;
-(void)playCard:(Card*)playedCard;
-(NSInteger)addSecretForPlayer:(LLPlayer*)player andCardValue:(NSInteger)cardValue;
-(NSInteger)removeSecretForPlayer:(LLPlayer*)player andCard:(NSInteger)cardValue;
-(NSInteger)removeAnySecretsForPlayer:(LLPlayer*)player;
-(NSArray*)getAnySecretsForPlayer:(LLPlayer*)player;
-(NSArray*)nonSecretedPlayers;
-(void)protectWithHandmaid;

@end
