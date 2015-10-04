//
//  PostDal.h
//  swiftmi_oc
//
//  Created by wings on 7/27/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDal : NSObject

-(void) addPostList:(NSArray*)items;
-(NSArray*) getPostList;
-(void) deleteAll;
@end
