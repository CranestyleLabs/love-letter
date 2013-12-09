//
//  HelloWorldLayer.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright Randall Nickerson 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Card.h"
#import "Constants.h"
#import "Deck.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init]))
    {
	    CCLOG(@"reading deck data...");
        deck = [[Deck alloc] init];
        
        cardDisplay  = [CCSprite node];
        badgeDisplay = [CCSprite node];
        cardLabel    = [CCLabelBMFont labelWithString:@"" fntFile:FONT_SMALL];
        
        [cardDisplay    setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        [badgeDisplay   setPosition:ccpAdd(cardDisplay.position, ccp(0, -200))];
        [cardLabel      setPosition:ccpAdd(cardDisplay.position, ccp(0, -120))];
        
        [self addChild:cardDisplay];
        [self addChild:badgeDisplay];
        [self addChild:cardLabel];
        
	}
    
	return self;
}

-(void)onEnterTransitionDidFinish
{

    [super onEnterTransitionDidFinish];
    [self showRandomCard];
    
    [self schedule:@selector(showRandomCard) interval:2];
}

-(void)showRandomCard
{
    [cardDisplay  removeAllChildrenWithCleanup:YES];
    [badgeDisplay removeAllChildrenWithCleanup:YES];
    
    NSArray* shuffledCards = [deck shuffle:deck.cards];
    Card* cardToShow = [shuffledCards objectAtIndex:0];
    NSString* cardString  = [NSString stringWithFormat:@"Card#%d: %@ (%d)",
                             cardToShow.cardNumber,
                             cardToShow.name,
                             cardToShow.cardValue];
    [cardLabel setString:cardString];
    
    [cardDisplay  addChild:cardToShow.cardSprite];
    [badgeDisplay addChild:cardToShow.badegSprite];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
