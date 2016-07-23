//
//  CardsDataManager.h
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kBackendlessRestApiDataURL = @"https://api.backendless.com/v1/data/Card";
static NSString * const kBackendlessRestApiDownloadFileURL = @"https://api.backendless.com/C989C2DA-203C-2EA9-FF03-2F777E1A1900/v1/files/test/";
static NSString * const kBackendlessRestApiSecretKey = @"C0BCC6F5-91EB-1C22-FFA0-C04259F48B00";
static NSString * const kBackendlessAppId = @"C989C2DA-203C-2EA9-FF03-2F777E1A1900";

@interface CardsDataManager : NSObject

+(CardsDataManager*)sharedManager;

-(void)loadCardsDataWithCompletion:(void (^)(BOOL successful, NSArray *cardsJsonArray))completion;
-(void)sendCardDataToServerWithId:(NSString*)cardId json:(NSString*)cardJSON completion:(void (^)(BOOL successful, NSString* error))completion;

@end
