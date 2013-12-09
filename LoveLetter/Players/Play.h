//
//  Play.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class LLPlayer;
@class Card;

enum playState {
    PlayState_Start,
    PlayState_ConfirmCard,
    PlayState_ChooseTarget,
    PlayState_ChooseCardType,
    PlayState_ShowResult
};

@interface Play : NSObject
{
    //
}


// properties
@property (readonly) Card* card;
@property (readonly) LLPlayer* target;
@property (readonly) NSDictionary* options;
@property (readonly) enum playState state;


// selectors
+(id)playWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options;

// Advances to the next step.  Returns the next item to show. Nil if finished.
-(CCNode*)nextStep;

// Reverts to the previous step, clearing current choices.  Returns the previous item to show.  Nil if finished.
-(CCNode*)previousStep;

@end
