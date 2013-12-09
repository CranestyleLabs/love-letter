//
//  Constants.h
//  LoveLetter
//
//  Created by Fisher on 12/9/13.
//  Copyright (c) 2013 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define CGPOINT_HIDDEN  ccp(-5000, -5000)
#define WIN_SIZE        [CCDirector sharedDirector].winSize
#define WIN_CENTER      ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height/2)

#define FONT_BIG        @"avenirnext60_bold.fnt"
#define FONT_SMALL      @"avenirnext48_bold.fnt"

@end
