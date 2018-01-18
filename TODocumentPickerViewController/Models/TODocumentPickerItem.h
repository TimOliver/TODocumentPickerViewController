//
//  TODocumentPickerItem.h
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

@class TODocumentPickerViewController;

@interface TODocumentPickerItem : NSObject

@property (nonatomic, copy)   NSString   *fileName;         /** The full name of this file */
@property (nonatomic, assign) NSUInteger fileSize;          /** The size of the file in bytes */
@property (nonatomic, strong) NSDate     *lastModifiedDate; /** Where possible, the modification date of this file */
@property (nonatomic, assign) BOOL       isFolder;          /** Whether the file is a folder or now */

/** A pre-generated description of the item that is displayed in the picker view */
@property (nonatomic, copy, readonly) NSString *localizedMetadata;

@end
