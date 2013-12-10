//
//  GameScreen.h
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import "cocos2d.h"
#import "PlayView.h"

@class Play;

@class GameModel;

@interface GameScreen : CCLayer <PlayView>
{
    CGPoint             cardButtonOldPos;
    CGPoint             cardButtonNewPos;
    CGPoint             chosenCardPos;
    CGPoint             cancelButtonPos;
    CGPoint             playButtonPos;
    
    CCLabelBMFont*      drawDeckCount;
    CCLabelTTF*         l;
    
    CCMenu*             cardButtonNew;
    CCMenu*             cardButtonOld;
    CCMenuItemToggle*   toggle;
    
    CCNode*             playStepDisplay;
    
    float               indent;
    
    NSArray*            playerSprites;
    
    Play*               play;
    
}

+(CCScene*)scene;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)updateUI;

@end
