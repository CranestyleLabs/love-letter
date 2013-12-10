//
//  PlayView.h
//  LoveLetter
//
//  Created by Ryan J Southwick on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol PlayView <NSObject>

-(void)nextStep:(CCNode*)displayNode;
-(void)previousStep:(CCNode*)displayNode;

@end
