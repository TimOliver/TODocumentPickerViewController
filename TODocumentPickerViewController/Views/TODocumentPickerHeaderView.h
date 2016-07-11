//
//  TODocumentPickerHeaderView.h
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

#import <UIKit/UIKit.h>
#import "TODocumentPickerSegmentedControl.h"

@interface TODocumentPickerHeaderView : UIView

/* Views */
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) TODocumentPickerSegmentedControl *sortControl;

/* The height from the top of the view that is clipped */
@property (nonatomic, assign) CGFloat clippingHeight;

/* Responding to text inserted into the search bar */
@property (nonatomic, copy) void (^searchTextChangedHandler)(NSString *searchText);

/* Cancelling the search bar (i.e the user scrolls the table view) */
- (void)dismissKeyboard;

@end
