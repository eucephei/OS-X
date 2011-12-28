//
//  Location.h
//  Weather_Underground
//
//  Created by Apple User on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Location :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* observations;


@end



@interface Location (CoreDataGeneratedAccessors)
- (void)addObservationsObject:(NSManagedObject *)value;
- (void)removeObservationsObject:(NSManagedObject *)value;
- (void)addObservations:(NSSet *)value;
- (void)removeObservations:(NSSet *)value;

@end

