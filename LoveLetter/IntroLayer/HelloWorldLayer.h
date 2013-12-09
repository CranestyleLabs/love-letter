//
//  HelloWorldLayer.h
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright Randall Nickerson 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Deck;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite*   cardDisplay;
    CCSprite*   badgeDisplay;
    CCLabelTTF* cardLabel;
    Deck*       deck;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
