//
//  Card.h
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "cocos2d.h"

@interface Card : CCSprite
{
    //
}

@property CCMenu*   badgeButton;
@property CCSprite* cardSprite;
@property CCSprite* badgeSprite;
@property int       cardNumber;
@property int       cardValue;
@property NSString* name;

-(id)initWithCardData:(NSArray*)cardData;
-(CCSprite*)createBadgeSpriteNormal;
-(CCSprite*)createBadgeSpriteSelected;


@end
