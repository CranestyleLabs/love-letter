//
//  Card.h
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "CCSprite.h"

@interface Card : CCSprite
{
    //
}

-(id)initWithCardData:(NSArray*)cardData;

@property NSString* name;
@property int       cardNumber;
@property int       cardValue;
@property CCSprite* sprite;

@end
