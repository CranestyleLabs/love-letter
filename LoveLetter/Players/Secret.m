//
//  Secret.m
//  LoveLetter
//
//  Created by Randall Nickerson on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "Secret.h"


@interface Secret ()

@property (readwrite) LLPlayer* player;
@property (readwrite) NSInteger cardValue;

@end


@implementation Secret

+(id)secretForPlayer:(LLPlayer*)player andCardValue:(NSInteger)cardValue
{
    return [[self alloc] initWithPlayer:player andCard:cardValue];
}

-(id)initWithPlayer:(LLPlayer*)player andCard:(NSInteger)cardValue
{
    if (self = [super init])
    {
        [self setPlayer:player];
        [self setCardValue:cardValue];
    }
    return self;
}

@end
