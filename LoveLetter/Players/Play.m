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

+(id)playWithCard:(Card*)card andView:(id <PlayView>)theView
{
    return [[self alloc] initWithCard:card andView:theView];
}

+(id)playWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options
{
    return [[self alloc] initWithCard:card andTarget:target andOptions:options];
}

-(id)initWithCard:(Card*)card andView:(id<PlayView>)theView
{
    if (self = [super init])
    {
        self.state = PlayState_Start;
        [self setCard:card];
        view = theView;
    }
    return self;
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
            node = [self processConfirmCard];
            break;
        case PlayState_ChooseTarget:
            node = [self processChooseTarget];
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
    CCSprite* cardSprite = [self.card createCardSprite];
    chosenCardSprite = [CCSprite node];
    [chosenCardSprite addChild:cardSprite];
//    [chosenCardSprite setPosition:chosenCardPos];
//    [self addChild:self.chosenCardSprite];
    
    CCSprite* buttonPlayNormal   = [self buttonSprite:@"Play" selected:NO];
    CCSprite* buttonPlaySelected = [self buttonSprite:@"Play" selected:YES];
    CCSprite* buttonCancelNormal   = [self buttonSprite:@"Cancel" selected:NO];
    CCSprite* buttonCancelSelected = [self buttonSprite:@"Cancel" selected:YES];
    
    CCMenuItemSprite* buttonPlay = [CCMenuItemSprite itemWithNormalSprite:buttonPlayNormal selectedSprite:buttonPlaySelected block:^(id sender) {
        
        NSLog(@"PLAY!");
        
    }];
    
    CCMenuItemSprite* buttonCancel = [CCMenuItemSprite itemWithNormalSprite:buttonCancelNormal selectedSprite:buttonCancelSelected block:^(id sender) {
        
        NSLog(@"CANCEL");
        
    }];
    
    CCMenu* cardMenu = [CCMenu menuWithItems:buttonPlay, buttonCancel, nil];
    [cardMenu setPosition:CGPointMake(0, -cardSprite.contentSize.height/2 * cardSprite.scale - 40.0f)];
    [buttonCancel setPosition:CGPointMake(-buttonCancelNormal.contentSize.width/2 - 20.0f, 0)];
    [buttonPlay setPosition:CGPointMake(buttonPlayNormal.contentSize.width/2 + 20.0f, 0)];
    [chosenCardSprite addChild:cardMenu];

    return chosenCardSprite;
}

-(CCSprite*)buttonSprite:(NSString*)text selected:(BOOL)isSelected
{
    CCSprite* sprite = [CCSprite spriteWithFile:@"card-button.png"];
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:text fntFile:FONT_BIG];
    
    if (isSelected)
    {
        [sprite setColor:ccGRAY];
        [label setColor:ccBLACK];
    }
    else
    {
        [sprite setColor:ccBLACK];
        [label setColor:ccWHITE];
    }
    
    [label setPosition:CGPointMake(sprite.contentSize.width/2, sprite.contentSize.height/2)];
    [sprite addChild:label];
    
    return sprite;
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
            self.state = PlayState_ShowResult;
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

-(CCNode*)processChooseTarget
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
            self.state = PlayState_ShowResult;
            break;
            
        case kCardValue_Handmaid:
            CCLOG(@"ProcessTarget called on Handmaid, should not have reached this!");
            break;
            
        default:
            CCLOG(@"Card not found!");
            break;
    }
    
    return node;
}

-(void)showSelectedCard:(Card*)card
{
    
}


@end
