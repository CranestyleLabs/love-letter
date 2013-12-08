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

-(Play*)makePlay
{
    
    if (self.cardInHand != nil && self.drawnCard != nil)
    {
        
    }
    
}

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

@end
