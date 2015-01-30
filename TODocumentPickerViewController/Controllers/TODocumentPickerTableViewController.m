//
//  TODocumentPickerTableViewController.m
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

#import "TODocumentPickerTableViewController.h"
#import "TODocumentPickerItem.h"
#import "TODocumentPickerTableView.h"
#import "TODocumentPickerHeaderView.h"

/* Sorting categories for file size */
typedef NS_ENUM(NSInteger, TODocumentPickerSortingSize) {
    TODocumentPickerSortingSizeUnknown, //File size unknown
    TODocumentPickerSortingSizeTiny,    //Tiny files 0MB-10MB
    TODocumentPickerSortingSizeSmall,   //Small files 10MB-50MB
    TODocumentPickerSortingSizeMedium,  //Medium files 50MB-150MB
    TODocumentPickerSortingSizeBig,     //Big files 150MB - 1000MB
    TODocumentPickerSortingSizeHuge,    //Massive files > 1000MB
    TODocumentPickerSortingSizeFolder,  //Folder
    TODocumentPickerSortingSizeNumber   //Total for counting
};

/* Sorting categories for date */
typedef NS_ENUM(NSInteger, TODocumentPickerSortingDate) {
    TODocumentPickerSortingDateUnknown,
    TODocumentPickerSortingDateToday,
    TODocumentPickerSortingDateYesterday,
    TODocumentPickerSortingDateThisWeek,
    TODocumentPickerSortingDateThisMonth,
    TODocumentPickerSortingDateLastSixMonths,
    TODocumentPickerSortingDateLastYear,
    TODocumentPickerSortingDateLastDecade,
    TODocumentPickerSortingDateNumber   //Total for counting
};

@interface TODocumentPickerTableViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

/* Localized item collation management */
@property (nonatomic, strong) UILocalizedIndexedCollation *indexedCollation;

/* View management */
@property (nonatomic, strong) TODocumentPickerHeaderView *headerView;
@property (nonatomic, strong) UILabel *toolBarLabel;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

/* Edit mode toggle */
@property (nonatomic, strong) UIBarButtonItem *selectButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

/* Cell label fonts */
@property (nonatomic, strong) UIFont *cellFolderFont;
@property (nonatomic, strong) UIFont *cellFileFont;

/* Item Management */
@property (nonatomic, strong) NSArray *sortedItems;     /* Items in a single-section sorted order (ie date/size) */
@property (nonatomic, strong) NSArray *indexedItems;    /* For alphabetical sorting, an array of item arrays */
@property (nonatomic, strong) NSArray *filteredItems;   /* Items filtered via search */

/* Visible comics (Will be a subarray for names) */
@property (nonatomic, readonly) NSArray *visibleItems;

@property (nonatomic, assign) TODocumentPickerSortType sortingType;

@property (nonatomic, assign) BOOL headerBarInitiallyHidden;

/* Setup positions and constraints */
- (void)resetHeaderConstraints;
- (void)resetTableViewInitialOffset;

/* User interaction callbacks */
- (void)refreshControlTriggered;
- (void)selectButtonTapped;
- (void)doneButtonTapped:(id)sender;

/* Visual content updates */
- (void)updateContent;
- (void)updateFooterLabel;
- (void)updateBarButtonsAnimated:(BOOL)animated;

/* Item management */
- (void)setupIndexedItems;

@end

@implementation TODocumentPickerTableViewController

#pragma mark - View Setup -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block TODocumentPickerTableViewController *blockSelf = self;
    
    self.indexedCollation = [UILocalizedIndexedCollation currentCollation];
    
    self.cellFolderFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    self.cellFileFont   = [UIFont systemFontOfSize:17.0f];
    
    /* Configure table */
    self.tableView = [[TODocumentPickerTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 54.0f;
    self.tableView.sectionIndexBackgroundColor = self.view.backgroundColor;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    /* Pull-to-refresh control */
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    
    /* Configure header view and components */
    self.headerView = [TODocumentPickerHeaderView new];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    [tableHeaderView addSubview:self.headerView];
    self.tableView.tableHeaderView = tableHeaderView;

    /* Handler for changing sort type */
    self.headerView.sortControl.sortTypeChangedHandler = ^{
        blockSelf.sortingType = self.headerView.sortControl.sortingType;
    };
    
    /* Toolbar files/folders count label */
    self.toolBarLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,215,44}];
    self.toolBarLabel.font = [UIFont systemFontOfSize:12.0f];
    self.toolBarLabel.textColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
    self.toolBarLabel.textAlignment = NSTextAlignmentCenter;
    self.toolBarLabel.text = NSLocalizedString(@"No files or folders found", nil);
    
    /* Toolbar button elements */
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarLabel];
    self.toolbarItems = @[self.doneButton, spaceItem, labelItem, spaceItem];
    
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectButtonTapped)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(selectButtonTapped)];
    self.navigationItem.rightBarButtonItem = self.selectButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateContent];
    [self resetHeaderConstraints];
    
    if (!self.headerBarInitiallyHidden) {
        [self resetTableViewInitialOffset];
        self.headerBarInitiallyHidden = YES;
    }
}

- (void)resetTableViewInitialOffset
{
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = -self.tableView.contentInset.top + CGRectGetHeight(self.headerView.frame);
    self.tableView.contentOffset = contentOffset;
}

- (void)resetHeaderConstraints
{
    //Extract the section index view
    UIView *indexView = nil;
    for (UIView *view in self.tableView.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"ViewIndex"].length == 0)
            continue;
        
        indexView = view;
        break;
    }
    
    NSInteger width = (NSInteger)CGRectGetWidth(indexView.frame);
    
    //TODO: Figure out how to do this in autolayout
    CGFloat newWidth = CGRectGetWidth(self.tableView.bounds) - width;
    if ((NSInteger)newWidth == (NSInteger)CGRectGetWidth(self.headerView.frame))
        return;
    
    CGRect frame = self.headerView.frame;
    frame.size.width = newWidth;
    self.headerView.frame = frame;
}

#pragma mark - Event Handling -
- (void)refreshControlTriggered
{
    if (self.refreshControlHandler)
        self.refreshControlHandler();
    else
        [self.refreshControl endRefreshing];
}

- (void)selectButtonTapped
{
    [self setEditing:!self.editing animated:YES];
    [self updateBarButtonsAnimated:YES];
}

- (void)updateBarButtonsAnimated:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:(self.editing ? self.cancelButton : self.selectButton) animated:animated];
    
    if (self.navigationController.viewControllers.count > 1)
        [self.navigationItem setHidesBackButton:self.editing animated:animated];
}

- (void)doneButtonTapped:(id)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Data Source -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexedItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.indexedItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
    }
        
    TODocumentPickerItem *item = self.indexedItems[indexPath.section][indexPath.row];
    cell.textLabel.text         = item.fileName;
    cell.detailTextLabel.text   = item.localizedMetadata;
    cell.accessoryType          = item.isFolder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.textLabel.font         = item.isFolder ? self.cellFolderFont : self.cellFileFont;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.sortingType >= TODocumentPickerSortTypeDateAscending)
        return nil;
    
    NSArray *localizedSectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    NSMutableArray *sectionTitles = [@[@"{search}"] mutableCopy];
    [sectionTitles addObjectsFromArray:localizedSectionTitles];
    return sectionTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.indexedItems[section] count] > 0)
        return [[self.indexedCollation sectionTitles] objectAtIndex:section];
    
    return nil; //return nil to hide section header views
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        return -1;
    }
        
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
}

#pragma mark - Table View Delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TODocumentPickerItem *item = self.items[indexPath.row];
    if (item.isFolder) {
        NSString *newFilePath = [self.filePath stringByAppendingPathComponent:item.fileName];
        [(TODocumentPickerViewController *)self.navigationController pushNewViewControllerForFilePath:newFilePath animated:YES];
    }

}

#pragma mark - Accessors -  
- (void)setItems:(NSArray *)items
{
    if (items == _items)
        return;
    
    _items = items;
    
    [self.refreshControl endRefreshing];
    
    [self setupIndexedItems];
    
    [self updateContent];
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    if (_sortingType == sortingType)
        return;
    
    _sortingType = sortingType;
 
    [self updateContent];
}

- (NSArray *)visibleItems
{
    return self.sortedItems;
}

#pragma mark - Update View Content -
- (void)updateContent
{
    [self.tableView reloadData];

    [self resetHeaderConstraints];
    
    [self updateFooterLabel];
}

- (void)updateFooterLabel
{
    NSInteger numberOfFolders = 0, numberOfFiles = 0;
    
    for (TODocumentPickerItem *item in self.items) {
        if (item.isFolder)
            numberOfFolders++;
        else
            numberOfFiles++;
    }
    
    //'folder' or 'folders' depending on number
    NSString *pluralFolders = (numberOfFolders == 1) ? NSLocalizedString(@"folder", nil) : NSLocalizedString(@"folders", nil);
    NSString *pluralFiles = (numberOfFiles == 1) ? NSLocalizedString(@"file", nil) : NSLocalizedString(@"files", nil);
    
    NSString *labelText = nil;
    if (numberOfFolders && numberOfFiles)
        labelText = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)numberOfFolders, pluralFolders, (long)numberOfFiles, pluralFiles];
    else if (numberOfFolders)
        labelText = [NSString stringWithFormat:@"%ld %@", (long)numberOfFolders, pluralFolders];
    else if (numberOfFiles)
        labelText = [NSString stringWithFormat:@"%ld %@", (long)numberOfFiles, pluralFiles];
    else
        labelText = NSLocalizedString(@"No files or folders found", nil);
    
    self.toolBarLabel.text = labelText;
}

#pragma mark - Items Setup -
//Referenced from the ineffible NSHipster: http://nshipster.com/uilocalizedindexedcollation/
- (void)setupIndexedItems
{
    SEL selector = @selector(fileName);
    NSInteger sectionTitlesCount = [[self.indexedCollation sectionTitles] count];
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in self.items) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    self.indexedItems = mutableSections;
}

@end
