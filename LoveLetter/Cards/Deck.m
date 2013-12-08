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


@interface Deck ()

@property (readwrite) NSArray* cards;

@end


@implementation Deck

-(id)init
{
    if (self = [super init])
    {
        
        [self refresh];
        
        NSLog(@"%@", [self toString]);
        
    }
    return self;
}

-(Card*)drawCard
{
    
    // copy the current set of cards
    NSMutableArray* copyCards = [NSMutableArray arrayWithArray:self.cards];

    // get card from the bottom of the deck
    Card* card = [copyCards lastObject];
    
    // remove that card from the copy of the current set of cards
    [copyCards removeLastObject];
    
    // update the current set to match the copy
    [self setCards:[NSArray arrayWithArray:copyCards]];
    
    // return the card
    return card;
    
}

-(void)refresh
{
    
    // refresh the deck from the config file
    // ** wipes out existing deck
    for (NSBundle* bundle in [NSBundle allBundles])
    {
        
        if ([bundle pathForResource:@"love_letter_deck" ofType:@"csv"] != nil)
        {
            
            NSString* path = [bundle pathForResource:@"love_letter_deck" ofType:@"csv"];
            NSArray*  rows =  [self parseCSV:path];
            
            for (NSArray* row in rows)
            {
                
                Card* card = [[Card alloc] initWithCardData:row];
                
                NSMutableArray* arr = [NSMutableArray arrayWithArray:self.cards];
                [arr addObject:card];
                self.cards = [NSArray arrayWithArray:arr];
                
            }
            
        }
        
    }
    
}

-(NSString*)toString
{
    
    NSString* str = @"\nCards in Deck:\n";
    
    for (Card* card in self.cards)
    {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"[%d] %@ (%d)\n", card.cardNumber, card.name, card.cardValue]];
    }
    
    return str;
    
}

-(NSArray*)parseCSV:(NSString*)path
{
    
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
