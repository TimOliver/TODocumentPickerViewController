//
//  TODocumentPickerFileDataSource.h
//
//  Copyright 2015-2017 Timothy Oliver. All rights reserved.
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
#import "TODocumentPickerConstants.h"

@interface TODocumentPickerLocalDiskDataSource : NSObject<TODocumentPickerViewControllerDataSource>

/** Allows you to override the title of the root folder displayed initially. */
@property (nonatomic, copy) NSString *rootFolderName;

/** Shows files that have been prefixed with a '.' character. */
@property (nonatomic, assign) BOOL showHiddenFiles;

/* Create a new instance of this data source, with the supplied file path
   pointing to the folder that will be initially displayed.
   If the file path is relative (eg, starts with '/'), the app's top-most directory
   in the sandbox will be used.
 */
- (instancetype)initWithBaseFolderPath:(NSString *)folderPath;

@end
