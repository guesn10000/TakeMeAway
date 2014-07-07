//
//  StoreCell.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "StoreCell.h"
#import "Store.h"
#import "DJQRateView.h"

@interface StoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logo_imageView;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *detail_label;

@property (weak, nonatomic) IBOutlet DJQRateView *rateView;

@end

@implementation StoreCell

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

- (void)configureCellForStore:(Store *)store {
    [_name_label setText:store.name];
    [_rateView setRate:store.score];
    [_detail_label setText:store.detail];
    
#warning - Just for local test
    [_logo_imageView setImage:store.logoImage];
//    if (!store.logoImageURL) {
//        return;
//    }
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url = [NSURL URLWithString:store.logoImageURL];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_logo_imageView setImage:image];
//        });
//    });
}

@end
