//
//  CardDetailsViewController.h
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class CardDetailsViewController;

@protocol CardDetailsViewControllerDelegate <NSObject>

-(void)cardDetailsViewControllerDidChangeLikeStatus;

@end

@interface CardDetailsViewController : UIViewController

@property (nonatomic) Card *card;
@property (weak, nonatomic) id<CardDetailsViewControllerDelegate> delegate;

@end
