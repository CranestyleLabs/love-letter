//
//  GameScreen.m
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "GameScreen.h"

#import "PlayerSprite.h"
#import "Card.h"
#import "Constants.h"
#import "GameModel.h"
#import "LLPlayer.h"
#import "Deck.h"
#import "Play.h"

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
        indent = 20.0f;
        
        cardButtonOldPos = ccp(WIN_CENTER.x + 90, 100);
        cardButtonNewPos = ccp(WIN_CENTER.x - 90, 100);
        chosenCardPos    = ccp(WIN_CENTER.x, WIN_CENTER.y + 100);
        cancelButtonPos  = ccp(WIN_CENTER.x - 120, 300);
        playButtonPos    = ccp(WIN_CENTER.x + 120, 300);
        
        CCSprite* bg = [CCSprite spriteWithFile:@"llbg.png"];
        [bg setPosition:WIN_CENTER];
        [self addChild:bg z:0];
    }
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    [[GameModel sharedInstance] startRound];
    
    [self layoutPlayerSprites];
    
    CCLabelBMFont* labelInHand = [CCLabelBMFont labelWithString:@"In Hand" fntFile:FONT_BIG];
    [labelInHand setPosition:ccp(WIN_CENTER.x, 190)];
    [self addChild:labelInHand];
    
    CCLabelBMFont* labelPlayed = [CCLabelBMFont labelWithString:@"Played" fntFile:FONT_BIG];
    [labelPlayed setAnchorPoint:CGPointZero];
    [labelPlayed setPosition:ccp(indent + 25, 325)];
    [self addChild:labelPlayed];
    [self updateCardsUI];
    
    [self layoutDrawDeck];
    drawDeckCount = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", 0] fntFile:FONT_BIG];
    [self addChild:drawDeckCount];
    [self updateDrawDeckCardCount];
    [[GameModel sharedInstance] addObserver:self forKeyPath:@"deck" options:0 context:nil];
}

-(void)onExit
{
    [super onExit];
    
    [[[GameModel sharedInstance] deck] removeObserver:self forKeyPath:@"deck"];
}

-(void)layoutPlayerSprites
{
    CGPoint startingPosition = ccp(indent, 900 - indent);
    CGPoint offset = ccp(0, -190);
    
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
            [playerSprite setPosition:ccp(indent, 300)];
            [self addChild:playerSprite];
            CCLOG(@"created sprite for human player %@", player.playerid);
        }
        // add playerSprite to Array
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.playerSprites];
        [array addObject:playerSprite];
        self.playerSprites = [NSArray arrayWithArray:array];
    }
}

-(void)updateCardsUI
{
    [self.cardButtonNew removeFromParentAndCleanup:YES];
    [self.cardButtonOld removeFromParentAndCleanup:YES];
    
    LLPlayer* humanPlayer;
    for (LLPlayer* player in [GameModel sharedInstance].players)
    {
        if (!player.isAI)
        {
            humanPlayer = player;
        }
    }
    
    if (humanPlayer.cardsInHand.count > 1)
    {
        Card* new = (Card*)[humanPlayer.cardsInHand objectAtIndex:1];
        self.cardButtonNew = [self createBadgeButton:new];
        [self.cardButtonNew setPosition:cardButtonNewPos];
        [self addChild:self.cardButtonNew];
    }
    
    if (humanPlayer.cardsInHand.count > 0)
    {
        Card* old = (Card*)[humanPlayer.cardsInHand objectAtIndex:0];
        self.cardButtonOld = [self createBadgeButton:old];
        [self.cardButtonOld setPosition:cardButtonOldPos];
        [self addChild:self.cardButtonOld];
    }
}

-(void)layoutDrawDeck
{
    // Grab card sprites
    const int cardStackCount = 3;
    
    for (int i = 0; i < cardStackCount; i++)
    {
        CCSprite* card = [Deck getBackCardSprite];
        card.scale = 0.2f * CC_CONTENT_SCALE_FACTOR();
        float pointX = self.contentSize.width - (card.contentSize.width * card.scale / 2.0f) - 35.0f + ((float)i * 5.0f);
        float pointY = (card.contentSize.height * card.scale / 2.0f) + 35.0f - ((float)i * 5.0f);
        CGPoint cardPos = ccp(pointX, pointY);
        card.position = cardPos;
        
        [self addChild:card];
    }
}

-(void)updateDrawDeckCardCount
{
    int cardCount = [[GameModel sharedInstance] deck].cards.count;
    float cardCountScale = 2.0f;
    [drawDeckCount setString:[NSString stringWithFormat:@"%i", cardCount]];
    drawDeckCount.scale = cardCountScale;
    float pointX = self.contentSize.width - ((drawDeckCount.contentSize.width * drawDeckCount.scale) / 2.0f) - 55.0f;
    float pointY = (drawDeckCount.contentSize.height * drawDeckCount.scale / 2.0f) + 35.0f;
    CGPoint countPos = ccp(pointX, pointY);
    
    drawDeckCount.position = countPos;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"deck"])
    {
        [self updateDrawDeckCardCount];
    }
}

-(CCMenu*)createBadgeButton:(Card*)card
{
    CCMenuItemSprite* normal = [CCMenuItemSprite itemWithNormalSprite:[card createBadgeSpriteNormal]
                                                       selectedSprite:[card createBadgeSpriteNormal]
                                                                block:^(id sender) {
                                                                    //
                                                                }];
    
    CCMenuItemSprite* selected = [CCMenuItemSprite itemWithNormalSprite:[card createBadgeSpriteSelected]
                                                         selectedSprite:[card createBadgeSpriteSelected]
                                                                  block:^(id sender) {
                                                                      //
                                                                }];
    
    
    toggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:normal, selected, nil] block:^(CCMenuItemToggle* sender) {
        
        [playStepDisplay removeFromParentAndCleanup:YES];
        if (sender.selectedItem == selected)
            {
                Play* play = [Play playWithCard:card andView:self];
                [playStepDisplay removeFromParentAndCleanup:YES];
                playStepDisplay = [play nextStep];
            }
        }];
    return [CCMenu menuWithItems:toggle, nil];
}

-(void)nextStep:(CCNode*)displayNode
{
    CCLOG(@"next step on game screen");
    [playStepDisplay removeFromParentAndCleanup:YES];
    playStepDisplay = nil;
    if (displayNode == nil)
    {
        CCLOG(@"returned nil");
        // play result handled here
        
        // once the card is done being played, unselect it
        [toggle setSelectedIndex:0];
    }
    else
    {
        CCLOG(@"returned something");
        playStepDisplay = displayNode;
        [playStepDisplay setPosition:chosenCardPos];
        [self addChild:playStepDisplay];
    }
}

-(void)previousStep:(CCNode*)displayNode
{
    CCLOG(@"previous step on game screen");
    [playStepDisplay removeFromParentAndCleanup:YES];
    playStepDisplay = nil;
    if (displayNode == nil)
    {
        CCLOG(@"returned nil");
        [toggle setSelectedIndex:0];
    }
    else
    {
        CCLOG(@"returned something");
        playStepDisplay = displayNode;
        [playStepDisplay setPosition:chosenCardPos];
        [self addChild:playStepDisplay];
    }
}

@end
