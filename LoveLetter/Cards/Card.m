//
//  Card.m
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "Card.h"
#import "cocos2d.h"

@implementation Card
{
    //
}

-(id)initWithCardData:(NSArray*)cardData
{
    if (self = [super init])
    {
        self.cardNumber  = [[cardData objectAtIndex:0] intValue];
        self.name        = [cardData objectAtIndex:1];
        self.cardValue   = [[cardData objectAtIndex:2] intValue];
        
//        self.cardSprite  = [self createCardSprite];
//        self.badgeSprite = [self createBadgeSprite];
//        self.badgeButton = [self createBadgeButton];
    }
    return self;
}

-(CCSprite*)createCardSprite
{
//    NSString* fileName = [NSString stringWithFormat:@"%@-card.png", [self.name lowercaseString]];
    NSString* fileName = [NSString stringWithFormat:@"%d_%@.png", self.cardValue, [self.name lowercaseString]];
    CCSprite* sprite   = [CCSprite spriteWithFile:fileName];
    [sprite setScale:0.8f];
    return sprite;
}

-(CCSprite*)createBadgeSpriteNormal
{
    NSString* fileName = [NSString stringWithFormat:@"%@-badge.png", [self.name lowercaseString]];
    CCSprite* sprite   = [CCSprite spriteWithFile:fileName];
    float scale        = 0.5 * CC_CONTENT_SCALE_FACTOR();
    [sprite setScale:scale];
    return sprite;
}

-(CCSprite*)createBadgeSpriteSelected
{
    CCSprite* glow = [CCSprite spriteWithFile:@"background-badge.png"];
    [glow setColor:ccc3(150, 0, 150)];
    float scale    = 0.5 * CC_CONTENT_SCALE_FACTOR();
    [glow setScale:scale];
    
    CCSprite* sprite = [self createBadgeSpriteNormal];
    [sprite setScale:1];
    [sprite setPosition:ccp(glow.contentSize.width/2, glow.contentSize.height/2)];
    [glow addChild:sprite];
    
    return  glow;
}

@end
