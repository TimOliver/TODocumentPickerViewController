//
//  TODocumentPickerTableViewController.h
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

#import <UIKit/UIKit.h>
#import "TODocumentPickerViewController.h"

@interface TODocumentPickerTableViewController : UITableViewController

@property (nonatomic, copy)   void (^refreshControlHandler)(void); /* Handler block called whenever the refresh control is triggered. */
@property (nonatomic, copy)   NSString *filePath; /* The file path that this view controller corresponds to */
@property (nonatomic, strong) NSArray  *items;    /* All of the items displayed by this view controller. (Setting this will trigger a refresh) */

@end

/* Private method implementations accessible by child table view controllers for their parent document picker controller. */
@interface TODocumentPickerViewController (TODocumentPickerTableViewController)

/**
 Manually update the items in a specific table view controller.
 
 */
- (void)updateItems:(NSArray *)items forFilePath:(NSString *)filePath;
- (void)pushNewViewControllerForFilePath:(NSString *)filePath animated:(BOOL)animated;

@end
