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
        [self setContentSize:CGSizeMake(WIN_SIZE.width, 200)];
        
        self.player = player;
        [self setAnchorPoint:CGPointZero];
        
        // colors
        cyan = ccc3(0, 150, 150);
        
        // create sprites
        self.label = [self createLabel];
        self.labelBackground = [self createLabelBackground];
        
        // position sprites
        [self.label           setAnchorPoint:ccp(0, 0)];
        [self.labelBackground setAnchorPoint:ccp(0, 0)];
        
        [self.label             setPosition:ccp(25, 70)];
        [self.labelBackground   setPosition:ccpAdd(self.label.position, ccp(-10, -10))];
        
        // add sprites
        [self addChild:self.label];
        [self addChild:self.labelBackground z:self.label.zOrder-1];
        
        [self setTokens];
    }
    return self;
}

-(CCSprite*)createLabelBackground
{
    CCSprite* sprite = [CCSprite spriteWithFile:@"playername-background.png"];
    [sprite setColor:cyan];
    [sprite setScaleX:0.65f];
    [sprite setScaleY:0.4f];
    return sprite;
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
        CGPoint startingPosition =  ccpAdd(self.label.position, ccp((self.labelBackground.contentSize.width * self.labelBackground.scaleX), -3));
        CGPoint offset = ccp(50, 0);
        
        for (int i = 0; i < self.player.score; i++)
        {
            CCSprite* token = [CCSprite spriteWithFile:@"token.png"];
            [token setColor:ccc3(95, 10, 0)];
            CGPoint pos     = ccpAdd(startingPosition, ccpMult(offset, i));
            [token setPosition:pos];
            [token setAnchorPoint:CGPointZero];
            [self addChild:token];
            CCLOG(@"added token sprite %d", i+1);
        }
    }
}

@end
