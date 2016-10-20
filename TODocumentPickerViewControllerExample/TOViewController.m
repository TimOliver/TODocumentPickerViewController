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

- (IBAction)defaultButtonTapped:(id)sender
{
    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithFilePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    documentPicker.documentPickerDelegate = self;

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)darkButtonTapped:(id)sender
{
    TODocumentPickerConfiguration *configuration = [[TODocumentPickerConfiguration alloc] init];
    configuration.style = TODocumentPickerViewControllerStyleDarkContent;

    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithConfiguration:configuration filePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    documentPicker.documentPickerDelegate = self;

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    controller.navigationBar.barStyle = UIBarStyleBlack;
    controller.toolbar.barStyle = UIBarStyleBlack;
    controller.view.tintColor = [UIColor colorWithRed:93.0f/255.0f green:128.0f/255.0f blue:198.0f/255.0f alpha:1.0f];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didPickItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *absoluteItemPaths = [NSMutableArray array];
    for (TODocumentPickerItem *item in items) {
        NSString *absoluteFilePath = [filePath stringByAppendingPathComponent:item.fileName];
        [absoluteItemPaths addObject:absoluteFilePath];
    }

    NSLog(@"Paths for items selected: %@", absoluteItemPaths);
}

- (void)documentPickerViewControllerDidChangeSelectedItems:(TODocumentPickerViewController *)documentPicker
{
    NSLog(@"%ld items selected!", (long)documentPicker.numberOfSelectedItems);
}

- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSetSelecting:(BOOL)selecting
{
    NSLog(@"Selection mode is %@!", selecting ? @"on" : @"off");
}

@end
