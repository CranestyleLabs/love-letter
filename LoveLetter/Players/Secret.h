//
//  Secret.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "LLPlayer.h"
#import <Foundation/Foundation.h>


@interface Secret : NSObject
{
    //
}


// properties
@property (readonly) LLPlayer* player;
@property (readonly) id card;


// selectors
+(id)secretForPlayer:(LLPlayer*)player andCard:(id)card;

@end
