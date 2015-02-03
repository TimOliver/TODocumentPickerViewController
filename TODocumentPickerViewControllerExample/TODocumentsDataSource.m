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
    NSString *documentsFilePath = [self documentsPath];
    
    NSArray *folders = @[@"Apps",
                         @"Archive",
                         @"Books",
                         @"Comics",
                         @"Documents",
                         @"Examples",
                         @"Music",
                         @"Photos",
                         @"Pictures",
                         @"Programs",
                         @"Public",
                         @"Save Files",
                         @"Shared",
                         @"Sites",
                         @"Writing",
                         @"Apps/iComics",
                         @"Apps/Dropbox",
                         @"Archive/Design Docs",
                         @"Comics/Adventures in Space",
                         @"Documents/Invoices",
                         @"Examples/PSDs",];
    
    for (NSString *folder in folders) {
        NSString *filePath = [documentsFilePath stringByAppendingPathComponent:folder];
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *textFiles = @[@"DesignPlan.txt",
                           @"HelloWorld.txt",
                           @"Blog Posts.txt",
                           @"Test Document.txt",
                           @"Upcoming Projects.txt"
                           ];
    
    for (NSString *file in textFiles) {
        NSString *filePath = [documentsFilePath stringByAppendingPathComponent:file];
        [file writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
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
        item.isFolder = (attributes.fileType == NSFileTypeDirectory);
        item.fileSize = item.isFolder ? 0 : (NSUInteger)attributes.fileSize;
        item.lastModifiedDate = attributes.fileModificationDate;
        [items addObject:item];
    }
    
    self.updateItemsForFilePath(items, filePath);
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
