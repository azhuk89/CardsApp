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

static NSString * const BACKENDLESS_REST_API_DATA_URL = @"https://api.backendless.com/v1/data/Card";
static NSString * const BACKENDLESS_REST_API_APP_ID_VALUE = @"C989C2DA-203C-2EA9-FF03-2F777E1A1900";
static NSString * const BACKENDLESS_REST_API_APP_ID_HEADER = @"application-id";
static NSString * const BACKENDLESS_REST_API_SECRET_KEY_VALUE = @"C0BCC6F5-91EB-1C22-FFA0-C04259F48B00";
static NSString * const BACKENDLESS_REST_API_SECRET_KEY_HEADER = @"secret-key";

static NSString * const PUT_REQUEST_METHOD = @"PUT";
static NSString * const DATA_JSON_KEY = @"data";
static NSString * const JSON_CONTENT_TYPE_HTTP_VALUE = @"application/json";
static NSString * const CONTENT_TYPE_HTTP_HEADER = @"Content-Type";
static NSString * const ACCEPT_HTTP_HEADER = @"Accept";

@implementation CardsDataManager

+(void)loadCardsDataWithCompletion:(void (^)(BOOL successful, NSArray *cardsJsonArray))completion {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:BACKENDLESS_REST_API_APP_ID_VALUE forHTTPHeaderField:BACKENDLESS_REST_API_APP_ID_HEADER];
    [sessionManager.requestSerializer setValue:BACKENDLESS_REST_API_SECRET_KEY_VALUE forHTTPHeaderField:BACKENDLESS_REST_API_SECRET_KEY_HEADER];
    
    [sessionManager GET:BACKENDLESS_REST_API_DATA_URL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Loaded cards JSON: %@", responseObject);
        NSDictionary *json = (NSDictionary*)responseObject;
        NSArray *cardsJsonArray = [json valueForKey:DATA_JSON_KEY];
        
        NSMutableArray *loadedCards = [NSMutableArray new];
        for (NSDictionary *json in cardsJsonArray) {
            Card *card = [[Card alloc] initWithJSON:json];
            [loadedCards addObject:card];
        }
        
        if (completion) return completion(YES, loadedCards);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Load cards error: %@", error);
        if (completion) return completion(NO, nil);
    }];
}

+(void)sendCardDataToServerWithId:(NSString*)cardId json:(NSString*)cardJSON completion:(void (^)(BOOL successful, NSString* error))completion {
    if (cardId.length == 0 || cardJSON.length == 0) return;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *cardURL = [NSString stringWithFormat:@"%@/%@", BACKENDLESS_REST_API_DATA_URL, cardId];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:PUT_REQUEST_METHOD URLString:cardURL parameters:0 error:nil];
    request.timeoutInterval = 30;
    [request setValue:BACKENDLESS_REST_API_APP_ID_VALUE forHTTPHeaderField:BACKENDLESS_REST_API_APP_ID_HEADER];
    [request setValue:BACKENDLESS_REST_API_SECRET_KEY_VALUE forHTTPHeaderField:BACKENDLESS_REST_API_SECRET_KEY_HEADER];
    [request setValue:JSON_CONTENT_TYPE_HTTP_VALUE forHTTPHeaderField:CONTENT_TYPE_HTTP_HEADER];
    [request setValue:JSON_CONTENT_TYPE_HTTP_VALUE forHTTPHeaderField:ACCEPT_HTTP_HEADER];
    [request setHTTPBody:[cardJSON dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Saved card JSON: %@", responseObject);
            if (completion) return completion(YES, nil);
        } else {
            NSLog(@"Save card error: %@", error);
            if (completion) return completion(NO, error.localizedDescription);
        }
    }] resume];
}

@end
