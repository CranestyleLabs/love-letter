//
//  HumanPlayerSprite.m
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "HumanPlayerSprite.h"

#import "Constants.h"
#import "LLPlayer.h"

@implementation HumanPlayerSprite

-(id)initWithPlayer:(LLPlayer*)player
{
    if (self = [super init])
    {
        self.player = player;
        
        // create sprites
        self.label = [self createLabel];
        
        // position sprites
        [self.label setPosition:ccp(-180, 80)];
        
        // add sprites
        [self addChild:self.label];
        
        [self setTokens];
    }
    return self;
}

-(CCLabelBMFont*)createLabel
{
    NSString* playerID = self.player.playerid;
    NSString* playerIDNumber = [playerID substringFromIndex:[playerID length] -1];
    int playerNumber = [playerIDNumber intValue] + 1;
    NSString* labelString = [NSString stringWithFormat:@"Player %d)", playerNumber];
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:labelString fntFile:FONT_BIG];
    return label;
}

-(void)setTokens
{
    if (self.player.score > 0)
    {
        CGPoint startingPosition =  ccpAdd(self.label.position, ccp(225, 0));
        CGPoint offset = ccp(50, 0);
        
        for (int i = 0; i < self.player.score; i++)
        {
            CCSprite* token = [CCSprite spriteWithFile:@"token.png"];
            CGPoint pos     = ccpAdd(startingPosition, ccpMult(offset, i));
            [token setPosition:pos];
            [self addChild:token];
            CCLOG(@"added token sprite %d", i+1);
        }
    }
}

@end
