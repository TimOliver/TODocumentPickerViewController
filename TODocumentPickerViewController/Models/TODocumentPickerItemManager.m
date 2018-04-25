//
//  TODocumentPickerItemManager.m
//
//  Copyright 2015-2018 Timothy Oliver. All rights reserved.
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

#import "TODocumentPickerItemManager.h"
#import "TODocumentPickerItem.h"

@interface TODocumentPickerItemManager ()

@property (nonatomic, strong) NSArray *sortedItems;     /* A single list of sorted items */
@property (nonatomic, strong) NSArray *filteredItems;   /* A single list of filtered items */

@end

@implementation TODocumentPickerItemManager

#pragma mark - Item Sorting -
- (void)reloadItems
{
    [self rebuildItems];
}

- (void)rebuildItems
{
    /* Clear out all of the lists */
    self.sortedItems    = nil;
    self.filteredItems  = nil;
    
    //A search string overrides all other lists
    if (self.searchString.length > 0) {
        self.filteredItems = [self filteredItemsWithItems:self.items searchString:self.searchString];
        self.filteredItems = [self sortedItemsArrayWithArray:self.filteredItems];
    }
    else {
        self.sortedItems = [self sortedItemsArrayWithArray:self.items];
    }
    
    [self updateTableView];
}

- (void)updateTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.contentReloadedHandler) {
            self.contentReloadedHandler();
        }
    });
}

- (NSArray *)sortedItemsArrayWithArray:(NSArray *)items
{
    BOOL reverse = NO;
    NSString *sortKey = nil;
    
    switch (self.sortingType) {
        //File name needs to be explicitly sorted, so additional flags like
        //case-insensitive and numeric handling are properly set
        case TODocumentPickerSortTypeNameDescending: reverse = YES;
        case TODocumentPickerSortTypeNameAscending: 
            items = [items sortedArrayUsingComparator:^NSComparisonResult(TODocumentPickerItem *first, TODocumentPickerItem *second) {
                return [first.fileName compare:second.fileName options:NSCaseInsensitiveSearch|NSNumericSearch|NSDiacriticInsensitiveSearch];
            }];
            if (reverse)
                items = [[items reverseObjectEnumerator] allObjects];
            
            return items;
            
        case TODocumentPickerSortTypeDateDescending: reverse = YES;
        case TODocumentPickerSortTypeDateAscending:  sortKey = @"lastModifiedDate";
            break;
            
        case TODocumentPickerSortTypeSizeDescending: reverse = YES;
        case TODocumentPickerSortTypeSizeAscending:  sortKey = @"fileSize";
            break;
    }
    
    //Sort the files
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:!reverse];
    items = [items sortedArrayUsingDescriptors:@[sortDescriptor]];
    return items;
}

- (NSArray *)filteredItemsWithItems:(NSArray *)items searchString:(NSString *)searchString
{
    NSMutableArray *filteredItems = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(TODocumentPickerItem *item, NSUInteger i, BOOL *stop) {
        if ([item.fileName rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].location != NSNotFound) {
            [filteredItems addObject:item];
        }
    }];
    
    return [NSArray arrayWithArray:filteredItems];
}

#pragma mark - Item Serving -
- (TODocumentPickerItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    if (self.filteredItems) {
        return self.filteredItems[indexPath.row];
    }
    
    if (self.sortedItems) {
        return self.sortedItems[indexPath.row];
    }
    
    return nil;
}

#pragma mark - Accessors -

- (NSInteger)numberOfItems
{
    if (self.filteredItems) {
        return self.filteredItems.count;
    }
    
    return self.items.count;
}

- (void)setItems:(NSArray *)items
{
    if (items == _items) { return; }
    
    _items = items;
    
    if (self.tableView == nil) {
        return;
    }
    
    [self rebuildItems];
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    if (sortingType == _sortingType) { return; }
    
    _sortingType = sortingType;
    
    if (self.tableView == nil)
        return;
    
    [self rebuildItems];
}

- (void)setSearchString:(NSString *)searchString
{
    if (searchString == _searchString) { return; }
    
    _searchString = searchString;
    
    if (self.tableView == nil)
        return;
    
    [self rebuildItems];
}

@end
