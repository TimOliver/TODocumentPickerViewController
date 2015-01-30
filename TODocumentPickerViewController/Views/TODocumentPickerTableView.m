//
//  TODocumentPickerTableView.m
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 1/30/15.
//  Copyright (c) 2015 Tim Oliver. All rights reserved.
//

#import "TODocumentPickerTableView.h"

@implementation TODocumentPickerTableView

- (void)setContentSize:(CGSize)contentSize
{
    CGFloat scrollInset = self.contentInset.top + self.contentInset.bottom;
    CGFloat height = (CGRectGetHeight(self.bounds) - scrollInset) + CGRectGetHeight(self.tableHeaderView.frame);
    contentSize.height = MAX(height, contentSize.height);
    [super setContentSize:contentSize];
}

@end
