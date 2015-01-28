//
//  TODocumentPickerHeaderView.m
//
//  Copyright 2015 Timothy Oliver. All rights reserved.
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

@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong, readwrite) TODocumentPickerSegmentedControl *sortControl;
@property (nonatomic, strong, readwrite) UINavigationBar *navigationBar;

- (void)setupViews;
- (void)setupConstraints;

@end

@implementation TODocumentPickerHeaderView

- (instancetype)init
{
    if (self = [super initWithFrame:(CGRect){0,0,0,88}]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor redColor];
        
        [self setupViews];
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupViews
{    
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){0,0,320,44}];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.sortControl = [[TODocumentPickerSegmentedControl alloc] init];
    self.sortControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.navigationBar = [[UINavigationBar alloc] init];
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.hidden = YES;
    
    [self addSubview:self.navigationBar];
    [self addSubview:self.sortControl];
    [self addSubview:self.searchBar];
}

- (void)setupConstraints
{
    NSDictionary *views = @{@"searchBar":self.searchBar,
                            @"sortControl":self.sortControl,
                            @"navigationBar":self.navigationBar};
    
    //Search bar constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    
    //segmented control
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar]-7-[sortControl]-8-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[sortControl]-8-|" options:0 metrics:nil views:views]];
    
    //navigation bar
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[navigationBar]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationBar]|" options:0 metrics:nil views:views]];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.backgroundColor = self.superview.backgroundColor;
    [self needsUpdateConstraints];
}

#pragma mark - Navigation Bar Animation -
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{ 
    if (self.navigationBar.hidden == hidden)
        return;
    
    if (!animated) {
        self.navigationBar.hidden = hidden;
        return;
    }
    
    self.navigationBar.hidden = NO;
    self.navigationBar.alpha = hidden ? 1.0f : 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationBar.alpha = hidden ? 0.0f : 1.0f;
    }completion:^(BOOL complete) {
        self.navigationBar.hidden = hidden;
    }];
}

#pragma mark - Search Bar Delegate -
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //Must be done via this method else it breaks the search bar's transition animation
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchBar resignFirstResponder];
    } completion:nil];
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)dismissKeyboard
{
    if ([self.searchBar isFirstResponder])
        [self.searchBar resignFirstResponder];
}

@end
