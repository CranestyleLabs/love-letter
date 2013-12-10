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
    [sprite setContentSize:CGSizeMake(sprite.contentSize.width, sprite.contentSize.height)];
    return sprite;
}

-(CCSprite*)createBadgeSpriteSelected
{
    CCSprite* sprite = [self createBadgeSpriteNormal];
    
    CCSprite* glow = [CCSprite spriteWithFile:@"background-badge.png"];
    [glow setColor:ccc3(150, 0, 150)];
    [glow setScale:1.2];
    [glow setContentSize:CGSizeMake(glow.contentSize.width, glow.contentSize.height)];
    [glow setZOrder:-1];
    [glow setPosition:ccp(sprite.contentSize.width/2, sprite.contentSize.height/2)];
    [sprite addChild:glow];
    
    return  sprite;
}

@end
