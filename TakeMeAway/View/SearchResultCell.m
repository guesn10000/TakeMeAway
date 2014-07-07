//
//  SearchResultCell.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-3.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "SearchResultCell.h"
#import "Store.h"
#import "Food.h"

@interface SearchResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *title_label;

@end

@implementation SearchResultCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UINib *)nib {
    return [UINib nibWithNibName:SearchResultCell_XIB bundle:nil];
}

- (void)configureCellForStoreSearchResult:(Store *)store {
    _title_label.text = store.name;
}

- (void)configureCellForFoodSearchResult:(Food *)food {
    _title_label.text = food.name;
}

@end
