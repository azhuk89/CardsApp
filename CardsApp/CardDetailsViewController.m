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
#import "Constants.h"
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
    BOOL didLike;
    CGFloat defaultLabelHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUUID];
    [self showCard];
}

-(void)viewDidLayoutSubviews {
    if ([self getLinesCountForLabel:self.descLabel] <= 5) {
        self.moreButton.hidden = YES;
        [self.descLabel sizeToFit];
        self.descViewHeightConstraint.constant = self.descLabel.frame.size.height+55;
    }
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
    
    didLike = [self.card.likeUUIDList containsObject:self.UUID] ? YES : NO;
    [self.likeButton setBackgroundImage:didLike ? [UIImage imageNamed:@"dislike"] : [UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    self.nameLabel.text = self.card.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.card.created];
    
    self.authorLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(AUTHOR_LABEL_PART, nil), self.card.author];
    self.descLabel.text = self.card.info;
    self.likesLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(LIKES_COUNT_LABEL_PART, nil), self.card.likesCount];
    
    needMore = YES;
    defaultLabelHeight = self.descLabel.frame.size.height;
}

- (IBAction)likeButtonTouchUpInside:(id)sender {
    didLike = !didLike;
    if (didLike) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [self.card.likeUUIDList addObject:self.UUID];
        self.card.likesCount = [NSNumber numberWithInteger:self.card.likesCount.integerValue+1];
        self.likesLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(LIKES_COUNT_LABEL_PART, nil), self.card.likesCount];
    } else {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.card.likeUUIDList removeObject:self.UUID];
        if (self.card.likesCount.integerValue > 0) {
            self.card.likesCount = [NSNumber numberWithInteger:self.card.likesCount.integerValue-1];
            self.likesLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(LIKES_COUNT_LABEL_PART, nil), self.card.likesCount];
        }
    }
    
    [[CardsDataManager sharedManager] sendCardDataToServerWithId:self.card.objectId json:[self.card updatedFieldsJSON] completion:^(BOOL successful, NSString *error) {
        if (!successful) {
            [self presentViewController:[Utils showAlertWithTitle:SAVE_CARD_ERROR_ALERT_TITLE andMessage:SAVE_CARD_ERROR_ALERT_MESSAGE] animated:YES completion:nil];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(cardDetailsViewControllerDidChangeLikeStatus)]) {
        [self.delegate cardDetailsViewControllerDidChangeLikeStatus];
    }
}

- (IBAction)moreButtonTouchUpInside:(id)sender {
    if (needMore) {
        [UIView animateWithDuration:1.5 animations:^{
            [self.descLabel sizeToFit];
        }];
        [self.view layoutIfNeeded];
        self.descViewHeightConstraint.constant = self.descLabel.frame.size.height+55;
        [UIView animateWithDuration:1.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                [self.moreButton setBackgroundImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.view layoutIfNeeded];
        self.descViewHeightConstraint.constant = defaultLabelHeight+55;
        [UIView animateWithDuration:1.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                [self.moreButton setBackgroundImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
            }
        }];
    }
    needMore = !needMore;
}

-(NSInteger)getLinesCountForLabel:(UILabel*)label {
    NSInteger lineCount = 0;
    CGSize textSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    long rHeight = lroundf([label sizeThatFits:textSize].height);
    long charSize = lroundf(label.font.lineHeight);
    lineCount = rHeight/charSize;
    return lineCount;
}

@end
