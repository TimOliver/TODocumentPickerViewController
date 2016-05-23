//
//  TODocumentPickerDefines.h
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
#import <Foundation/FOundation.h>

@class TODocumentPickerViewController;

/*
 The default content styles that the controller implements.
 */
typedef NS_ENUM(NSInteger, TODocumentPickerViewControllerStyle) {
    TODocumentPickerViewControllerStyleLightContent,
    TODocumentPickerViewControllerStyleDarkContent
};

/* 
 The various sorting orders in which the picker can display the files. 
*/
typedef NS_ENUM(NSInteger, TODocumentPickerSortType) {
    TODocumentPickerSortTypeNameAscending,
    TODocumentPickerSortTypeNameDescending,
    TODocumentPickerSortTypeDateAscending,
    TODocumentPickerSortTypeDateDescending,
    TODocumentPickerSortTypeSizeAscending,
    TODocumentPickerSortTypeSizeDescending
};

//-------------------------------------------------------------------------
// The data source protocol for objects charged with loading the file information to display

@protocol TODocumentPickerViewControllerDataSource <NSObject>

/**
 The first instance of the document view controller that this data source object was assigned.
 */
@property (nonatomic, readonly) TODocumentPickerViewController *rootDocumentPickerViewController;

/**
 The class for which table view cells in the document picker will be instantiated off.
 This can be used to insert new table view cell classes with additional configurable views.
 If this property is not set, the default value of [UITableViewCell Class] is used instead
 */
- (Class)tableCellViewClassForDocumentPickerViewController:(TODocumentPickerViewController *)documentPicker;

/**
 Whether synchronously or asynchronously, when your data source has finished building
 a list of items, you must call this block to pass those items back up to the view controller.
 (For UI considerations, this block always executes on the main thread)
 */
//@property (nonatomic, copy, readonly) void (^updateItemsForFilePath)(NSArray *items, NSString *filePath);

/**
 Called by the view controller when it wants to obtain a list of items for the folder at the end of the file path.
 Whether the data source subsequently hands off this request asynchronously or not, when completed, the data source
 must call the 'updateItemsForFilePath' block.
 
 @param filePath The file path with which to download file information
 */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker requestItemsForFilePath:(NSString *)filePath;

/**
 If an asynchronous request for files is currently progress and the representing view controller is canceled,
 (eg, if the user hits 'back' before it completes), this method will be called to give the request a chance to cancel.
 
 @param filePath The file path with which to cancel loading
 */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker cancelRequestForFilePath:(NSString *)filePath;

/**
 The title that will appear in the navigation bar for the folder at this file path.
 If not implemented, defautl behaviour is to return simply the folder name from the filePath string
 */
- (NSString *)documentPickerViewController:(TODocumentPickerViewController *)documentPicker titleForFilePath:(NSString *)filePath;

@end

//-------------------------------------------------------------------------

@protocol TODocumentPickerViewControllerDelegate <NSObject>

/* User tapped a single file to download */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItemAtFilePath:(NSString *)filePath;

/* User selected a set of items and tapped */
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(NSArray *)items;

//-------------------------------------------------------------------------