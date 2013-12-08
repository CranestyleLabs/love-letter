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
@property (readwrite) Card* card;

@end


@implementation Secret

+(id)secretForPlayer:(LLPlayer*)player andCard:(Card*)card
{
    return [[self alloc] initWithPlayer:(LLPlayer*)player andCard:(id)card];
}

-(id)initWithPlayer:(LLPlayer*)player andCard:(Card*)card
{
    if (self = [super init])
    {
        [self setPlayer:player];
        [self setCard:card];
    }
    return self;
}

@end
