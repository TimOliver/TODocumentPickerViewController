//
//  TODocumentPickerDefines.h
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

#import <UIKit/UIKit.h>
#import <Foundation/FOundation.h>

@class TODocumentPickerViewController;
@class TODocumentPickerItem;

/*
 The default content styles that the controller implements.
 */
typedef NS_ENUM(NSInteger, TODocumentPickerViewControllerStyle) {
    TODocumentPickerViewControllerStyleLight,
    TODocumentPickerViewControllerStyleDark
};

/* 
 The various sorting orders in which the picker can display the files. 
*/
typedef NS_ENUM(NSInteger, TODocumentPickerSortType) {
    TODocumentPickerSortTypeNameAscending=0,
    TODocumentPickerSortTypeNameDescending,
    TODocumentPickerSortTypeDateAscending,
    TODocumentPickerSortTypeDateDescending,
    TODocumentPickerSortTypeSizeAscending,
    TODocumentPickerSortTypeSizeDescending
};

//-------------------------------------------------------------------------
// The data source protocol for objects charged with loading the file information to display

@protocol TODocumentPickerViewControllerDataSource <NSObject>

@required

/**
 Called by the view controller when it wants to obtain a list of items for the folder at the end of the file path.
 Whether the data source subsequently hands off this request asynchronously or not, when completed, the data source
 must call the 'updateItemsForFilePath' block.
 
 @param filePath The file path with which to download file information
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker
             requestItemsForFilePath:(nonnull NSString *)filePath
                   completionHandler:(nonnull void (^)(NSArray<TODocumentPickerItem *> * _Nullable items))completionHandler;

@optional

/**
 If an asynchronous request for files is currently in progress and the representing view controller is canceled,
 (eg, if the user hits 'back' before it completes), this method will be called to give the request a chance to cancel.
 
 @param filePath The file path with which to cancel loading
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker cancelRequestForFilePath:(nonnull NSString *)filePath;

/** 
 After a table cell has been configured for display, this method allows for additional custom configuration of the cell after the fact.
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker configureCell:(nonnull UITableViewCell *)cell withItem:(nonnull TODocumentPickerItem *)item;

/**
 The title that will appear in the navigation bar for the folder at this file path.
 If not implemented, defautl behaviour is to return simply the folder name from the filePath string
 */
- (nullable NSString *)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker titleForFilePath:(nullable NSString *)filePath;

/**
 If desired, this method may be overridden to provide a custom icon for items that represent folders in the file system.
 */
- (nonnull UIImage *)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker folderIconForStyle:(TODocumentPickerViewControllerStyle)style;

/**
 If desired, a custom icon can be provided by default for each type of file that the view controller is displaying. `extension` can be `nil` for unknown file types.
 */
- (nonnull UIImage *)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker fileIconForExtension:(nullable NSString *)extension style:(TODocumentPickerViewControllerStyle)style;

@end

//-------------------------------------------------------------------------

@protocol TODocumentPickerViewControllerDelegate <NSObject>

@optional

/* User either tapped a single item, or selected multiple items and hit 'choose' */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker didSelectItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(nullable NSString *)filePath;

@end

//-------------------------------------------------------------------------
// Size of the default file and folder icons

static const CGSize kTODocumentPickerDefaultFolderIconSize  = (CGSize){47,37};
static const CGSize kTODocumentPickerDefaultFileIconSize    = (CGSize){37,49};
