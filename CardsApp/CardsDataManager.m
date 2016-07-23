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

-(void)loadCardsDataWithCompletion:(void (^)(BOOL successful, NSArray *cardsJsonArray))completion {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:kBackendlessAppId forHTTPHeaderField:@"application-id"];
    [sessionManager.requestSerializer setValue:kBackendlessRestApiSecretKey forHTTPHeaderField:@"secret-key"];
    
    [sessionManager GET:kBackendlessRestApiDataURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = (NSDictionary*)responseObject;
        NSArray *cardsArray = [json valueForKey:@"data"];
        if (completion) return completion(YES, cardsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Load Cards Error: %@", error);
        if (completion) return completion(NO, nil);
    }];
}

-(void)sendCardDataToServerWithId:(NSString*)cardId json:(NSString*)cardJSON completion:(void (^)(BOOL successful, NSString* error))completion {
    if (cardId.length == 0 || cardJSON.length == 0) return;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *cardURL = [NSString stringWithFormat:@"%@/%@", kBackendlessRestApiDataURL, cardId];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:cardURL parameters:0 error:nil];
    request.timeoutInterval = 30;
    [request setValue:kBackendlessAppId forHTTPHeaderField:@"application-id"];
    [request setValue:kBackendlessRestApiSecretKey forHTTPHeaderField:@"secret-key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[cardJSON dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successful load: %@", responseObject);
            if (completion) return completion(YES, nil);
        } else {
            NSLog(@"Send Card Error: %@", error);
            if (completion) return completion(NO, error.localizedDescription);
        }
    }] resume];
}

@end
