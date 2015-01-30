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
    
    NSArray *folders = @[@"Degree",
                         @"Value",
                         @"Whip",
                         @"Account",
                         @"Bead",
                         @"Horn",
                         @"Credit",
                         @"Death",
                         @"Zoo",
                         @"Slave",
                         @"Mask",
                         @"Library",
                         @"Front",
                         @"Tub",
                         @"Kettle",
                         @"Club",
                         @"Cherries",
                         @"Song",
                         @"Summer",
                         @"Rule",
                         @"Account/A - Subfolder",
                         @"Account/B - Subfolder",
                         @"AccountC - Subfolder",
                         @"AccountD - Subfolder",
                         @"Account/E - Subfolder",
                         @"Account/F - Subfolder",];
    
    for (NSString *folder in folders) {
        NSString *filePath = [documentsFilePath stringByAppendingPathComponent:folder];
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *textFile = [documentsFilePath stringByAppendingPathComponent:@"Hello World.txt"];
    [@"Hello world!" writeToFile:textFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *textFile2 = [documentsFilePath stringByAppendingPathComponent:@"AAA.txt"];
    [@"XD!" writeToFile:textFile2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
        item.fileSize = (NSUInteger)attributes.fileSize;
        item.lastModifiedDate = attributes.fileModificationDate;
        item.isFolder = (attributes.fileType == NSFileTypeDirectory);
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
