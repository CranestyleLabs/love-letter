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
    CGPoint cardButtonOldPos;
    CGPoint cardButtonNewPos;
    CGPoint chosenCardPos;
    CGPoint cancelButtonPos;
    CGPoint playButtonPos;
    
    CCLabelBMFont* drawDeckCount;
    CCMenuItemToggle* toggle;
    float indent;
}

@property CCMenu*   cardButtonOld;
@property CCMenu*   cardButtonNew;
@property CCSprite* chosenCardSprite;
@property NSArray*  playerSprites;


+(CCScene*)scene;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
