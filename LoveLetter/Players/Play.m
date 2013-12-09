//
//  Play.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "Play.h"
#import "LLPlayer.h"
#import "Card.h"
#import "Deck.h"
#import "Constants.h"
#import "GameModel.h"


@interface Play ()

@property (readwrite) Card* card;
@property (readwrite) LLPlayer* target;
@property (readwrite) NSDictionary* options;
@property (readwrite) enum playState state;

@end


@implementation Play

+(id)playWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options
{
    return [[self alloc] initWithCard:card andTarget:target andOptions:options];
}



-(id)initWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options
{
    if (self = [super init])
    {
        self.state = PlayState_Start;
        [self setCard:card];
        [self setTarget:target];
        [self setOptions:[NSDictionary dictionaryWithDictionary:options]];
    }
    return self;
}

-(CCNode*)nextStep
{
    CCNode* node = nil;
    
    switch (self.state)
    {
        case PlayState_Start:
            // Allow the player to confirm a card
            self.state = PlayState_ConfirmCard;
            node = [self getConfirmCard];
            break;
        case PlayState_ConfirmCard:
            // State is set by method
            node = [self processConfirmCard];
            break;
        case PlayState_ChooseTarget:
            break;
        case PlayState_ChooseCardType:
            break;
        case PlayState_ShowResult:
            break;
    }
    
    return node;
}

-(CCNode*)previousStep
{
    switch (self.state)
    {
        case PlayState_Start:
            break;
        case PlayState_ConfirmCard:
            break;
        case PlayState_ChooseTarget:
            break;
        case PlayState_ChooseCardType:
            break;
        case PlayState_ShowResult:
            break;
    }

    return nil;
}

-(CCNode*)getConfirmCard
{
    CCSprite* chosenCardSprite;
    chosenCardSprite = [self.card createCardSprite];
//    [chosenCardSprite setPosition:chosenCardPos];
    
    CCMenu* cancelButton = [self cancelButton];
//    [cancelButton setPosition:[chosenCardSprite ]];
    [chosenCardSprite addChild:cancelButton];
    
    CCMenu* playButton = [self playButton];
    CGPoint playPos = ccp((cancelButton.contentSize.width / 2.0f) + cancelButton.position.x + (playButton.contentSize.width / 2.0f), playButton.position.y);
    [playButton setPosition:playPos];
    [chosenCardSprite addChild:playButton];

    return chosenCardSprite;
}

-(CCMenu*)cancelButton
{
    CCSprite* normal     = [self buttonSprite:@"Cancel"];
    CCSprite* selected   = [self buttonSprite:@"Cancel"];
    
    CCMenuItemSprite* button = [CCMenuItemSprite itemWithNormalSprite:normal
                                                       selectedSprite:selected
                                                                block:^(id sender) {
                                                                    CCLOG(@"cancel button clicked");
                                                                    [self previousStep];
                                                                }];
    return [CCMenu menuWithItems:button, nil];
}

-(CCMenu*)playButton
{
    CCSprite* normal     = [self buttonSprite:@"Play"];
    CCSprite* selected   = [self buttonSprite:@"Play"];
    
    CCMenuItemSprite* button = [CCMenuItemSprite itemWithNormalSprite:normal
                                                       selectedSprite:selected
                                                                block:^(id sender) {
                                                                    CCLOG(@"play button clicked");
                                                                    [self nextStep];
                                                                }];
    return [CCMenu menuWithItems:button, nil];
}

-(CCSprite*)buttonSprite:(NSString*)text
{
    CCSprite* buttonBG   = [CCSprite spriteWithFile:@"button.png"];
    [buttonBG setScale:0.5f];
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:text fntFile:FONT_BIG];
    
    CCSprite* sprite     = [CCSprite node];
    [sprite setScale:2.0f];
    [sprite addChild:buttonBG];
    [sprite addChild:label];
    return sprite;
}

// Processes confirm card and returns the select target, if applicable
-(CCNode*)processConfirmCard
{
    CCNode* node = nil;
    
    switch (self.card.cardValue)
    {
        case kCardValue_Guard:
        case kCardValue_Priest:
        case kCardValue_Baron:
        case kCardValue_Prince:
        case kCardValue_King:
        case kCardValue_Countess:
            node = [self getSelectTarget];
            self.state = PlayState_ChooseTarget;
            break;

        case kCardValue_Handmaid:
            self.target = [GameModel sharedInstance].players[0];
            break;
            
        default:
            CCLOG(@"Card not found!");
            break;
    }
    
    return node;
}

-(CCNode*)getSelectTarget
{
    return nil;
}

@end
