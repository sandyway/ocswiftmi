//
//  PostCell.m
//  swiftmi_oc
//
//  Created by wings on 7/30/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _containerView.layer.cornerRadius = 4;
    _containerView.layer.borderWidth =1;
    _containerView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.9].CGColor;
    _containerView.layer.masksToBounds = TRUE;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
