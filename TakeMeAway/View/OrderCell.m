//
//  OrderCell.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "OrderCell.h"
#import "Order.h"

@interface OrderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tag_imageView;
@property (weak, nonatomic) IBOutlet UILabel     *orderNumber_label;
@property (weak, nonatomic) IBOutlet UILabel     *orderTime_label;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo_imageView;
@property (weak, nonatomic) IBOutlet UILabel     *storeName_label;
@property (weak, nonatomic) IBOutlet UILabel     *possibleTime_label;
@property (weak, nonatomic) IBOutlet UILabel     *currentState_label;

@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)configureCellForOrder:(Order *)anOrder {
    _orderNumber_label.text = anOrder.orderID;
    _orderTime_label.text = anOrder.orderTime;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [anOrder getStoreLogoURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _storeLogo_imageView.image = [UIImage imageWithData:data];
        });
    });
    _storeName_label.text = [anOrder getStoreName];
    
    _possibleTime_label.text = anOrder.expectArriveTime;
    _currentState_label.text = [anOrder getOrderStateContent];
}

@end
