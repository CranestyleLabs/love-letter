//
//  Deck.h
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deck : NSObject
{
    //
}

@property NSArray* cards;

-(NSArray*)shuffle:(NSArray*)cardsToShuffle;

@end
