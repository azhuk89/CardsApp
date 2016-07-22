//
//  CardsTableViewController.m
//  CardsApp
//
//  Created by Alexandr Zhuk on 7/21/16.
//  Copyright © 2016 Alexandr Zhuk. All rights reserved.
//

#import "CardsTableViewController.h"
#import "CardTableViewCell.h"
#import "Card.h"
#import "Constants.h"
#import "CardsDataManager.h"
#import "CardDetailsViewController.h"

@interface CardsTableViewController ()

@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) Card *selectedCard;

@end

@implementation CardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadCards];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Card *card = [self.cards objectAtIndex:indexPath.row];
    cell.nameLabel.text = card.name;
    cell.likeLabel.text = card.likesCount>0 ? @"I like!" : @"I do not like!";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCard = [self.cards objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailsSegue" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        CardDetailsViewController *destinationVC = [segue destinationViewController];
        destinationVC.card = self.selectedCard;
    }
}


#pragma mark - load data logic

-(void)loadCards {
    [[CardsDataManager sharedManager] loadCardsDataWithCompletion:^(NSMutableArray *cards) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cards) {
                self.cards = [NSMutableArray arrayWithArray:cards];
                [self.tableView reloadData];
            } else {
                self.cards = [NSMutableArray new];
                [self showAlertWithTitle:@"Error" andMessage:@"Load Cards Error"];
            }
        });
    }];
}

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
