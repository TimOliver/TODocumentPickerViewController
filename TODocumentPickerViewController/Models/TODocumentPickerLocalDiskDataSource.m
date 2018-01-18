//
//  TODocumentPickerFileDataSource.m
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

#import "TODocumentPickerLocalDiskDataSource.h"
#import "TODocumentPickerViewController.h"

@interface TODocumentPickerLocalDiskDataSource ()

@property (nonatomic, copy) NSString *rootFilePath;

@end

@implementation TODocumentPickerLocalDiskDataSource

- (instancetype)init
{
    if (self = [self initWithBaseFolderPath:nil]) {

    }

    return self;
}

- (instancetype)initWithBaseFolderPath:(NSString *)folderPath
{
    if (self = [super init]) {
        _rootFilePath = [TODocumentPickerLocalDiskDataSource formattedRootFilePath:folderPath];
        self.rootFolderName = _rootFilePath.lastPathComponent;
    }

    return self;
}

+ (NSString *)formattedRootFilePath:(NSString *)filePath
{
    // If it doesn't start with '/', assume absolute
    if (filePath.length && [filePath characterAtIndex:0] != '/') {
        return filePath;
    }

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *applicationSandboxPath = [documentPath stringByDeletingLastPathComponent];
    return applicationSandboxPath;
}

#pragma mark - Data Source Protocol Methods-

- (NSString *)documentPickerViewController:(TODocumentPickerViewController *)documentPicker titleForFilePath:(NSString *)filePath
{
    if (!self.rootFolderName) {
        return filePath.lastPathComponent;
    }
    else {
        if (filePath.length == 0 || [filePath isEqualToString:@"/"]) {
            return self.rootFolderName;
        }
    }

    return filePath.lastPathComponent;
}

- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker
             requestItemsForFilePath:(NSString *)filePath
                   completionHandler:(void (^)(NSArray<TODocumentPickerItem *> * _Nullable))completionHandler
{
    NSString *fullFilePath = [self.rootFilePath stringByAppendingPathComponent:filePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullFilePath error:nil];

    NSMutableArray *items = [NSMutableArray array];
    for (NSString *file in files) {
        // Skip hidden files if required
        if (!self.showHiddenFiles && [file characterAtIndex:0] == '.') {
            continue;
        }

        NSString *path = [fullFilePath stringByAppendingPathComponent:file];

        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        TODocumentPickerItem *item = [TODocumentPickerItem new];
        item.fileName = file;
        item.isFolder = (attributes.fileType == NSFileTypeDirectory);
        item.fileSize = item.isFolder ? 0 : (NSUInteger)attributes.fileSize;
        item.lastModifiedDate = attributes.fileModificationDate;
        [items addObject:item];
    }

    completionHandler(items);
}

@end
