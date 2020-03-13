//
//  STContactCell.m
//  Contacts
//
//  Created by bignox on 2020/3/12.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import "XLContactCell.h"

@implementation XLContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 8.f;
}

@end
