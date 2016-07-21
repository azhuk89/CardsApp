//
//  Card.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "Card.h"

@implementation Card

-(id)initWithJSON:(NSDictionary*)cardJson
{
    if (self = [super init]) {
        _name = [cardJson valueForKey:@"name"];
        _author = [cardJson valueForKey:@"author"];
        _info = [cardJson valueForKey:@"info"];
        _imageName = [cardJson valueForKey:@"imageName"];
        
        int count = [[cardJson valueForKey:@"likesCount"] intValue];
        _likesCount = [NSNumber numberWithInt:count];
        
        NSString *createdDateStr = [cardJson valueForKey:@"created"];
        NSString *updateDateStr = [cardJson valueForKey:@"updated"];
        _created = [NSDate dateWithTimeIntervalSince1970:createdDateStr.doubleValue / 1000];
        _updated = [NSDate dateWithTimeIntervalSince1970:updateDateStr.doubleValue / 1000];
        
        _objectId = [cardJson valueForKey:@"objectId"];
        _ownerId = [cardJson valueForKey:@"ownerId"];
    }
    
    return self;
}

@end
