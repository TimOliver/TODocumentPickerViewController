//
//  ViewController.m
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 12/31/14.
//  Copyright (c) 2014 Tim Oliver. All rights reserved.
//

#import "TOViewController.h"
#import "TODocumentPickerViewController.h"
#import "TODocumentsDataSource.h"

@interface TOViewController () <TODocumentPickerViewControllerDelegate>

@end

@implementation TOViewController

- (IBAction)buttonTapped:(id)sender
{
    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithFilePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    documentPicker.documentPickerDelegate = self;

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *absoluteItemPaths = [NSMutableArray array];
    for (TODocumentPickerItem *item in items) {
        NSString *absoluteFilePath = [filePath stringByAppendingPathComponent:item.fileName];
        [absoluteItemPaths addObject:absoluteFilePath];
    }

    NSLog(@"Paths for items selected: %@", absoluteItemPaths);
}

@end
