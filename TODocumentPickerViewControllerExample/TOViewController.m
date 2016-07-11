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

@interface TOViewController ()

@end

@implementation TOViewController

- (IBAction)buttonTapped:(id)sender
{
    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithFilePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
