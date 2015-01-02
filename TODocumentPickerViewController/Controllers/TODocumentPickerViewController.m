//
//  TODocumentPickerViewController.m
//
//  Copyright 2015 Timothy Oliver. All rights reserved.
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

#import "TODocumentPickerViewController.h"

@interface TODocumentPickerViewController ()

@property (nonatomic, strong) UIBarButtonItem *doneButton;

- (void)setup;
- (void)pushNewViewControllerForFilePath:(NSString *)filePath animated:(BOOL)animated;
- (void)updateItems:(NSArray *)items forFilePath:(NSString *)filePath;
- (TODocumentPickerTableViewController *)tableViewControllerForFilePath:(NSString *)filePath;

- (void)doneButtonTapped:(id)sender;

@end

@implementation TODocumentPickerViewController

#pragma mark - Init Overrides -
- (instancetype)init
{
    if (self = [super init])
        [self setup];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])
        [self setup];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
        [self setup];
    
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    [NSException raise:NSInternalInconsistencyException format:@"Custom view controllers cannot be pushed to this implementation."];
    return nil;
}

#pragma mark - Setup and Management -
- (void)setup
{
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
}

- (void)viewDidLoad
{
    //If no view controllers have been added yet, start setting them up now
    if (self.viewControllers.count == 0)
        [self pushNewViewControllerForFilePath:@"/" animated:NO];
}

- (void)pushNewViewControllerForFilePath:(NSString *)filePath animated:(BOOL)animated
{
    __block TODocumentPickerViewController *blockSelf = self;
    
    TODocumentPickerTableViewController *tableController = [TODocumentPickerTableViewController new];
    tableController.filePath = filePath;
    tableController.title = [self.dataSource titleForFilePath:filePath];
    tableController.refreshControlHandler = ^{ [blockSelf.dataSource requestItemsForFilePath:filePath]; };
    [self pushViewController:tableController animated:animated];
    
    [self.dataSource requestItemsForFilePath:filePath];
}

#pragma mark - Public Item Interactions -
- (void)updateItems:(NSArray *)items forFilePath:(NSString *)filePath
{
    TODocumentPickerTableViewController *controller = [self tableViewControllerForFilePath:filePath];
    if (controller == nil)
        return;
    
    [controller.refreshControl endRefreshing];
    
    controller.items = items;
}

#pragma mark - Lookup methods -
- (TODocumentPickerTableViewController *)tableViewControllerForFilePath:(NSString *)filePath
{
    for (TODocumentPickerTableViewController *controller in self.viewControllers) {
        if ([controller.filePath isEqualToString:filePath])
            return controller;
    }
    
    return nil;
}

#pragma mark - Navigation Controller Overrides -
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.rightBarButtonItem = self.doneButton;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Button Callbacks - 
- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Accessors -
- (void)setDataSource:(TODocumentPickerViewControllerDataSource *)dataSource
{
    if (_dataSource == dataSource)
        return;
    
    _dataSource = dataSource;
    
    if (_dataSource) {
        __block TODocumentPickerViewController *blockSelf = self;
        id updateBlock = ^(NSArray *items, NSString *filePath) {
            [blockSelf updateItems:items forFilePath:filePath];
        };
        
        [_dataSource setValue:updateBlock forKey:@"updateItemsForFilePath"];
    }
}

@end

#pragma mark - Data Source Implementation -

//----------------------------------------------------------------------------------------------
// Data Source Abstract Class Implementation

@interface TODocumentPickerViewControllerDataSource ()

@property (nonatomic, readwrite, copy) void (^updateItemsForFilePath)(NSArray *items, NSString *filePath);

@end

@implementation TODocumentPickerViewControllerDataSource

- (void)requestItemsForFilePath:(NSString *)filePath  { [self doesNotRecognizeSelector:_cmd]; }
- (void)cancelRequestForFilePath:(NSString *)filePath { [self doesNotRecognizeSelector:_cmd]; }

- (NSString *)titleForFilePath:(NSString *)filePath
{
    return [filePath lastPathComponent];
}

@end
