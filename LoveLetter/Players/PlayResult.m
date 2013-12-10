//
//  PlayResult.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "PlayResult.h"
#import "Card.h"
#import "LLPlayer.h"
#import "Deck.h"
#import "Play.h"
#import "Secret.h"
#import "GameModel.h"

@implementation PlayResult

+(void)player:(LLPlayer*)player makesPlay:(Play*)play
{
    
    // get values from play
    LLPlayer* target      = play.target;
    Card* card            = play.card;
    NSDictionary* options = play.options;
    

    __block NSString* cardListString = @"";
    [player.cardsInHand enumerateObjectsUsingBlock:^(Card* c, NSUInteger idx, BOOL *stop) {
        
        cardListString = [cardListString stringByAppendingString:[NSString stringWithFormat:@"%@,", [self cardNamefromValue:c.cardValue]]];
        
    }];
    cardListString = [cardListString substringToIndex:cardListString.length-1];
    
    
    // is it a valid card?
    if ([self isValidPlay:player playsCard:card onPlayer:target withOptions:options] == NO)
    {
        NSAssert(true, @"");
        return;
    }
    
    // remove played card from players hand and into theit played cards
    [player playCard:card];
    
    // if you chose a protected player then its a wasted play
    if (target.isProtected == NO)
    {
    
        // target is not protected, so proceed with the play
        switch (card.cardValue)
        {

            case kCardValue_Guard:
                [self playGuard:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_Priest:
                [self playGuard:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_Baron:
                [self playBaron:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_Handmaid:
                [self playHandmaid:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_Prince:
                [self playPrince:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_King:
                [self playKing:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            case kCardValue_Countess:
                [self playCountess:player playsCard:card onPlayer:target withOptions:options];
                break;
                
            default:
                break;
        }
        
    }
    
    NSString* msg = [NSString stringWithFormat:@"\n-DEBUG INFO:--------\nPlayer %@ has cards: %@\n", player.playerid, cardListString];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"They chose card %@\nAnd target %@\n--------------------\n", [self cardNamefromValue:play.card.cardValue], play.target.playerid]];
    NSLog(@"%@", msg);
    
    NSAssert(player.cardsInHand.count == 1, @"Player should have played card %@", [self cardNamefromValue:card.cardValue]);
    
}

+(NSString*)cardNamefromValue:(NSInteger)value
{
    switch (value)
    {
            
        case 1:
            return @"Guard";
            break;
            
        case 2:
            return @"Guard";
            break;
            
        case 3:
            return @"Guard";
            break;
            
        case 4:
            return @"Guard";
            break;
            
        case 5:
            return @"Guard";
            break;
            
        case 6:
            return @"Guard";
            break;
            
        case 7:
            return @"Guard";
            break;
            
        case 8:
            return @"Guard";
            break;
            
        default:
            return @"Undefined";
            break;
    }
}




#pragma mark
#pragma mark Play Cards


+(void)playGuard:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    NSInteger guardedCardValue = [[options objectForKey:@"guardCardTarget"] integerValue];
    [target.cardsInHand enumerateObjectsUsingBlock:^(Card* targetCard, NSUInteger idx, BOOL *stop) {
        
        if (targetCard.cardValue == guardedCardValue)
        {
            [target removeCard:targetCard];
        }
        
    }];
    
}


+(void)playPriest:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    Card* secretCard = (Card*)[target.cardsInHand lastObject];
    Secret* secret = [Secret secretForPlayer:target andCardValue:secretCard.cardValue];
    [player addSecret:secret];
}


+(void)playBaron:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    // get the target's card in hand
    Card* targetsCard = [target.cardsInHand lastObject];
    
    // get the player's other card in hand
    __block Card* playersOtherCard = nil;
    [player.cardsInHand enumerateObjectsUsingBlock:^(Card* cardInHand, NSUInteger idx, BOOL *stop) {
       
        if (cardInHand.cardNumber != card.cardNumber)
        {
            playersOtherCard = cardInHand;
        }
        
    }];
    
    if (targetsCard != nil && playersOtherCard != nil)
    {
        
        if (targetsCard.cardValue < playersOtherCard.cardValue)
        {
            // player wins
            [target removeCard:targetsCard];
            NSAssert(target.cardsInHand.count == 0, @"Target should have discarded card in hand");
        }
        else if (playersOtherCard.cardValue < targetsCard.cardValue)
        {
            // target wins
            [player removeCard:playersOtherCard];
            NSAssert(player.cardsInHand.count == 0, @"Player should have discarded card in hand");
        }
        else
        {
            // push, nothing happens, but now secrets are known
            Secret* playersSecret = [Secret secretForPlayer:target andCardValue:targetsCard.cardValue];
            Secret* targetsSecret = [Secret secretForPlayer:player andCardValue:playersOtherCard.cardValue];
            
            [player addSecret:playersSecret];
            [target addSecret:targetsSecret];
            
            NSAssert((player.cardsInHand.count == 0 && target.cardsInHand.count == 0), @"No one should have discarded a card");
        }
        
    }

}


+(void)playHandmaid:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    if (target.playerid != player.playerid)
    {
        return;
    }
    
    [player protectWithHandmaid];
    
}


+(void)playPrince:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    // target discards card in hand
    Card* targetsCardInHand = (Card*)[target.cardsInHand lastObject];
    [target playCard:targetsCardInHand];
    NSAssert(target.cardsInHand.count == 0, @"Target of prince should have ditched the only card in their hand.");
    
    // if the target's discarded card was a princess then they don't draw a new card
    if (targetsCardInHand.cardValue == kCardValue_Princess)
    {
        return;
    }
    
    // otherwise they target now draws a new card
    if ([GameModel sharedInstance].deck.cards.count > 0)
    {
        [target addCard:[[GameModel sharedInstance].deck drawCard]];
        NSAssert(target.cardsInHand.count == 1, @"Target of prince should have drawn a card to replace the one they played");
    }
    else
    {
        
        // no cards left in deck - ok to draw burned card
        Card* burnedCard = [[GameModel sharedInstance] drawBurnedCard];
        if (burnedCard != nil)
        {
            [target addCard:burnedCard];
        }
    }
    
}


+(void)playKing:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{

    // get the target's card in hand
    Card* targetsCard = [target.cardsInHand lastObject];
    
    // get the player's other card in hand
    __block Card* playersOtherCard = nil;
    [player.cardsInHand enumerateObjectsUsingBlock:^(Card* cardInHand, NSUInteger idx, BOOL *stop) {
        
        if (cardInHand.cardNumber != card.cardNumber)
        {
            playersOtherCard = cardInHand;
        }
        
    }];
    
    // swap cards
    [target removeCard:targetsCard];
    [player addCard:targetsCard];
    
    [player removeCard:playersOtherCard];
    [target addCard:playersOtherCard];
    
}


+(void)playCountess:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    // nothing to do here (for now)
    
}



#pragma mark
#pragma mark Misc

+(BOOL)isValidPlay:(LLPlayer*)player playsCard:(Card*)card onPlayer:(LLPlayer*)target withOptions:(NSDictionary*)options
{
    
    // is it a valid card?
    __block BOOL isValidCard = NO;
    [player.cardsInHand enumerateObjectsUsingBlock:^(Card* playerCard, NSUInteger idx, BOOL *stop) {
        
        if (playerCard.cardNumber == card.cardNumber)
        {
            isValidCard = YES;
        }
        
    }];
    
    // is it a valid
    BOOL isValidTarget = NO;
    if (target.cardsInHand.count > 0)
    {
        if (card.cardValue == kCardValue_Handmaid || card.cardValue == kCardValue_Countess)
        {
            isValidTarget = YES;
        }
        else
        {
            if (player.playerid != target.playerid)
            {
                isValidTarget = YES;
            }
        }
    }
    
    // vaild options?
    BOOL isValidOptions = NO;
    if (card.cardValue == kCardValue_Guard)
    {
        if ([options objectForKey:@"guardCardTarget"])
        {
            isValidOptions = YES;
        }
    }
    else
    {
        // no options necessary if not a guard
        isValidOptions = YES;
    }
    

    return ( isValidCard && isValidTarget && isValidOptions );

}

@end
