//
//  Deck.m
//  LoveLetter
//
//  Created by Dan Hoffman on 12/7/13.
//  Copyright (c) 2013 Randall Nickerson. All rights reserved.
//

#import "Deck.h"
#import "Card.h"
#import "CHCSVParser.h"

@implementation Deck
{
    //
}

-(id)init
{
    if (self = [super init])
    {
        for (NSBundle* bundle in [NSBundle allBundles])
        {
            if ([bundle pathForResource:@"love_letter_deck" ofType:@"csv"] != nil)
            {
                NSString* path = [bundle pathForResource:@"love_letter_deck" ofType:@"csv"];
                NSArray*  rows =  [self parseCSV:path];

                int counter = 0;
                for (NSArray* row in rows)
                {
                    Card* card = [[Card alloc] initWithCardData:row];
                    
                    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.cards];
                    [arr addObject:card];
                    self.cards = [NSArray arrayWithArray:arr];
                    
                    Card* cardInDeck = [self.cards objectAtIndex:counter];
                    NSLog(@"row %d: %@ (%d)", card.cardNumber, cardInDeck.name, cardInDeck.cardValue);
                    counter++;
                }
            }

        }
    }
    return self;
}

-(NSArray*)parseCSV:(NSString*)path
{
    
    NSLog(@".");
    NSArray* rows = [NSArray arrayWithContentsOfCSVFile:path];
    if (rows == nil)
    {
        //something went wrong; log the error and exit
        NSLog(@"error parsing file");
        return nil;
    }
    return rows;
}

-(NSArray*)shuffle:(NSArray*)cardsToShuffle
{
    //	http://en.wikipedia.org/wiki/Fisher-Yates_shuffle
    NSMutableArray* sortedArray = [NSMutableArray arrayWithArray:cardsToShuffle];
    NSUInteger count = [sortedArray count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [sortedArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return sortedArray;
}

@end
