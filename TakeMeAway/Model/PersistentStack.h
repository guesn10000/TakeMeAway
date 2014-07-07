//
//  PersistentStack.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-14.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;

@interface PersistentStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;

+ (instancetype)sharedPersistentStack;

- (BOOL)save:(NSError **)error;

/* Create */

/* Retrieve */
- (NSArray *)executeFetchWithEntityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                         sortDescriptor:(NSArray *)sortDescriptors;

/* Update */
- (void)updateManagedObject:(NSManagedObject *)object mergeChanges:(BOOL)flag;

/* Delete */
- (void)deleteManagedObjects:(NSArray *)managedObjects;
- (void)deleteManagedObject:(NSManagedObject *)object;

@end
