//
//  Card.h
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSNumber *likesCount;
@property (nonatomic) NSMutableArray *likeUUIDList;

//backendless properties
@property (nonatomic) NSDate *created;
@property (nonatomic) NSDate *updated;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *ownerId;

-(id)initWithJSON:(NSDictionary*)cardJson;
-(NSString*)cardJSON;

@end
