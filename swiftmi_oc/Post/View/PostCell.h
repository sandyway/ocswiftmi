//
//  PostCell.h
//  swiftmi_oc
//
//  Created by wings on 7/30/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
