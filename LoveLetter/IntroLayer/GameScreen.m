//
//  GameScreen.m
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "GameScreen.h"

#import "PlayerSprite.h"
#import "Constants.h"
#import "GameModel.h"
#import "LLPlayer.h"

@implementation GameScreen

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene*)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScreen *layer = [GameScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init
{
    if (self = [super init])
    {
        //
    }
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [self layoutPlayerSprites];
//    [self layoutHumanPlayerSprite];
}

-(void)layoutPlayerSprites
{
    CGPoint startingPosition = ccp(0, 900);
    CGPoint offset = ccp(0, -200);
    
    int counter = 0;
    CCLOG(@"game model contains %d players", [GameModel sharedInstance].players.count);
    for (LLPlayer* player in [GameModel sharedInstance].players)
    {
        PlayerSprite* playerSprite = [[PlayerSprite alloc] initWithPlayer:player];
        if (player.isAI)
        {
            [playerSprite setPosition:ccpAdd(startingPosition, ccpMult(offset, counter))];
            [self addChild:playerSprite];
            CCLOG(@"created sprite for ai player %@", player.playerid);
            counter++;
        }
        else
        {
            [playerSprite setPosition:ccp(0, 300)];
            [self addChild:playerSprite];
        }
    }
}

@end
