//
//  CardsDataManager.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "CardsDataManager.h"
#import <AFNetworking.h>
#import "Card.h"

@implementation CardsDataManager

+(CardsDataManager*)sharedManager {
    static CardsDataManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[CardsDataManager alloc] init];
    });
    return instance;
}

-(void)loadCardsDataWithCompletion:(void (^)(NSMutableArray *cards))completion {
    NSMutableArray *loadedCards = [NSMutableArray new];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:kBackendlessAppId forHTTPHeaderField:@"application-id"];
    [sessionManager.requestSerializer setValue:kBackendlessRestApiSecretKey forHTTPHeaderField:@"secret-key"];
    
    [sessionManager GET:kBackendlessRestApiDataURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = (NSDictionary*)responseObject;
        NSArray *cardsArray = [json valueForKey:@"data"];
        for (NSDictionary *json in cardsArray) {
            Card *card = [[Card alloc] initWithJSON:json];
            [loadedCards addObject:card];
        }
        if (completion) return completion(loadedCards);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Load Cards Error: %@", error);
        if (completion) return completion(nil);
    }];}

@end
