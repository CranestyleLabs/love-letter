//
//  LLPlayer.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLPlayer : NSObject
{
    //
}

// properties
@property (readonly) NSString* playerid;
@property (readwrite) id cardInHand;
@property (readwrite) id drawnCard;
@property (readonly) NSArray* secrets;

@end
