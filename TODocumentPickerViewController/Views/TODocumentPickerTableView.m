//
//  TODocumentPickerTableView.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TODocumentPickerTableView.h"

// Header offset code by b2cloud: http://www.b2cloud.com.au/tutorial/uitableview-section-header-positions/
@interface TODocumentPickerTableView ()
@property (nonatomic, assign) BOOL shouldManuallyLayoutHeaderViews;
- (void)layoutHeaderViews;
@end

@implementation TODocumentPickerTableView

#pragma mark - Section Header View Layout -
- (void)layoutSubviews
{
    [super layoutSubviews];

    if(self.shouldManuallyLayoutHeaderViews) {
        [self layoutHeaderViews];
    }
}

- (void)setHeaderViewInsets:(UIEdgeInsets)headerViewInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(headerViewInsets, _headerViewInsets)) {
        return;
    }

    _headerViewInsets = headerViewInsets;
    self.shouldManuallyLayoutHeaderViews = !UIEdgeInsetsEqualToEdgeInsets(headerViewInsets, UIEdgeInsetsZero);
    [self setNeedsLayout];
}

- (void)layoutHeaderViews
{
    const NSArray *indexPaths = self.indexPathsForVisibleRows;
    if (indexPaths.count == 0) {
        return;
    }

    const NSRange sectionRange = NSMakeRange([indexPaths.firstObject section], [indexPaths.lastObject section]);

    const NSUInteger numberOfSections = self.numberOfSections;
    const UIEdgeInsets contentInset = self.contentInset;
    const CGPoint contentOffset = self.contentOffset;

    const CGFloat sectionViewMinimumOriginY = contentOffset.y + contentInset.top + self.headerViewInsets.top;

    //Layout each header view
    for (NSUInteger section = sectionRange.location; section <= sectionRange.length; section++)
    {
        UIView *sectionView = [self headerViewForSection:section];
        if(sectionView == nil) {
            continue;
        }

        const CGRect sectionFrame = [self rectForSection:section];

        CGRect sectionViewFrame = sectionView.frame;
        sectionViewFrame.origin.y = ((sectionFrame.origin.y < sectionViewMinimumOriginY) ? sectionViewMinimumOriginY : sectionFrame.origin.y);

        //If it's not last section, manually 'stick' it to the below section if needed
        if (section < numberOfSections - 1) {
            const CGRect nextSectionFrame = [self rectForSection:section + 1];

            if (CGRectGetMaxY(sectionViewFrame) > CGRectGetMinY(nextSectionFrame)) {
                sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height;
            }
        }
        
        sectionView.frame = sectionViewFrame;
    }
}

/*
 When initially showing an empty table, we still want the header view
 to be scrolled upwards, out of view. To achieve this, the minimum content size
 of this view needs to explicitly be (tableHeight + headerHeight) in order to have 
 enough scrollable height to hide it.
 */
- (void)setContentSize:(CGSize)contentSize
{
    CGFloat scrollInset = self.contentInset.top + self.contentInset.bottom;
    CGFloat height = (CGRectGetHeight(self.bounds) - scrollInset) + CGRectGetHeight(self.tableHeaderView.frame);
    contentSize.height = MAX(height, contentSize.height);
    [super setContentSize:contentSize];
}

@end
