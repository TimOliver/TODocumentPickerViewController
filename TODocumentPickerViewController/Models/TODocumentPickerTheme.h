//
//  TODocumentPickerTheme.h
//
//  Copyright 2015-2018 Timothy Oliver. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TODocumentPickerTheme : NSObject

@property (nonatomic, strong, nullable) UIColor *backgroundColor;         /* Background color of the table view */
@property (nonatomic, strong, nullable) UIColor *tableSeparatorColor;     /* Color of the table cell divider lines */
@property (nonatomic, strong, nullable) UIColor *tableCellTitleColor;     /* Color of the title text label in each cell */
@property (nonatomic, strong, nullable) UIColor *tableCellDetailColor;    /* Color of the subtitle text label in each cell */
@property (nonatomic, strong, nullable) UIColor *tableAccessoryViewColor; /* Color of the arrow accessory icon */
@property (nonatomic, strong, nullable) UIColor *scrollBarTintColor;      /* Color of the scroll bar */

@end

NS_ASSUME_NONNULL_END
