//
//  Play.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "Play.h"
#import "LLPlayer.h"
#import "Card.h"


@interface Play ()

@property (readwrite) Card* card;
@property (readwrite) LLPlayer* target;
@property (readwrite) NSDictionary* options;

@end


@implementation Play

+(id)playWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options
{
    return [[self alloc] initWithCard:card andTarget:target andOptions:options];
}



-(id)initWithCard:(Card*)card andTarget:(LLPlayer*)target andOptions:(NSDictionary*)options
{
    if (self = [super init])
    {
        [self setCard:card];
        [self setTarget:target];
        [self setOptions:[NSDictionary dictionaryWithDictionary:options]];
    }
    return self;
}

@end
