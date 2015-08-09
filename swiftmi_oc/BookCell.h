//
//  BookCell.h
//  swiftmi_oc
//
//  Created by swing on 15/8/9.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end
