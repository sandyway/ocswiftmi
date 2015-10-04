//
//  Users.h
//  swiftmi_oc
//
//  Created by wings on 8/3/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * follower_count;
@property (nonatomic, retain) NSNumber * following_count;
@property (nonatomic, retain) NSNumber * isAdmin;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * username;

@end
