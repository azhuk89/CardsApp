//
//  CardDetailsViewController.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "CardDetailsViewController.h"
#import "CardsDataManager.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CardDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeightConstraint;

@property (nonatomic) NSString *UUID;

@end

@implementation CardDetailsViewController {
    BOOL needMore;
    BOOL needLike;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUUID];
    [self showCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getUUID {
    if (self.UUID) return;
    self.UUID = [[NSUserDefaults standardUserDefaults] valueForKey:@"appUUID"];
    if (!self.UUID) {
        self.UUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setValue:self.UUID forKey:@"appUUID"];
    }
    NSLog(@"%@", self.UUID);
}

-(void)showCard {
    NSString *imageURLString = [kBackendlessRestApiDownloadFileURL stringByAppendingString:self.card.imageName];
    [self.cardImageVIew sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
    
    [self.likeButton setTitle:[self.card.likeUUIDList containsObject:self.UUID] ? @"Dislike" : @"Like" forState:UIControlStateNormal];
    needLike = [self.likeButton.currentTitle isEqualToString:@"Like"] ? YES : NO;
    self.nameLabel.text = self.card.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.card.created];
    
    self.authorLabel.text = self.card.author;
    self.descLabel.text = self.card.info;
    self.likesLabel.text = [NSString stringWithFormat:@"%@", self.card.likesCount];
    needMore = YES;
}

- (IBAction)likeButtonTouchUpInside:(id)sender {
    if (needLike) {
        [self.likeButton setTitle:@"Dislike" forState:UIControlStateNormal];
        [self.card.likeUUIDList addObject:self.UUID];
        self.card.likesCount = [NSNumber numberWithInteger:self.card.likesCount.integerValue+1];
        self.likesLabel.text = [NSString stringWithFormat:@"Likes: %@", self.card.likesCount];
    } else {
        [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self.card.likeUUIDList removeObject:self.UUID];
        if (self.card.likesCount.integerValue > 0) {
            self.card.likesCount = [NSNumber numberWithInteger:self.card.likesCount.integerValue-1];
            self.likesLabel.text = [NSString stringWithFormat:@"Likes: %@", self.card.likesCount];
        }
    }
    needLike = !needLike;
    
    [[CardsDataManager sharedManager] sendCardDataToServerWithId:self.card.objectId json:[self.card updatedFieldsJSON] completion:^(BOOL successful, NSString *error) {
        if (!successful) {
            [self presentViewController:[Utils showAlertWithTitle:@"Error" andMessage:@"Send Card Error"] animated:YES completion:nil];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(cardDetailsViewControllerDidChangeLikeStatus)]) {
        [self.delegate cardDetailsViewControllerDidChangeLikeStatus];
    }
}

- (IBAction)moreButtonTouchUpInside:(id)sender {
    if (needMore) {
        self.descLabel.numberOfLines = 0;
        self.descViewHeightConstraint.constant = self.descLabel.frame.size.height+55;
        [self.descLabel sizeToFit];
        [self.moreButton setTitle:@"Less" forState:UIControlStateNormal];
    } else {
        self.descLabel.numberOfLines = 5;
        [self.descLabel sizeToFit];
        self.descViewHeightConstraint.constant = self.descLabel.frame.size.height+55;
        [self.moreButton setTitle:@"More" forState:UIControlStateNormal];
    }
    needMore = !needMore;
}

@end
