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
#import "PlayResult.h"


@interface GameScreen ()

@property (readwrite) NSInteger currentPlayerNumber;

@end


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
        
        l = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20.0f];
        [l setPosition:WIN_CENTER];
        [self addChild:l];
        
        [self schedule:@selector(updateUI)];

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
    for (LLPlayer* player in [GameModel sharedInstance].players)
    {
        PlayerSprite* playerSprite = [[PlayerSprite alloc] initWithPlayer:player];
        if (player.isAI)
        {
            [playerSprite setPosition:ccpAdd(startingPosition, ccpMult(offset, counter))];
            [self addChild:playerSprite];
            counter++;
        }
        else
        {
            [playerSprite setPosition:ccp(indent, 300)];
            [self addChild:playerSprite];
        }
        // add playerSprite to Array
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.playerSprites];
        [array addObject:playerSprite];
        self.playerSprites = [NSArray arrayWithArray:array];
    }
}

-(void)updateUI
{
    for (PlayerSprite* ps in self.playerSprites)
    {
        [ps setTokens];
        [ps positionPlayedCards];
        if (ps.player.cardsInHand == 0)
        {
            [ps.labelBackground setColor:ps.maroon];
        }
        
        LLPlayer* p1 = (LLPlayer*)[[GameModel sharedInstance].players objectAtIndex:0];
        LLPlayer* p2 = (LLPlayer*)[[GameModel sharedInstance].players objectAtIndex:1];
        LLPlayer* p3 = (LLPlayer*)[[GameModel sharedInstance].players objectAtIndex:2];
        LLPlayer* p4 = (LLPlayer*)[[GameModel sharedInstance].players objectAtIndex:3];
        
        NSString* s = [NSString stringWithFormat:@"%d, %d, %d, %d", p1.cardsInHand.count, p2.cardsInHand.count, p3.cardsInHand.count, p4.cardsInHand.count];
        [l setString:s];
    }
}

-(void)updateCardsUI
{
    [self.cardButtonNew removeFromParentAndCleanup:YES];
    [self.cardButtonOld removeFromParentAndCleanup:YES];
    self.cardButtonNew = nil;
    self.cardButtonOld = nil;
    
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
                play = [Play playWithCard:card andView:self];
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
        
        LLPlayer* currentPlayer = [[GameModel sharedInstance] getCurrentPlayer];
        
        if (play != nil)
        {
            [PlayResult player:currentPlayer makesPlay:play];
        }
        
        [currentPlayer endTurn];
        
        [self updateCardsUI];
        
        // once the card is done being played, unselect it
        [toggle setSelectedIndex:0];
    }
    else
    {
        CCLOG(@"returned something");
        playStepDisplay = displayNode;
        [playStepDisplay setPosition:chosenCardPos];
        [self addChild:playStepDisplay];
//        for (CCNode* child in playStepDisplay.children)
//        {
//            for (CCNode* grandchild in child.children)
//            {
//                CCLOG(@"position of badge: %@", NSStringFromCGPoint([self convertToWorldSpace:grandchild.position]));
//            }
//        }
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
