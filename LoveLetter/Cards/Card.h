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

@property int       cardNumber;
@property int       cardValue;
@property NSString* name;

-(id)initWithCardData:(NSArray*)cardData;
-(CCSprite*)createCardSprite;
-(CCSprite*)createBadgeSpriteNormal;
-(CCSprite*)createBadgeSpriteSelected;


@end
