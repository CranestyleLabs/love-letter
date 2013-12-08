//
//  Play.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLPlayer;
@class Card;

@interface Play : NSObject
{
    //
}


// properties
@property (readonly) Card* card;
@property (readonly) LLPlayer* target;
@property (readonly) NSDictionary* options;


// selectors
+(id)playWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options;


@end
