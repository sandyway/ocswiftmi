//
//  CodeCell.m
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CodeCell.h"

@implementation CodeCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.9].CGColor;
    self.layer.masksToBounds = false;
}

-(void)addShadow{
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius =2;
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
