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
        
        // create new deck instance
        [self setDeck:[[Deck alloc] init]];
        
        // burn a card
        [self setBurnedCard:[self.deck drawCard]];
        
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
            
        }
    }
    return self;
}

@end
