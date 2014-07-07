//
//  FoodDetailViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "Food.h"
#import "LocalCache.h"

@interface FoodDetailViewController ()
{
    Food *p_food;
}

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto_imageView;
@property (weak, nonatomic) IBOutlet UILabel     *comments_label;
@property (weak, nonatomic) IBOutlet UITableView *allComments_tableView;

@end

@implementation FoodDetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    p_food = [[ShareDataZone shareDataZone] share_getCurrentFood];
    
    self.navigationItem.title = p_food.name;
#warning - Unfinished
    // 设置美食的detailPhoto
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)addToShoppingList:(id)sender {
}

- (IBAction)addToFavouriteFood:(id)sender {
}

- (IBAction)commentAction:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
