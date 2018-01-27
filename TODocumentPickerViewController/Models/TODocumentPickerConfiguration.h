//
//  TODocumentPickerConfiguration.h
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

#import "TODocumentPickerConstants.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TODocumentPickerTheme;

NS_ASSUME_NONNULL_BEGIN

@interface TODocumentPickerConfiguration : NSObject

/* Sets the style of the view controller to be light or dark. (Can be customized with the `theme` property) */
@property (nonatomic, assign) TODocumentPickerViewControllerStyle style;

/* Whether this controller shows and manages the navigation controller toolbar (Default is YES) */
@property (nonatomic, assign) BOOL showToolbar;

/* When not in 'Select' mode, the bar button items on the left hand side of the toolbar */
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *toolbarLeftItems;

/* When not in 'Select' mode, the bar button items on the right hand side of the toolbar */
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *toolbarRightItems;

/* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, strong, nullable) NSArray *allowedFileExtensions;

/* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */
@property (nonatomic, assign) BOOL showExcludedFileExtensions;

/* The default icon if the file format isn't recognized, or other icons aren't available. */
@property (nonatomic, strong, nullable) UIImage *defaultIcon;

/* The icon used for folder entries. */
@property (nonatomic, strong, nullable) UIImage *folderIcon;

/* A dictionary of file extension strings to images to use as icons for each file format. */
@property (nonatomic, strong, null_resettable) NSMutableDictionary *fileIcons;

/* If desired, a custom table view cell class that can contain additional controls or formatting. */
@property (nonatomic, assign, nullable) Class tableViewCellClass;

/* After setting the `style` property, certain visual aspects of the controller can be fine-tuned with this property. */
@property (nonatomic, readonly) TODocumentPickerTheme *theme;

@end

NS_ASSUME_NONNULL_END
