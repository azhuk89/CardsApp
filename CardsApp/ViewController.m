//
//  ViewController.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/20/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    /*AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSString* downloadURL = [kBackendlessRestApiDownloadURL stringByAppendingString:@"cards.json"];
    [sessionManager GET:downloadURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];*/
    
    /*NSDictionary *cards = @{@"name": @"Yury",@"picture": @"yury.png"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cards options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:kBackendlessRestApiUploadURL parameters:nil error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:kBackendlessAppId forHTTPHeaderField:@"application-id"];
    [request setValue:kBackendlessRestApiSecretKey forHTTPHeaderField:@"secret-key"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];*/
}

@end
