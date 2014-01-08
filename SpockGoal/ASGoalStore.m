//
//  ASGoalStore.m
//  SpockGoal
//
//  Created by Alan Sparrow on 1/7/14.
//  Copyright (c) 2014 Alan Sparrow. All rights reserved.
//

#import "ASGoalStore.h"
#import "ASGoal.h"
#import "ASRecord.h"
#import "ASRandom.h"
#import "ASTimeProcess.h"

@implementation ASGoalStore

+ (ASGoalStore *)sharedStore
{
    static ASGoalStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Read in SpockGoal.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [self goalArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        [self loadAllGoals];
    }
    
    return self;
}

- (void)loadAllGoals
{
    if (!allGoals) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"ASGoal"];
        [request setEntity:e];
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        allGoals = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSString *)goalArchivePath
{
    NSArray *documentDirectories =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (NSArray *)allGoals
{
    return allGoals;
}

- (ASGoal *)createGoal
{
    /*
     double order;
     if ([allItems count] == 0) {
     order = 1.0;
     } else {
     order = [[allItems lastObject] orderingValue] + 1.0;
     }
     NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
     
     BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
     inManagedObjectContext:context];
     
     [p setOrderingValue:order];
     
     [allItems addObject:p];
     
     return p;

    */

    ASGoal *g = [NSEntityDescription insertNewObjectForEntityForName:@"ASGoal"
                                              inManagedObjectContext:context];
    [allGoals addObject:g];
    
    return g;
}

- (ASGoal *)createRandomGoal
{
    
    ASRandom *random = [[ASRandom alloc] init];
    //ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
    ASGoal *g = [NSEntityDescription insertNewObjectForEntityForName:@"ASGoal"
                                              inManagedObjectContext:context];
    [g setTitle:[random randomGoalTitle]];
    [g setMonday:[random randomBoolean]];
    [g setTuesday:[random randomBoolean]];
    [g setWednesday:[random randomBoolean]];
    [g setThursday:[random randomBoolean]];
    [g setFriday:[random randomBoolean]];
    [g setSaturday:[random randomBoolean]];
    [g setSunday:[random randomBoolean]];
    [g setRemindMe:[random randomBoolean]];
    [g setEverydayStartAt:[[random randomTimePoint1] timeIntervalSinceReferenceDate]];
    [g setEverydayFinishAt:[[random randomTimePoint2] timeIntervalSinceReferenceDate]];
    
    [allGoals addObject:g];
    return g;
}

- (ASRecord *)createRandomRecordForGoal:(ASGoal *)goal
{
    
    ASRandom *random = [[ASRandom alloc] init];
    ASRecord *r = [NSEntityDescription insertNewObjectForEntityForName:@"ASRecord"
                                              inManagedObjectContext:context];
    [r setDuration:[random randomDuration]];
    [r setQuality:[random randomQuality]];
    [r setNote:[random randomNote]];
    
    [goal addRecordsObject:r];
    
    return r;
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}



@end
