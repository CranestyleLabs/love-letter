//
//  GameScreen.h
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "cocos2d.h"

@class GameModel;

@interface GameScreen : CCLayer
{
    //
    CCLabelBMFont* drawDeckCount;
}


+(CCScene*)scene;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
