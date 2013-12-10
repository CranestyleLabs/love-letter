//
//  PlayerSprite.h
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "cocos2d.h"

@class LLPlayer;

@interface PlayerSprite : CCSprite
{
    //
}

@property CCLabelBMFont* label;
@property CCSprite*      labelBackground;
@property CCSprite*      tokenSprites;
@property LLPlayer*      player;
@property NSArray*       cardBadgePositions;

@property ccColor3B cyan;
@property ccColor3B orange;
@property ccColor3B maroon;

-(id)initWithPlayer:(LLPlayer*)player;

-(void)setTokens;
-(void)positionPlayedCards;

@end
