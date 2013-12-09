//
//  CCRadioMenu.m
//  MathNinja
//
//  Created by Ray Wenderlich on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCRadioMenu.h"

@implementation CCRadioMenu

- (void)setSelectedItem:(CCMenuItem *)item
{
    [_selectedItem unselected];
    _selectedItem = item;    
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    if ( _state != kCCMenuStateWaiting ) return NO;
    
    CCMenuItem *curSelection = [self itemForTouch:touch];
    [curSelection selected];
    _curHighlighted = curSelection;
    
    if (_curHighlighted) {
        if (_selectedItem != curSelection) {
            [_selectedItem unselected];
        }
        _state = kCCMenuStateTrackingTouch;
        return YES;
    }
    return NO;
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {

    NSAssert(_state == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
    CCMenuItem *curSelection = [self itemForTouch:touch];
    if (curSelection != _curHighlighted && curSelection != nil) {
        [_selectedItem selected];
        [_curHighlighted unselected];
        _curHighlighted = nil;
        _state = kCCMenuStateWaiting;
        return;
    } 
    
    _selectedItem = _curHighlighted;
    [_curHighlighted activate];
    _curHighlighted = nil;
    
	_state = kCCMenuStateWaiting;
    
}

- (void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
 
    NSAssert(_state == kCCMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
	
	[_selectedItem selected];
    [_curHighlighted unselected];
    _curHighlighted = nil;
	
	_state = kCCMenuStateWaiting;
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(_state == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *curSelection = [self itemForTouch:touch];
    if (curSelection != _curHighlighted && curSelection != nil) {       
        [_curHighlighted unselected];
        [curSelection selected];
        _curHighlighted = curSelection;        
        return;
    }
    
}

-(CCMenuItem*)itemForTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
	CCMenuItem* item;
	CCARRAY_FOREACH(_children, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
            
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item activeArea];
            
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

@end
