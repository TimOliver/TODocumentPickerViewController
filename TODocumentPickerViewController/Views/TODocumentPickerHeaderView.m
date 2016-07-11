//
//  TODocumentPickerHeaderView.m
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

#import "TODocumentPickerHeaderView.h"

@interface TODocumentPickerHeaderView () <UISearchBarDelegate>

@property (nonatomic, strong, readwrite) UIView *clippingView;
@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong, readwrite) TODocumentPickerSegmentedControl *sortControl;

- (void)setupViews;
- (void)setupConstraints;

@end

@implementation TODocumentPickerHeaderView

- (instancetype)init
{
    if (self = [super initWithFrame:(CGRect){0,0,320,88}]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupViews];
        [self setupConstraints];
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

    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){0,0,320,44}];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.containerView addSubview:self.searchBar];

    self.sortControl = [[TODocumentPickerSegmentedControl alloc] init];
    self.sortControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.sortControl];
}

- (void)setupConstraints
{
    NSDictionary *views = @{@"searchBar":self.searchBar, @"sortControl":self.sortControl};
    
    //Search bar constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    
    //segmented control
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar]-7-[sortControl]-8-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[sortControl]-8-|" options:0 metrics:nil views:views]];
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
}

#pragma mark - Search Bar Delegate -
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchTextChangedHandler)
        self.searchTextChangedHandler(searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
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

@end
