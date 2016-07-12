//
//  TODocumentPickerConfiguration.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TODocumentPickerConstants.h"

@interface TODocumentPickerConfiguration : NSObject

/* Whether this controller shows and manages the navigation controller toolbar (Default is YES) */
@property (nonatomic, assign) BOOL showToolbar;

/* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, strong, nullable) NSArray *allowedFileExtensions;

/* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */
@property (nonatomic, assign) BOOL showExcludedFileExtensions;

/* If dealing with custom formats, this lets you add custom icons for those formats (Images must be 40x40 points) */
@property (nonatomic, strong, nullable) NSDictionary *fileFormatIcons;

/* The default icon if the file format isn't recognized, or other icons aren't available. */
@property (nonatomic, strong, nullable) UIImage *defaultIcon;

/* The icon used for folder entries. */
@property (nonatomic, strong, nullable) UIImage *folderIcon;

/* A dictionary of file extension strings to images to use as icons for each file format. */
@property (nonatomic, strong, nullable) NSDictionary *fileIcons;

/* If desired, a custom table view cell class that can contain additional controls or formatting. */
@property (nonatomic, assign, nullable) Class tableViewCellClass;

/* Attributes for applying a new colour scheme to this view controller. */
@property (nonatomic, strong, nullable) NSDictionary *themeAttributes;

@end
