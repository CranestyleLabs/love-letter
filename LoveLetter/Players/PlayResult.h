//
//  PlayResult.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLPlayer;
@class Play;

@interface PlayResult : NSObject

+(void)player:(LLPlayer*)player makesPlay:(Play*)play;

@end
