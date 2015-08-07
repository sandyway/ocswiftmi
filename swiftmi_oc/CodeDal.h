//
//  CodeDal.h
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeDal : NSObject
-(void) addList:(id) items;
-(void)addCode:(id)obj save:(BOOL)save;
-(void)deleteAll;
-(void)save;
-(NSArray*)getCodeList;

@end
