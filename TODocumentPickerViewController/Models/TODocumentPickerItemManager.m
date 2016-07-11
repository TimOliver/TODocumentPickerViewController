//
//  TODocumentPickerItemManager.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
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
@property (nonatomic, strong) NSArray *sectionedItems;  /* A list containing lists of items for each section */
@property (nonatomic, strong) NSArray *filteredItems;   /* A single list of filtered items */

@property (nonatomic, strong) NSArray *sectionTitles;    /* Names of the sections, aligned to sectionedItems property. */

- (void)rebuildItems; /* Flush out, and rebuild the list of items */
- (BOOL)shouldUseSections;  /* Calculate if we should use sections or not */
- (void)updateTableView;

- (NSArray *)sortedItemsArrayWithArray:(NSArray *)items; /* Build a sorted list of items. */
- (NSArray *)sectionedItemsWithArray:(NSArray *)items;   /* Build a sectioned list of sorted lists of items. */
- (NSArray *)filteredItemsWithItems:(NSArray *)items searchString:(NSString *)searchString; /* Take a list and filter it out */

- (NSArray *)sectionTitlesForItems:(NSArray *)items;

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
    self.sectionedItems = nil;
    self.filteredItems  = nil;
    self.sectionTitles  = nil;
    
    //A search string overrides all other lists
    if (self.searchString.length > 0) {
        self.filteredItems = [self filteredItemsWithItems:self.items searchString:self.searchString];
        self.filteredItems = [self sortedItemsArrayWithArray:self.filteredItems];
    }
    //if sections are warranted, sort them out, else do a flat single list
    else if ([self shouldUseSections]) {
        self.sectionTitles = [self sectionTitlesForItems:self.items];
        self.sectionedItems = [self sectionedItemsWithArray:self.items];
    }
    else {
        self.sortedItems = [self sortedItemsArrayWithArray:self.items];
    }
    
    [self updateTableView];
}

- (BOOL)shouldUseSections
{
    if (self.tableView == nil || self.sortingType > TODocumentPickerSortTypeNameDescending)
        return NO;
    
    CGSize tableSize = self.tableView.bounds.size;
    CGFloat height = MAX(tableSize.width, tableSize.height);
    
    //We should use sections if the height of all rows is > 150% the height of the table
    if (floor(self.items.count * self.tableView.rowHeight) >= floor(height * 1.5f))
        return YES;
    
    return NO;
}

- (void)updateTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.contentReloadedHandler)
            self.contentReloadedHandler();
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

- (NSArray *)sectionedItemsWithArray:(NSArray *)items
{
    SEL selector = @selector(fileName);
    NSInteger sectionTitlesCount = self.sectionTitles.count;
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in items) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = mutableSections[idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    NSArray *sections = [NSArray arrayWithArray:mutableSections];
    if (self.sortingType == TODocumentPickerSortTypeNameDescending)
        sections = [[sections reverseObjectEnumerator] allObjects];
    
    return sections;
}

- (NSArray *)sectionTitlesForItems:(NSArray *)items
{
    NSArray *localizedSectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    if (self.sortingType == TODocumentPickerSortTypeNameDescending)
        localizedSectionTitles = [[localizedSectionTitles reverseObjectEnumerator] allObjects];
    
    return localizedSectionTitles;
}

- (NSArray *)filteredItemsWithItems:(NSArray *)items searchString:(NSString *)searchString
{
    NSMutableArray *filteredItems = [NSMutableArray array];
    [items enumerateObjectsWithOptions:0 usingBlock:^(TODocumentPickerItem *item, NSUInteger i, BOOL *stop) {
        if ([item.fileName rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].location != NSNotFound)
            [filteredItems addObject:item];
    }];
    
    return [NSArray arrayWithArray:filteredItems];
}

#pragma mark - Item Serving -
- (TODocumentPickerItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    if (self.filteredItems)
        return self.filteredItems[indexPath.row];
    
    if (self.sectionedItems)
        return self.sectionedItems[indexPath.section][indexPath.row];
    
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
    if (self.sectionTitles.count == 0)
        return nil;
    
    //Append the search icon at the front
    return [@[@"{search}"] arrayByAddingObjectsFromArray:self.sectionTitles];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    if ([self.sectionedItems[section] count] == 0)
        return nil;
    
    return self.sectionTitles[section];
}

- (NSInteger)sectionForSectionIndexAtIndex:(NSInteger)index
{
    if (index == 0)
        return -1;
        
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
}

#pragma mark - Accessors -
- (BOOL)sectionIndexIsVisible { return self.sortingType <= TODocumentPickerSortTypeNameDescending; }

- (void)setItems:(NSArray *)items
{
    if (items == _items)
        return;
    
    _items = items;
    
    if (self.tableView == nil)
        return;
    
    [self rebuildItems];
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    if (sortingType == _sortingType)
        return;
    
    _sortingType = sortingType;
    
    if (self.tableView == nil)
        return;
    
    [self rebuildItems];
}

- (void)setSearchString:(NSString *)searchString
{
    if (searchString == _searchString)
        return;
    
    _searchString = searchString;
    
    if (self.tableView == nil)
        return;
    
    [self rebuildItems];
}

@end
