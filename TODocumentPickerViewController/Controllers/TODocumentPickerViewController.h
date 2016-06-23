//
//  TODocumentPickerTableViewController.h
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
#import "TODocumentPickerConstants.h"


@interface TODocumentPickerViewController : UITableViewController

@property (nonatomic, strong) TODocumentPickerViewControllerDataSource *dataSource;              /* Data source for file info. Retained by the document picker and shared among all children. */
@property (nonatomic, weak)   id<TODocumentPickerViewControllerDelegate> documentPickerDelegate; /* Sends out delegate events to the assigned object */

@property (nonatomic, strong) NSArray *allowedFileExtensions;   /* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, assign) BOOL showExcludedFileExtensions;  /* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */
@property (nonatomic, strong) NSDictionary *fileFormatIcons;    /* If dealing with custom formats, this lets you add custom icons for those formats (Images must be 40x40 points) */
@property (nonatomic, strong) NSDictionary *themeAttributes;    /* Attributes for applying a new colour scheme to this view controller. */

@property (nonatomic, copy)   void (^refreshControlTriggeredHandler)(void); /* Handler block called whenever the refresh control is triggered. */
@property (nonatomic, copy)   NSString *filePath;               /* The file path that this view controller corresponds to */
@property (nonatomic, strong) NSArray  *items;                  /* All of the items displayed by this view controller. (Setting this will trigger a refresh) */

@property (nonatomic, strong) UIImage *defaultIcon;             /* The default icon if the file format isn't recognized, or other icons aren't available. */
@property (nonatomic, strong) UIImage *folderIcon;              /* The icon used for folder entries. */
@property (nonatomic, strong) NSDictionary *fileIcons;          /* A dictionary of file extension strings to images to use as icons for each file format. */
@property (nonatomic, assign) Class tableViewCellClass;         /* If desired, a custom table view cell class that can contain additional controls or formatting. */

@property (nonatomic, copy, readonly) void (^updateItemsForFilePath)(NSArray *items, NSString *filePath);

/**
 Manually update the items in a specific table view controller.
 */
- (void)updateItems:(NSArray *)items forFilePath:(NSString *)filePath;
- (void)pushNewViewControllerForFilePath:(NSString *)filePath animated:(BOOL)animated;

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