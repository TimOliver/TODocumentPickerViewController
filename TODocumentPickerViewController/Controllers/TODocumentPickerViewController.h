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

@property (nonatomic, weak)   id<TODocumentPickerViewControllerDelegate> documentPickerDelegate;  /* Sends feedback events to another object */
@property (nonatomic, strong) TODocumentPickerViewControllerDataSource *dataSource;               /* Readonly access to the data source for additonal changes. */
@property (nonatomic, strong) NSArray *allowedFileExtensions;                                     /* File extensions that may be chosen */

@end

//-------------------------------------------------------------------------

/**
 An abstract class that is used to provide the document with the necessary file data
 */
@interface TODocumentPickerViewControllerDataSource : NSObject

/* When an asynchronous load is complete, call this block to update the document picker with the new items. */
@property (nonatomic, copy, readonly) void (^updateItemsForFilePath)(NSArray *items, NSString *filePath);

- (void)requestItemsForFilePath:(NSString *)filePath;  /* (REQUIRED) Begin a potentially asynchronous request for a list of items. */
- (void)cancelRequestForFilePath:(NSString *)filePath; /* (REQUIRED) Cancel an asynchronous request in-progress */

- (NSString *)titleForFilePath:(NSString *)filePath;   /* (OPTIONAL) If necessary, provide a custom title for each file path item. */

@end

//-------------------------------------------------------------------------

@protocol TODocumentPickerViewControllerDelegate <NSObject>

/* User tapped a single file to download */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItemAtFilePath:(NSString *)filePath;

/* User selected a set of items and tapped */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(NSArray *)items;

@end
