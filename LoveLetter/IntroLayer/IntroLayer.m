//
//  IntroLayer.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright Threadbare Games 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"

#import "GameScreen.h"
#import "Constants.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init]) )
    {
        CCSprite* cardBack = [CCSprite spriteWithFile:@"back-card.png"];
        [cardBack setScale:0.9f * CC_CONTENT_SCALE_FACTOR()];
        [cardBack setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        [self addChild:cardBack];
        
        CCLabelBMFont* name = [CCLabelBMFont labelWithString:@"Love Letter" fntFile:FONT_BIG];
        [name setPosition:ccpAdd(cardBack.position, ccp(0, -200))];
        [self addChild:name];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    id delay = [CCDelayTime actionWithDuration:2];
    id go    = [CCCallBlock actionWithBlock:^{
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScreen scene] ]];
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    }];
    id seq   = [CCSequence actionOne:delay two:go];
    [self runAction:seq];
}
@end
