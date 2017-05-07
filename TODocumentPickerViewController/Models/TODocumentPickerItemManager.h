//
//  TODocumentPickerItemManager.h
//
//  Copyright 2015-2017 Timothy Oliver. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TODocumentPickerConstants.h"

@class TODocumentPickerItem;

@interface TODocumentPickerItemManager : NSObject

/* Main configuration properties (Changing any of these properties will cause a reload) */
@property (nonatomic, strong) NSArray *items;                       /* Items are passed to the manager by setting this property. */
@property (nonatomic, assign) TODocumentPickerSortType sortingType; /* The order in which items are displayed. */
@property (nonatomic, copy)   NSString *searchString;               /* Filter the items with this string */

@property (nonatomic, readonly) BOOL sectionIndexIsVisible;         /* Determines whether the list on the right side is visible. */

@property (nonatomic, weak) UITableView *tableView;                 /* A weak reference to the relating table view. */
@property (nonatomic, copy) void (^contentReloadedHandler)(void);   /* A handler called each time the manager decides to reload the table view. */

/* Start sorting items, if not already done so. */
- (void)reloadItems;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsForSection:(NSInteger)section;
- (TODocumentPickerItem *)itemForIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)sectionIndexTitles;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSInteger)sectionForSectionIndexAtIndex:(NSInteger)index;

@end
