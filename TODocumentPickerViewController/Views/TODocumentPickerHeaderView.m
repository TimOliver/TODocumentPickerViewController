//
//  TODocumentPickerHeaderView.m
//
//  Copyright 2015-2017 Timothy Oliver. All rights reserved.
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

#import "TODocumentPickerHeaderView.h"
#import "TOSearchBar.h"

static const CGFloat kTODocumentPickerHeaderViewPadding = 5.0f;

@interface TODocumentPickerHeaderView () <TOSearchBarDelegate>

@property (nonatomic, strong, readwrite) UIView *clippingView;
@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) TOSearchBar *searchBar;
@property (nonatomic, strong, readwrite) TODocumentPickerSegmentedControl *sortControl;

@end

@implementation TODocumentPickerHeaderView

- (instancetype)init
{
    if (self = [super initWithFrame:(CGRect){0,0,320,44}]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews
{
    self.clippingView = [[UIView alloc] initWithFrame:self.bounds];
    self.clippingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.clippingView.clipsToBounds = YES;
    [self addSubview:self.clippingView];

    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.clippingView addSubview:self.containerView];

    self.sortControl = [[TODocumentPickerSegmentedControl alloc] init];
    [self.containerView addSubview:self.sortControl];
}

- (void)sizeToFit
{
    CGFloat height = self.layoutMargins.top + self.layoutMargins.bottom;
    height += self.sortControl.frame.size.height;
    
    if (self.searchBar) {
        height += kTODocumentPickerHeaderViewPadding;
        height += self.searchBar.frame.size.height;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.backgroundColor = self.superview.backgroundColor;
    [self needsUpdateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat originalHeight = self.bounds.size.height;
    CGFloat newHeight = originalHeight - self.clippingHeight;
    CGFloat clampedHeight = MAX(self.clippingHeight, 0);

    //clamp the height
    newHeight = MAX(0, newHeight);
    newHeight = MIN(originalHeight, newHeight);

    //Set the clipping view to lower
    CGRect frame = self.bounds;
    frame.size.height = newHeight;
    frame.origin.y = clampedHeight;
    self.clippingView.frame = frame;

    //At the same time, raise the container view to create the illusion
    //that the content isn't being lowered
    frame = self.bounds;
    frame.origin.y = -clampedHeight;
    self.containerView.frame = frame;
    
    CGFloat midY = floorf(originalHeight * 0.5f);
    
    // Layout the child views
    if (self.searchBar) {
        frame = self.searchBar.frame;
        frame.origin.x = self.layoutMargins.left;
        frame.size.width = self.bounds.size.width - (self.layoutMargins.left + self.layoutMargins.right);
        frame.size.height = 44.0f;
        frame.origin.y = self.layoutMargins.top;
        self.searchBar.frame = CGRectIntegral(frame);
    }
    
    frame = self.sortControl.frame;
    frame.origin.x = self.layoutMargins.left;
    frame.size.width = self.bounds.size.width - (self.layoutMargins.left + self.layoutMargins.right);
    frame.size.height = 33.0f;
    if (self.searchBar) {
        frame.origin.y = CGRectGetMaxY(self.searchBar.frame) + kTODocumentPickerHeaderViewPadding;
    }
    else {
        frame.origin.y = midY - (frame.size.height * 0.5f);
    }
    
    self.sortControl.frame = CGRectIntegral(frame);
}

#pragma mark - Search Bar Delegate -
- (void)searchBar:(TOSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchTextChangedHandler) {
        self.searchTextChangedHandler(searchText);
    }
}

- (void)searchBarSearchButtonTapped:(TOSearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - External Interactions -
- (void)dismissKeyboard
{
    if ([self.searchBar isFirstResponder])
        [self.searchBar resignFirstResponder];
}

- (void)setClippingHeight:(CGFloat)clippingHeight
{
    //Don't bother doing any layout if the we're beyond the clipping threshold
    clippingHeight = MAX(0, clippingHeight);
    if (_clippingHeight == clippingHeight) {
        return;
    }

    _clippingHeight = clippingHeight;

    if (clippingHeight > self.frame.size.height) {
        self.hidden = YES;
        return;
    }

    self.hidden = NO;
    [self setNeedsLayout];
}

- (void)setShowsSearchBar:(BOOL)showsSearchBar
{
    if (_showsSearchBar == showsSearchBar) {
        return;
    }
    
    _showsSearchBar = showsSearchBar;
    
    if (_showsSearchBar) {
        self.searchBar = [[TOSearchBar alloc] initWithFrame:(CGRect){0,0,320,44}];
        self.searchBar.delegate = self;
        self.searchBar.placeholderText = @"Search";
        [self.containerView addSubview:self.searchBar];
    }
    else {
        [self.searchBar removeFromSuperview];
        self.searchBar = nil;
    }
    
    [self sizeToFit];
}

@end
