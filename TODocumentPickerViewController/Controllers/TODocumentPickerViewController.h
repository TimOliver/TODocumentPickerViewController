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

@class TODocumentPickerItem;

@interface TODocumentPickerViewController : UITableViewController

@property (nonatomic, strong)   id<TODocumentPickerViewControllerDataSource> dataSource;             /* Data source for file info. Retained by the document picker and shared among all children. */
@property (nonatomic, weak)     id<TODocumentPickerViewControllerDelegate>   documentPickerDelegate; /* Sends out delegate events to the assigned object */

@property (nonatomic, readonly) NSString *filePath;               /* The file path that this view controller corresponds to */
@property (nonatomic, strong)   NSArray  *items;                  /* All of the items displayed by this view controller. (Setting this will trigger a UI refresh) */

@property (nonatomic, strong)   NSArray *allowedFileExtensions;   /* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, assign)   BOOL showExcludedFileExtensions;  /* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */

@property (nonatomic, strong)   NSDictionary *fileFormatIcons;    /* If dealing with custom formats, this lets you add custom icons for those formats (Images must be 40x40 points) */
@property (nonatomic, strong)   UIImage *defaultIcon;             /* The default icon if the file format isn't recognized, or other icons aren't available. */
@property (nonatomic, strong)   UIImage *folderIcon;              /* The icon used for folder entries. */
@property (nonatomic, strong)   NSDictionary *fileIcons;          /* A dictionary of file extension strings to images to use as icons for each file format. */

@property (nonatomic, readonly) TODocumentPickerViewController *rootViewContorller; /* In a navigation chain of picker controllers, the root controller at the front.  */
@property (nonatomic, readonly) NSArray *viewControllers;         /* The chain of document picker view controllers in the navigation stack */

@property (nonatomic, assign)   Class tableViewCellClass;         /* If desired, a custom table view cell class that can contain additional controls or formatting. */
@property (nonatomic, strong)   NSDictionary *themeAttributes;    /* Attributes for applying a new colour scheme to this view controller. */

/* Set the list of items for the view controller in charge of that file path */
- (void)setItems:(NSArray<TODocumentPickerItem *> *)items forFilePath:(NSString *)filePath;

@end
