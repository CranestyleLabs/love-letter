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
        
        self.cardSprite  = [self createCardSprite];
        self.badegSprite = [self createBadgeSprite];
    }
    return self;
}

-(CCSprite*)createCardSprite
{
    NSString* fileName = [NSString stringWithFormat:@"%@-card.png", [self.name lowercaseString]];
    CCSprite* sprite   = [CCSprite spriteWithFile:fileName];
    float scale        = 0.2 * CC_CONTENT_SCALE_FACTOR();
    [sprite setScale:scale];
    return sprite;
}

-(CCSprite*)createBadgeSprite
{
    NSString* fileName = [NSString stringWithFormat:@"%@-badge.png", [self.name lowercaseString]];
    CCSprite* sprite   = [CCSprite spriteWithFile:fileName];
    float scale        = 0.5 * CC_CONTENT_SCALE_FACTOR();
    [sprite setScale:scale];
    return sprite;
}

@end
