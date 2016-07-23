//
//  Utils.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/23/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(UIAlertController *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertVC addAction:okAction];
    return alertVC;
}

@end
