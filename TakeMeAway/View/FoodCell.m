//
//  FoodCell.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "FoodCell.h"
#import "DJQRateView.h"
#import "Food.h"

@interface FoodCell ()

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *sales_label;

@property (weak, nonatomic) IBOutlet DJQRateView *score_rateView;

@property (weak, nonatomic) IBOutlet UIButton *price_button;

@property (strong, nonatomic) Food *foodForCell;

@end

@implementation FoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:FoodCell_XIB bundle:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addToShoppingList:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIFoodDidAddToShoppingListNotification object:_foodForCell];
}

- (void)configureCellForFood:(Food *)food {
    [_name_label setText:food.name];
    [_sales_label setText:[NSString stringWithFormat:@"月售%d份", food.sales]];
    _score_rateView.rate = food.score;
    
    if (food.state) {
        [_price_button setTitle:[NSString stringWithFormat:@"¥%.1f", food.price] forState:UIControlStateNormal];
    }
    else {
        [_price_button setTitle:@"已售完" forState:UIControlStateNormal];
        _price_button.enabled = NO;
    }
    self.foodForCell = food;
}

@end
