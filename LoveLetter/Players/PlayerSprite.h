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
    ccColor3B cyan;
    ccColor3B orange;
    ccColor3B maroon;
}

@property CCLabelBMFont* label;
@property CCSprite*      labelBackground;
@property CCSprite*      tokenSprites;
@property CCSprite*      playedCardSprites;
@property LLPlayer*      player;
@property NSArray*       cardBadgePositions;

-(id)initWithPlayer:(LLPlayer*)player;

@end
