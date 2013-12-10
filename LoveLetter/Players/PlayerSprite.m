//
//  PlayerSprite.m
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "PlayerSprite.h"

#import "Card.h"
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
        [self setCardBadgePositions:[self determineCardBadgePositions]];
        
//        for (NSValue* val in self.cardBadgePositions)
//        {
//            CGPoint pos = [val CGPointValue];
//            CCSprite* sprite = [CCSprite spriteWithFile:@"guard-badge.png"];
//            [sprite setScale:0.5];
//            [sprite setPosition:pos];
//            [self addChild:sprite];
//        }
        
        // colors
        self.cyan   = ccc3(0, 150, 150);
        self.orange = ccc3(255,165,0);
        self.maroon = ccc3(139,0,0);
        
        
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

-(NSArray*)determineCardBadgePositions
{
    return [NSArray arrayWithObjects:
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 0))],
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 1))],
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 2))],
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 3))],
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 4))],
            [NSValue valueWithCGPoint:ccpAdd(ccpAdd(self.label.position, ccp(80, 0)), ccpMult(ccp(115, 0), 5))],
            nil];
}

-(CCSprite*)createLabelBackground
{
    CCSprite* sprite = [CCSprite spriteWithFile:@"playername-background.png"];
    [sprite setColor:self.cyan];
    [sprite setScaleX:0.65f * CC_CONTENT_SCALE_FACTOR()];
    [sprite setScaleY:0.40f * CC_CONTENT_SCALE_FACTOR()];
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
            [token setScale:1.0f * CC_CONTENT_SCALE_FACTOR()];
            [self addChild:token z:0 tag:75];
        }
    }
}

-(void)positionPlayedCards
{
    for (int i = 0; i < self.player.cardsPlayed.count; i++)
    {
        CCSprite* sprite = [self.player.cardsPlayed[i] createBadgeSpriteNormal];
        NSValue*  value  = [self.cardBadgePositions objectAtIndex:i];
        [sprite setPosition:[value CGPointValue]];
        [self addChild:sprite z:0 tag:76];
    }
}

-(void)cleanupUnusedSprites
{
    // remove old sprites
    NSMutableArray* toRemove = [[NSMutableArray alloc] init];
    for (CCNode* child in self.children)
    {

        if (child.tag == 75 ||
            child.tag == 76)
        {
            [toRemove addObject:child];
        }
        
    }

    for (CCNode* node in toRemove)
    {
        [self removeChild:node cleanup:YES];
    }
}

@end
