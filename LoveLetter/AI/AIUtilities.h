//
//  AIUtilities.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Play;
@class LLPlayer;

@interface AIUtilities : NSObject


// enums
typedef NS_ENUM(NSInteger, DefaultCardCount)
{
    kDefaultCardCount_Guard    = 5,
    kDefaultCardCount_Priest   = 2,
    kDefaultCardCount_Baron    = 2,
    kDefaultCardCount_Handmaid = 2,
    kDefaultCardCount_Prince   = 2,
    kDefaultCardCount_King     = 1,
    kDefaultCardCount_Countess = 1,
    kDefaultCardCount_Princess = 1
};


// selectors
+(Play*)makePlayForPlayer:(LLPlayer*)player;
+(NSInteger)randomMostLikelyCard:(LLPlayer*)player;
+(NSInteger)randomMostLikelyCard:(LLPlayer*)player includeGuards:(BOOL)includeGuards;

@end