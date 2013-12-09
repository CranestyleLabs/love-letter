//
//  PlayerSprite.m
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "PlayerSprite.h"

#import "Constants.h"
#import "LLPlayer.h"

@implementation PlayerSprite

-(id)initWithPlayer:(LLPlayer*)player
{
    if (self = [super init])
    {
        [self setColor:ccBLUE];
        [self setContentSize:CGSizeMake(WIN_SIZE.width, 200)];
        
        self.player = player;
        
        // create sprites
        self.label = [self createLabel];
        
        // position sprites
        [self.label setPosition:ccp(10, 80)];
        
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
    NSString* labelString;
    if (self.player.isAI)
    {
        labelString = [NSString stringWithFormat:@"Player %d Cards Played (AI)", playerNumber];
    }
    else
    {
        labelString = [NSString stringWithFormat:@"Player %d (Human)", playerNumber];
    }
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:labelString fntFile:FONT_BIG];
    [label setAnchorPoint:CGPointZero];
    return label;
}

-(void)setTokens
{
    if (self.player.score > 0)
    {
        CGPoint startingPosition =  ccpAdd(self.label.position, ccp(self.label.contentSize.width + 20, -3));
        CGPoint offset = ccp(50, 0);
        
        for (int i = 0; i < self.player.score; i++)
        {
            CCSprite* token = [CCSprite spriteWithFile:@"token.png"];
            CGPoint pos     = ccpAdd(startingPosition, ccpMult(offset, i));
            [token setPosition:pos];
            [token setAnchorPoint:CGPointZero];
            [self addChild:token];
            CCLOG(@"added token sprite %d", i+1);
        }
    }
}

@end
