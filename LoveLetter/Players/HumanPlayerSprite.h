//
//  HumanPlayerSprite.h
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "cocos2d.h"

@class LLPlayer;

@interface HumanPlayerSprite : CCSprite
{
    //
}

@property CCLabelBMFont* label;
@property CCSprite*      tokenSprites;
@property CCSprite*      playedCardSprites;
@property LLPlayer*      player;

-(id)initWithPlayer:(LLPlayer*)player;

@end
