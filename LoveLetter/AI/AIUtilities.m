//
//  AIUtilities.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "AIUtilities.h"
#import "Play.h"
#import "LLPlayer.h"
#import "Secret.h"
#import "Card.h"
#import "Deck.h"
#import "GameModel.h"

@implementation AIUtilities

+(Play*)makePlayForPlayer:(LLPlayer*)player
{
    
    Play* play = nil;
    
    // have to have 2 cards
    if (player.cardsInHand.count == 2)
    {
        
        // get the card pattern
        NSString* cardPattern = [self cardPatternForCards:player.cardsInHand];
        
        
        // setup play properties
        LLPlayer* target = nil;
        Card* card = nil;
        NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
        
        
        // match pattern and make play
        
        // 20000000, Guard, Guard
        if ([cardPattern isEqualToString:@"20000000"])
        {
            
            // have to play a guard
            card = (Card*)[player.cardsInHand lastObject];
         
            // first find any guard secrets and remove them since you can't guard a guard
            NSArray* secrets = [self removeGuardSecretsFrom:player.secrets];
            
            if (secrets.count > 0)
            {
                
                // get a list of all players with non-guard secrets
                NSMutableArray* secretedPlayers = [[NSMutableArray alloc] init];
                [secrets enumerateObjectsUsingBlock:^(Secret* secret, NSUInteger idx, BOOL *stop) {
                    
                    [secretedPlayers addObject:secret.player];
                    
                }];
                
                // find top scoring players in that list and set one as the target
                target = [self randomPlayerFromArray:[self playersWithMostPointsFromList:[NSArray arrayWithArray:secretedPlayers]]];
                
                // get the target's secret cardValue and store it in the options
                [secrets enumerateObjectsUsingBlock:^(Secret* secret, NSUInteger idx, BOOL *stop) {
                    
                    if ([secret.player.playerid isEqualToString:target.playerid])
                    {
                        [options setObject:[NSNumber numberWithInteger:secret.cardValue] forKey:@"guardCardTarget"];
                    }
                    
                }];
                
            }
            else  // no secrets left
            {
                
                // find top scoring players and set one as the target
                target = [self randomPlayerFromArray:[self playersWithMostPointsFromList:[GameModel sharedInstance].players]];
                
                // pick most likely card to guard
                NSInteger* mostLikelyCardValue = [self randomMostLikelyCard:player];
                [options setObject:[NSNumber numberWithInteger:mostLikelyCardValue] forKey:@"guardCardTarget"];
                
            }
            
        }
        
        // 11000000, Guard, Priest
        if ([cardPattern isEqualToString:@"11000000"])
        {
            
            //
            
        }
        
        // 10100000, Guard, Baron
        if ([cardPattern isEqualToString:@"10100000"])
        {
            
            //
            
        }
        
        // 10010000, Guard, Handmaid
        if ([cardPattern isEqualToString:@"10010000"])
        {
            
            //
            
        }
        
        // 10001000, Guard, Prince
        if ([cardPattern isEqualToString:@"10001000"])
        {
            
            //
            
        }
        
        // 10000100, Guard, King
        if ([cardPattern isEqualToString:@"10000100"])
        {
            
            //
            
        }
        
        // 10000010, Guard, Countess
        if ([cardPattern isEqualToString:@"10000010"])
        {
            
            //
            
        }
        
        // 10000001, Guard, Princess
        if ([cardPattern isEqualToString:@"10000001"])
        {
            
            //
            
        }
        
        // 02000000, Priest, Priest
        if ([cardPattern isEqualToString:@"02000000"])
        {
            
            //
            
        }
        
        // 01100000, Priest, Baron
        if ([cardPattern isEqualToString:@"01100000"])
        {
            
            //
            
        }
        
        // 01010000, Priest, Handmaid
        if ([cardPattern isEqualToString:@"01010000"])
        {
            
            //
            
        }
        
        // 01001000, Priest, Prince
        if ([cardPattern isEqualToString:@"01001000"])
        {
            
            //
            
        }
        
        // 01000100, Priest, King
        if ([cardPattern isEqualToString:@"01000100"])
        {
            
            //
            
        }
        
        // 01000010, Priest, Countess
        if ([cardPattern isEqualToString:@"01000010"])
        {
            
            //
            
        }
        
        // 01000001, Priest, Princess
        if ([cardPattern isEqualToString:@"01000001"])
        {
            
            //
            
        }
        
        // 00200000, Baron, Baron
        if ([cardPattern isEqualToString:@"00200000"])
        {
            
            //
            
        }
        
        // 00110000, Baron, Handmaid
        if ([cardPattern isEqualToString:@"00110000"])
        {
            
            //
            
        }
        
        // 00101000, Baron, Prince
        if ([cardPattern isEqualToString:@"00101000"])
        {
            
            //
            
        }
        
        // 00100100, Baron, King
        if ([cardPattern isEqualToString:@"00100100"])
        {
            
            //
            
        }
        
        // 00100010, Baron, Countess
        if ([cardPattern isEqualToString:@"00100010"])
        {
            
            //
            
        }
        
        // 00100001, Baron, Princess
        if ([cardPattern isEqualToString:@"00100001"])
        {
            
            //
            
        }
        
        // 00020000, Handmaid, Handmaid
        if ([cardPattern isEqualToString:@"00020000"])
        {
            
            //
            
        }
        
        // 00011000, Handmaid, Prince
        if ([cardPattern isEqualToString:@"00011000"])
        {
            
            //
            
        }
        
        // 00010100, Handmaid, King
        if ([cardPattern isEqualToString:@"00010100"])
        {
            
            //
            
        }
        
        // 00010010, Handmaid, Countess
        if ([cardPattern isEqualToString:@"00010010"])
        {
            
            //
            
        }
        
        // 00010001, Handmaid, Princess
        if ([cardPattern isEqualToString:@"00010001"])
        {
            
            //
            
        }
        
        // 00002000, Prince, Prince
        if ([cardPattern isEqualToString:@"00002000"])
        {
            
            //
            
        }
        
        // 00001100, Prince, King
        if ([cardPattern isEqualToString:@"00001100"])
        {
            
            //
            
        }
        
        // 00001010, Prince, Countess
        if ([cardPattern isEqualToString:@"00001010"])
        {
            
            //
            
        }
        
        // 00001001, Prince, Princess
        if ([cardPattern isEqualToString:@"00001001"])
        {
            
            //
            
        }
        
        // 00000110, King, Countess
        if ([cardPattern isEqualToString:@"00000110"])
        {
            
            //
            
        }
        
        // 00000101, King, Princess
        if ([cardPattern isEqualToString:@"00000101"])
        {
            
            //
            
        }
        
        // 00000011, Countess, Princess
        if ([cardPattern isEqualToString:@"00000011"])
        {
            
            //
            
        }
        
        
        play = [Play playWithCard:card andTarget:target andOptions:[NSDictionary dictionaryWithDictionary:options]];
        
    }
    
    NSAssert(play != nil, @"Play cannot be nil");
    
    return play;
    
}

+(NSString*)cardPatternForCards:(NSArray*)cards
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

+(NSInteger)randomMostLikelyCard:(LLPlayer*)player
{
    return [self randomMostLikelyCard:player includeGuards:NO];
}

+(NSInteger)randomMostLikelyCard:(LLPlayer*)player includeGuards:(BOOL)includeGuards
{
    
    // get a copy of the players array
    NSArray* players = [GameModel sharedInstance].players;
    
    // create the cardsInplay array, starting with this players cards in hand
    NSMutableArray* cardsInPlay = [NSMutableArray arrayWithArray:player.cardsInHand];
    
    // add the remaining cards in play from the other players
    for (LLPlayer* p in players)
    {
        cardsInPlay = [[cardsInPlay arrayByAddingObjectsFromArray:p.cardsPlayed] mutableCopy];
    }
    
    // set max counts per card type
    NSInteger guards     = kDefaultCardCount_Guard;
    NSInteger priests    = kDefaultCardCount_Priest;
    NSInteger barons     = kDefaultCardCount_Baron;
    NSInteger handmaids  = kDefaultCardCount_Handmaid;
    NSInteger princes    = kDefaultCardCount_Prince;
    NSInteger kings      = kDefaultCardCount_King;
    NSInteger countesses = kDefaultCardCount_Countess;
    NSInteger princesses = kDefaultCardCount_Princess;
    
    
    // loop through and subtract cards based on what has been played
    for (Card* card in cardsInPlay)
    {
        
        switch (card.cardValue)
        {
                
            case kCardValue_Guard:
                guards--;
                break;
                
            case kCardValue_Priest:
                priests--;
                break;
                
            case kCardValue_Baron:
                barons--;
                break;
                
            case kCardValue_Handmaid:
                handmaids--;
                break;
                
            case kCardValue_Prince:
                princes--;
                break;
                
            case kCardValue_King:
                kings--;
                break;
                
            case kCardValue_Countess:
                countesses--;
                break;
                
            case kCardValue_Princess:
                princesses--;
                break;
                
        }
        
    }
    
    // see what cards are left and crate an array
    NSMutableDictionary* availableCards = [[NSMutableDictionary alloc] init];
    if (guards > 0 && includeGuards)
    {
        [availableCards setObject:[NSNumber numberWithInteger:guards] forKey:[NSNumber numberWithInteger:kCardValue_Guard]];
    }
    
    if (priests > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:priests] forKey:[NSNumber numberWithInteger:kCardValue_Priest]];
    }
    
    if (barons > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:barons] forKey:[NSNumber numberWithInteger:kCardValue_Baron]];
    }
    
    if (handmaids > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:handmaids] forKey:[NSNumber numberWithInteger:kCardValue_Handmaid]];
    }
    
    if (princes > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:princes] forKey:[NSNumber numberWithInteger:kCardValue_Prince]];
    }
    
    if (kings > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:kings] forKey:[NSNumber numberWithInteger:kCardValue_King]];
    }
    
    if (countesses > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:countesses] forKey:[NSNumber numberWithInteger:kCardValue_Countess]];
    }
    
    if (princesses > 0)
    {
        [availableCards setObject:[NSNumber numberWithInteger:princesses] forKey:[NSNumber numberWithInteger:kCardValue_Princess]];
    }
    
    // sort the array highest to lowest
    NSArray* keys = [availableCards allKeys];
    NSMutableArray* sortedKeys = [[keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber* first = [availableCards objectForKey:a];
        NSNumber* second = [availableCards objectForKey:b];
        return [second compare:first];
    }] mutableCopy];
    
    // remove all but the highest count cards
    NSMutableArray* keysToRemove = [[NSMutableArray alloc] init];
    NSInteger numberToBeat = [[sortedKeys firstObject] integerValue];
    [sortedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] < numberToBeat)
        {
            [keysToRemove addObject:obj];
        }
    }];
    [sortedKeys removeObjectsInArray:keysToRemove];
    
    // pick one of the highest count cards at random and return its card value
    if (sortedKeys.count > 0)
    {
        NSInteger max = sortedKeys.count - 1;
        NSInteger min = 0;
        return [[sortedKeys objectAtIndex:((arc4random() % (max-min+1)) + min)] integerValue];
        //((arc4random() % (max-min+1)) + min)
    }
    else
    {
        // return princess by default
        return kCardValue_Princess;
    }
    
}

+(NSArray*)playersWithMostPointsFromList:(NSArray*)playersList
{
    
    // find the top score value
    __block NSInteger topScore = 0;
    [playersList enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        if (player.score > topScore)
        {
            topScore = player.score;
        }
        
    }];
    
    // find the players with that score
    NSMutableArray* topScorePlayers = [[NSMutableArray alloc] init];
    [playersList enumerateObjectsUsingBlock:^(LLPlayer* player, NSUInteger idx, BOOL *stop) {
        
        if (player.score == topScore)
        {
            [topScorePlayers addObject:player];
        }
        
    }];
    
    return [NSArray arrayWithArray:topScorePlayers];
    
}

+(NSArray*)removeGuardSecretsFrom:(NSArray*)secrets
{
    
    // copy secrets
    NSMutableArray* allSecrets = [secrets mutableCopy];
    
    // remove any guard secrets
    if (secrets.count > 0)
    {
        
        NSMutableArray* guardSecrets = [[NSMutableArray alloc] init];
        [allSecrets enumerateObjectsUsingBlock:^(Secret* secret, NSUInteger idx, BOOL *stop) {
            
            if (secret.cardValue == kCardValue_Guard)
            {
                [guardSecrets addObject:secret];
            }
            
        }];
        [allSecrets removeObjectsInArray:guardSecrets];
        
    }
    
    // return results
    return [NSArray arrayWithArray:allSecrets];
    
}

+(LLPlayer*)randomPlayerFromArray:(NSArray*)players
{
    LLPlayer* player = nil;
    
    if (players.count > 1)
    {
        NSInteger max = players.count - 1;
        NSInteger min = 0;
        player =  (LLPlayer*)[players objectAtIndex:((arc4random() % (max-min+1)) + min)];
    }
    else
    {
        player =  (LLPlayer*)[players lastObject];
    }
    
    return player;
}

@end
