//
//  TableDataSource.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-28.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource ()

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation TableDataSource

#pragma mark - Initialization

- (id)init {
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    
    if (self) {
        _items              = [anItems copy];
        _cellIdentifier     = [aCellIdentifier copy];
        _configureCellBlock = [aConfigureCellBlock copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return _items[(NSUInteger) indexPath.row];
}

- (void)updateItems:(NSArray *)anItems {
    self.items = anItems;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    
    _configureCellBlock(cell, item);
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
