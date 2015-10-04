//
//  Codedown.h
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Codedown : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * codeId;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * contentLength;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * devices;
@property (nonatomic, retain) NSNumber * downCount;
@property (nonatomic, retain) NSString * downUrl;
@property (nonatomic, retain) NSNumber * isHtml;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSNumber * lastCommentId;
@property (nonatomic, retain) NSNumber * lastCommentTime;
@property (nonatomic, retain) NSString * licence;
@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSString * preview;
@property (nonatomic, retain) NSString * sourceName;
@property (nonatomic, retain) NSNumber * sourceType;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * viewCount;

@end
