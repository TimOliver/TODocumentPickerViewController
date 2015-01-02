//
//  TODocumentsDataSource.m
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 1/1/15.
//  Copyright (c) 2015 Tim Oliver. All rights reserved.
//

#import "TODocumentsDataSource.h"

@interface TODocumentsDataSource ()

- (void)createTestData;
- (NSString *)documentsPath;

@end

@implementation TODocumentsDataSource

- (instancetype)init
{
    if (self = [super init]) {
        [self createTestData];
    }
    
    return self;
}

- (void)createTestData
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *documentsFilePath = [self documentsPath];
    
    NSString *folder1 = [documentsFilePath stringByAppendingPathComponent:@"Folder 1"];
    [defaultManager createDirectoryAtPath:folder1 withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *subFolder1 = [folder1 stringByAppendingPathComponent:@"Sub Folder 1"];
    [defaultManager createDirectoryAtPath:subFolder1 withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *folder2 = [documentsFilePath stringByAppendingPathComponent:@"Folder 2"];
    [defaultManager createDirectoryAtPath:folder2 withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *textFile = [documentsFilePath stringByAppendingPathComponent:@"Hello World.txt"];
    [@"Hello world!" writeToFile:textFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Class Override -
- (void)requestItemsForFilePath:(NSString *)filePath
{
    NSString *fullFilePath = [self.documentsPath stringByAppendingPathComponent:filePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullFilePath error:nil];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *file in files) {
        NSString *path = [fullFilePath stringByAppendingPathComponent:file];
        
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        TODocumentPickerItem *item = [TODocumentPickerItem new];
        item.fileName = file;
        item.fileSize = attributes.fileSize;
        item.isFolder = (attributes.fileType == NSFileTypeDirectory);
        [items addObject:item];
    }
    
    self.updateItemsForFilePath(items, filePath);
}

- (void)cancelRequestForFilePath:(NSString *)filePath
{
    
}

- (NSString *)titleForFilePath:(NSString *)filePath
{
    if ([filePath isEqualToString:@"/"])
        return @"Documents";
    
    return [filePath lastPathComponent];
}

#pragma mark - Static Data -
- (NSString *)documentsPath
{
    static NSString *sharedDocumentsDirectoryPath = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedDocumentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    return sharedDocumentsDirectoryPath;
}

@end
