//
//  TODocumentPickerViewController.h
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

#import <UIKit/UIKit.h>
#import "TODocumentPickerItem.h"

@class TODocumentPickerViewControllerDataSource;
@protocol TODocumentPickerViewControllerDelegate;

@interface TODocumentPickerViewController : UINavigationController

@property (nonatomic, strong) TODocumentPickerViewControllerDataSource *dataSource;              /* Data source for file info. Retained by the document picker. */
@property (nonatomic, weak)   id<TODocumentPickerViewControllerDelegate> documentPickerDelegate; /* Sends out delegate events to the assigned object */

@property (nonatomic, strong) NSArray *allowedFileExtensions;   /* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, assign) BOOL showExcludedFileExtensions;  /* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */
@property (nonatomic, strong) NSDictionary *fileFormatIcons;    /* If dealing with custom formats, this lets you add custom icons for those formats (Images must be 40x40 points) */
@property (nonatomic, strong) NSDictionary *themeAttributes;    /* Attributes for applying a new colour scheme to this view controller. */

@end

//-------------------------------------------------------------------------
// An abstract class used to provide the document picker with per-folder file information

@interface TODocumentPickerViewControllerDataSource : NSObject

/**
 Whether synchronously or asynchronously, when your data source has finished building
 a list of items, you must call this block to pass those items back up to the view controller.
 (For UI considerations, this block always executes on the main thread)
 */
@property (nonatomic, copy, readonly) void (^updateItemsForFilePath)(NSArray *items, NSString *filePath);

/**
 Called by the view controller when it wants to obtain a list of items for the folder at the end of the file path.
 Whether the data source subsequently hands off this request asynchronously or not, when completed, the data source
 must call the 'updateItemsForFilePath' block.
 
 @param filePath The file path with which to download file information
 */
- (void)requestItemsForFilePath:(NSString *)filePath;

/**
 If an asynchronous request for files is currently progress and the representing view controller is canceled,
 (eg, if the user hits 'back' before it completes), this method will be called to give the request a chance to cancel.
 */
- (void)cancelRequestForFilePath:(NSString *)filePath;

/**
 The title that will appear in the navigation bar for the folder at this file path.
 If not implemented, defautl behaviour is to return simply the folder name from the filePath string
 */
- (NSString *)titleForFilePath:(NSString *)filePath;

@end

//-------------------------------------------------------------------------

@protocol TODocumentPickerViewControllerDelegate <NSObject>

/* User tapped a single file to download */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItemAtFilePath:(NSString *)filePath;

/* User selected a set of items and tapped */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(NSArray *)items;

@end

//-------------------------------------------------------------------------
// Theming Attributes

extern NSString *const TODocumentPickerViewControllerThemeAttributeBackgroundColor;                     /* Background color of the table view */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableSeparatorColor;                 /* Color of the table cell divider lines */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableCellTitleColor;                 /* Color of the title text label in each cell */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableCellDetailTextColor;            /* Color of the subtitle text label in each cell */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableCellAccessoryTintColor;         /* Color of the arrow accessory icon */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableCellIconTintColor;              /* Tint color of the icons in each cell */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableSectionHeaderBackgroundColor;   /* Background color of each section header */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableSectionTitleColor;              /* Color of the text in each section header */
extern NSString *const TODocumentPickerViewControllerThemeAttributeTableSectionIndexColor;              /* Tint color of the scrollable section index column */

