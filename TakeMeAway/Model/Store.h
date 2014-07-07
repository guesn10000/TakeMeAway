//
//  Store.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

#pragma mark - Base Infomations

- (instancetype)initWithID:(NSString *)anID
              logoImageURL:(NSString *)aURL
                      name:(NSString *)aName
                     score:(NSString *)aScore
                    detail:(NSString *)aDetail;

/* 在数据库中唯一标识的ID */
@property (copy, readonly, nonatomic) NSString *storeID;

/* 商家的logo */
@property (copy, readonly, nonatomic) NSString *logoImageURL;

/* 商家名 */
@property (copy, readonly, nonatomic) NSString *name;

/* 根据商家得分来描绘1-5星本地图像 */
@property (assign, readonly, nonatomic) CGFloat score;

/* 商家细节是由距离，价格和送达时间组成的字符串 */
@property (copy, readonly, nonatomic) NSString *detail;

#pragma mark - Store Details

/* 获取商家的详细信息 */
- (void)getStoreDetails;

/* 商家店面等详细信息的图片 */
@property (copy, readonly, nonatomic) NSString *detailPhotoURL;

/* 商家的位置 */
@property (copy, readonly, nonatomic) NSString *locationName;

/* 商家的电话 */
@property (copy, readonly, nonatomic) NSString *telephoneNumber;

/* 商家的简介 */
@property (copy, readonly, nonatomic) NSString *introduction;


#ifdef IMAGE_LOCAL_TEST
@property (strong, nonatomic) UIImage *logoImage;
#endif

@end
