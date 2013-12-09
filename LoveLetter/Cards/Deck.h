//
//  Deck.h
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@class Card;

@interface Deck : NSObject
{
    //
}


// enums
typedef NS_ENUM(NSInteger, CardValue)
{
    kCardValue_Guard    = 1,
    kCardValue_Priest   = 2,
    kCardValue_Baron    = 3,
    kCardValue_Handmaid = 4,
    kCardValue_Prince   = 5,
    kCardValue_King     = 6,
    kCardValue_Countess = 7,
    kCardValue_Princess = 8
};


// properties
@property (readonly) NSArray* cards;


// selectors
-(Card*)drawCard;
-(void)refresh;
-(NSArray*)shuffle:(NSArray*)cardsToShuffle;
+(CCSprite*)getBackCardSprite;

@end
