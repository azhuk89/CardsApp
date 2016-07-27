//
//  CardsDataManager.h
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardsDataManager : NSObject

+(void)loadCardsDataWithCompletion:(void (^)(BOOL successful, NSArray *cardsJsonArray))completion;
+(void)sendCardDataToServerWithId:(NSString*)cardId json:(NSString*)cardJSON completion:(void (^)(BOOL successful, NSString* error))completion;

@end
