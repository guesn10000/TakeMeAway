//
//  ShopCell.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "ShopCell.h"
#import "Food.h"

@interface ShopCell ()

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *quantity_label;

@property (weak, nonatomic) IBOutlet UILabel *cost_label;

@end

@implementation ShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:ShopCell_XIB bundle:nil];
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

- (void)configureCellForShopItem:(Food *)aFood {
    _name_label.text = aFood.name;
    _quantity_label.text = [NSString stringWithFormat:@"× %d", aFood.orderedQuantity];
    _cost_label.text = [NSString stringWithFormat:@"¥ %.1f", [aFood getTotalPrice]];
}

@end
