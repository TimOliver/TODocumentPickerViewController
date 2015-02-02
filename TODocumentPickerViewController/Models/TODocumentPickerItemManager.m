//
//  TODocumentPickerItemManager.m
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

#import "TODocumentPickerItemManager.h"

@interface TODocumentPickerItemManager ()

@property (nonatomic, strong) NSArray *sortedItems;     /* A single list of sorted items */
@property (nonatomic, strong) NSArray *sectionedItems;  /* A list containing lists of items for each section */
@property (nonatomic, strong) NSArray *filteredItems;   /* A single list of filtered items */

@property (nonatomic, strong) NSArray *sectionNames;    /* Names of the sections, aligned to sectionedItems property. */

- (void)rebuildItems; /* Flush out, and rebuild the list of items */
- (BOOL)shouldUseSections;  /* Calculate if there's enough items to warrant sections */

- (NSArray *)sortedItemsArrayWithArray:(NSArray *)items;
- (NSArray *)sectionedItemsWithArray:(NSArray *)items;
- (NSArray *)filteredItemsWithSearchString:(NSString *)searchString;

@end

@implementation TODocumentPickerItemManager

#pragma mark - Item Sorting -
- (void)rebuildItems
{
    /* Clear out all of the lists */
    self.sortedItems    = nil;
    self.sectionedItems = nil;
    self.filteredItems  = nil;
    
    //A search string overrides all other lists
    if (self.searchString.length > 0) {
        self.filteredItems = [self filteredItemsWithSearchString:self.searchString];
        self.filteredItems = [self sortedItemsArrayWithArray:self.filteredItems];
        return;
    }
    
    //if sections are warranted, sort them out, else do a flat single list
    if ([self shouldUseSections])
        self.sectionedItems = [self sectionedItemsWithArray:nil];
    
    self.sortedItems = [self sortedItemsArrayWithArray:nil];
}

- (BOOL)shouldUseSections
{
    CGSize tableSize = self.tableView.bounds.size;
    CGFloat height = MAX(tableSize.width, tableSize.height);
    
    //We should use sections if the height of all rows is > 150% the height of the table
    if (self.items.count * self.tableView.rowHeight > height * 1.5f)
        return YES;
    
    return NO;
}

- (NSArray *)sortedItemsArrayWithArray:(NSArray *)items
{
    return nil;
}

- (NSArray *)sectionedItemsWithArray:(NSArray *)items
{
    return nil;
}

- (NSArray *)filteredItemsWithSearchString:(NSString *)searchString
{
    return nil;
}

#pragma mark - Item Serving -
- (TODocumentPickerItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    if (self.filteredItems)
        return self.filteredItems[indexPath.row];
    
    if (self.sectionedItems)
        return self.sectionedItems[indexPath.section][indexPath.section];
    
    if (self.sortedItems)
        return self.sortedItems[indexPath.row];
    
    return nil;
}

#pragma mark - Section Mangement -
- (NSInteger)numberOfSections
{
    if (self.sectionedItems)
        return self.sectionedItems.count;
    
    return 1;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section
{
    if (self.filteredItems)
        return self.filteredItems.count;
    
    if (self.sectionedItems)
        return [self.sectionedItems[section] count];
    
    if (self.sortedItems)
        return self.sortedItems.count;
    
    return 0;
}


#pragma mark - Section Index Mangement -
- (NSArray *)sectionIndexTitles
{
    return nil;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)sectionForSectionIndexAtIndex:(NSInteger)index
{
    return 0;
}

#pragma mark - Accessors -
- (BOOL)sectionIndexIsVisible { return self.sortingType <= TODocumentPickerSortTypeNameDescending; }

- (void)setItems:(NSArray *)items
{
    if (items == _items)
        return;
    
    _items = items;
    
    [self rebuildItems];
    [self.tableView reloadData];
    if (self.contentReloadedHandler)
        self.contentReloadedHandler();
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    if (sortingType == _sortingType)
        return;
    
    _sortingType = sortingType;
    
    [self rebuildItems];
    [self.tableView reloadData];
    if (self.contentReloadedHandler)
        self.contentReloadedHandler();
}

- (void)setSearchString:(NSString *)searchString
{
    if (searchString == _searchString)
        return;
    
    _searchString = searchString;
    
    [self rebuildItems];
    [self.tableView reloadData];
    if (self.contentReloadedHandler)
        self.contentReloadedHandler();
}

@end
