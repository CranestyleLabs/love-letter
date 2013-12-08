//
//  Secret.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLPlayer.h"
#import "Card.h"

@interface Secret : NSObject
{
    //
}


// properties
@property (readonly) LLPlayer* player;
@property (readonly) Card* card;


// selectors
+(id)secretForPlayer:(LLPlayer*)player andCard:(Card*)card;

@end
