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
    TODocumentPickerViewController *documentPicker = [TODocumentPickerViewController new];
    documentPicker.dataSource = [TODocumentsDataSource new];
    [self presentViewController:documentPicker animated:YES completion:nil];
}

@end
