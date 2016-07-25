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

//    NSMutableDictionary *themeAttributes = [NSMutableDictionary dictionary];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeBackgroundColor]     = [UIColor colorWithWhite:45.0f/255.0f alpha:1.0];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableSeparatorColor] = [UIColor colorWithWhite:200.0f/255.0f alpha:1.0];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableCellTitleColor] = [UIColor whiteColor];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableCellDetailTextColor] = [UIColor colorWithWhite:100.0/255.0f alpha:1.0f];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableCellAccessoryTintColor] = [UIColor colorWithWhite:1.0f alpha:0.75f];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableSectionHeaderBackgroundColor] = [UIColor colorWithWhite:90.0f/255.0f alpha:1.0];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableSectionTitleColor] = [UIColor whiteColor];
//    themeAttributes[TODocumentPickerViewControllerThemeAttributeTableSectionIndexColor] = [UIColor whiteColor];
//    configuration.themeAttributes = themeAttributes;

    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithConfiguration:configuration filePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    documentPicker.documentPickerDelegate = self;

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    controller.navigationBar.barStyle = UIBarStyleBlack;
    controller.toolbar.barStyle = UIBarStyleBlack;
    controller.view.tintColor = [UIColor whiteColor];

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
