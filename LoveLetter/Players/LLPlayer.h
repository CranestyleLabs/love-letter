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
@property (readwrite) BOOL isAI;


// selectors
+(id)playerWithPlayerId:(NSString*)playerId;
-(NSInteger)addCard:(Card*)card;
-(NSInteger)removeCard:(Card*)card;
-(NSInteger)removeCardByNumber:(NSInteger)cardNumber;
-(void)invalidateAllCards;
-(void)turnStart;
-(void)turnEnd;
-(Play*)makePlay;
-(NSInteger)ScoreUp;
-(NSInteger)addSecretForPlayer:(LLPlayer*)player andCardValue:(NSInteger)cardValue;
-(NSInteger)removeSecretForPlayer:(LLPlayer*)player andCard:(NSInteger)cardValue;
-(NSInteger)removeAnySecretsForPlayer:(LLPlayer*)player;
-(NSArray*)getAnySecretsForPlayer:(LLPlayer*)player;



@end
