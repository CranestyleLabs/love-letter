//
//  GameModel.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;
@class Card;

@interface GameModel : NSObject
{
    
}


// properties
@property (readonly) NSInteger playerCount;
@property (readonly) NSArray* players;
@property (readonly) Deck* deck;
@property (readonly) Card* burnedCard;


// selectors
+(GameModel*)sharedInstance;

@end
