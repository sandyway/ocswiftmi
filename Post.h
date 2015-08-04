//
//  Post.h
//  swiftmi_oc
//
//  Created by wings on 8/3/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * authorId;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * channelId;
@property (nonatomic, retain) NSString * channelName;
@property (nonatomic, retain) NSNumber * cmtUserId;
@property (nonatomic, retain) NSString * cmtUsername;
@property (nonatomic, retain) NSString * cmtUserName;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * isHtml;
@property (nonatomic, retain) NSNumber * lastCommentId;
@property (nonatomic, retain) NSNumber * lastCommentTime;
@property (nonatomic, retain) NSNumber * postId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSNumber * viewCount;

@end
