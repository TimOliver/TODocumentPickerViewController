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
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TODocumentPickerDefines.h"

#import "TODocumentPickerTableViewController.h"
#import "TODocumentPickerTableView.h"
#import "TODocumentPickerHeaderView.h"
#import "TODocumentPickerItem.h"
#import "NSDate+Utilities.h"

//Minimum number of items required before drawing an index is required
#define MIN_INDEX_NUMBER 15

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

#define PICKER_VIEW_SIZE_SECTION_NAMES  @[NSLocalizedString(@"Unknown Size",@""), \
                                            NSLocalizedString(@"Tiny (< 10MB)",@""), \
                                            NSLocalizedString(@"Small (10MB - 50MB",@""), \
                                            NSLocalizedString(@"Medium (50MB - 150MB)",@""), \
                                            NSLocalizedString(@"Big (150MB - 1000MB)",@""), \
                                            NSLocalizedString(@"Huge (> 1000MB)",@""), \
                                            NSLocalizedString(@"Folders",@"")]

/* Sorting categories for date */
typedef NS_ENUM(NSInteger, TODocumentPickerSortingDate) {
    TODocumentPickerSortingDateUnknown,
    TODocumentPickerSortingDateToday,
    TODocumentPickerSortingDateYesterday,
    TODocumentPickerSortingDateThisWeek,
    TODocumentPickerSortingDateThisMonth,
    TODocumentPickerSortingDateLastYear,
    TODocumentPickerSortingDateLastDecade,
    TODocumentPickerSortingDateNumber   //Total for counting
};

#define PICKER_VIEW_DATE_SECTION_NAMES  @[NSLocalizedString(@"Unknown Date",@""), \
                                            NSLocalizedString(@"Today",@""), \
                                            NSLocalizedString(@"Yesterday",@""), \
                                            NSLocalizedString(@"This Week",@""), \
                                            NSLocalizedString(@"This Month",@""), \
                                            NSLocalizedString(@"Last Year",@""), \
                                            NSLocalizedString(@"Last Decade",@"")]

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
@property (nonatomic, strong) NSArray *sortedItems;     /* Single list of sorted items */
@property (nonatomic, strong) NSArray *sectionedItems;  /* Item arrays sorted into sections */
@property (nonatomic, strong) NSArray *filteredItems;   /* Items filtered via search */

/* Section Management */
@property (nonatomic, strong) NSArray *sectionTitles;   /* The names of each section in the table */

/* Currently visible sorting mode */
@property (nonatomic, assign) TODocumentPickerSortType sortingType;

/* Single use flag to align the scroll view to below the header. */
@property (nonatomic, assign) BOOL headerBarInitiallyHidden;

/* State tracking */
@property (nonatomic, readonly) BOOL sectionIndexVisible; /* Check to see if we have enough items to warrant an index. */

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
- (void)setupItems;             /* Reset the items lists and re-sorts them. */
- (void)setupSortedItems;       /* Single list of sorted items. */
- (void)setupIndexedItems;      /* Multiple sublists of indexed items. */
- (void)setupAlphabeticalIndex; /* A-Z */
- (void)setupSizeIndex;         /* File size */
- (void)setupDateIndex;         /* Time index */
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
    NSInteger width = 0;
    
    if (self.sortingType <= TODocumentPickerSortTypeNameDescending) {
        //Extract the section index view
        UIView *indexView = nil;
        for (UIView *view in self.tableView.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"ViewIndex"].length == 0)
                continue;
            
            indexView = view;
            break;
        }
        
        width = (NSInteger)CGRectGetWidth(indexView.frame);
    }
    
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
    return self.sectionedItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionedItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
    }
        
    TODocumentPickerItem *item = self.sectionedItems[indexPath.section][indexPath.row];
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
    if (self.sortingType == TODocumentPickerSortTypeNameDescending)
        localizedSectionTitles = [[localizedSectionTitles reverseObjectEnumerator] allObjects];
    
    NSMutableArray *sectionTitles = [@[@"{search}"] mutableCopy];
    [sectionTitles addObjectsFromArray:localizedSectionTitles];
    return sectionTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.sectionedItems[section] count] == 0)
        return nil;

    /* Create section titles for each different sort type */
    NSArray *sectionTitles = nil;
    if (self.sortingType <= TODocumentPickerSortTypeNameDescending) {
        sectionTitles = [self.indexedCollation sectionTitles];
        if (self.sortingType == TODocumentPickerSortTypeNameDescending)
            sectionTitles = [[sectionTitles reverseObjectEnumerator] allObjects];
    }
    else if (self.sortingType <= TODocumentPickerSortTypeSizeDescending) {
        sectionTitles = PICKER_VIEW_SIZE_SECTION_NAMES;
        if (self.sortingType == TODocumentPickerSortTypeSizeDescending)
            sectionTitles = [[sectionTitles reverseObjectEnumerator] allObjects];
    }
    
    return sectionTitles[section];
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
 
    [self setupItems];
    [self updateContent];
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
- (void)setupItems
{
    self.sortedItems = nil;
    self.sectionedItems = nil;
    
    if (self.items.count < MIN_INDEX_NUMBER)
        [self setupSortedItems];
    else
        [self setupIndexedItems];
}

- (void)setupSortedItems
{
    BOOL reverse = NO;
    NSString *sortKey = nil;
    
    //Work out which selector to use as the comparison basis and whether to reverse it
    switch (self.sortingType) {
        case TODocumentPickerSortTypeNameDescending: reverse = YES;
        case TODocumentPickerSortTypeNameAscending:  sortKey = @"fileName";
            break;
            
        case TODocumentPickerSortTypeDateDescending: reverse = YES;
        case TODocumentPickerSortTypeDateAscending:  sortKey = @"lastModifiedDate";
            break;
            
        case TODocumentPickerSortTypeSizeDescending: reverse = YES;
        case TODocumentPickerSortTypeSizeAscending:  sortKey = @"fileSize";
            break;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:!reverse];
    self.sortedItems = [self.items sortedArrayUsingDescriptors:@[sortDescriptor]];
}

//Referenced from the ineffible NSHipster: http://nshipster.com/uilocalizedindexedcollation/
- (void)setupIndexedItems
{
    switch (self.sortingType) {
        case TODocumentPickerSortTypeNameAscending:
        case TODocumentPickerSortTypeNameDescending:
            [self setupAlphabeticalIndex];
            break;
        case TODocumentPickerSortTypeDateAscending:
        case TODocumentPickerSortTypeDateDescending:
            [self setupDateIndex];
        case TODocumentPickerSortTypeSizeAscending:
        case TODocumentPickerSortTypeSizeDescending:
            [self setupSizeIndex];
        default:
            break;
    }
}

- (void)setupAlphabeticalIndex
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
    
    if (self.sortingType == TODocumentPickerSortTypeNameAscending)
        self.sectionedItems = mutableSections;
    else
        self.sectionedItems = [[mutableSections reverseObjectEnumerator] allObjects];
}

- (void)setupSizeIndex
{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:TODocumentPickerSortingSizeNumber];
    
    for (NSInteger i = 0; i < TODocumentPickerSortingSizeNumber; i++)
        [sections addObject:[NSMutableArray array]];
    
    for (TODocumentPickerItem *item in self.items) {
        if (item.isFolder)
            [sections[TODocumentPickerSortingSizeFolder] addObject:item];
        else if (item.fileSize == 0)
            [sections[TODocumentPickerSortingSizeUnknown] addObject:item];
        else if (item.fileSize < 10 * 1024)
            [sections[TODocumentPickerSortingSizeTiny] addObject:item];
        else if (item.fileSize < 50 * 1024)
            [sections[TODocumentPickerSortingSizeSmall] addObject:item];
        else if (item.fileSize < 150 * 1024)
            [sections[TODocumentPickerSortingSizeMedium] addObject:item];
        else if (item.fileSize < 1000 * 1024)
            [sections[TODocumentPickerSortingSizeBig] addObject:item];
        else
            [sections[TODocumentPickerSortingSizeHuge] addObject:item];
    }
    
    if (self.sortingType == TODocumentPickerSortTypeSizeAscending)
        self.sectionedItems = sections;
    else
        self.sectionedItems = [[sections reverseObjectEnumerator] allObjects];
}

- (void)setupDateIndex
{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:TODocumentPickerSortingSizeNumber];
    
    for (NSInteger i = 0; i < TODocumentPickerSortingDateNumber; i++)
        [sections addObject:[NSMutableArray array]];
    
    for (TODocumentPickerItem *item in self.items) {
        if (item.fileSize == 0)
            [sections[TODocumentPickerSortingSizeUnknown] addObject:item];
        else if (item.fileSize < 10 * 1024)
            [sections[TODocumentPickerSortingSizeTiny] addObject:item];
        else if (item.fileSize < 50 * 1024)
            [sections[TODocumentPickerSortingSizeSmall] addObject:item];
        else if (item.fileSize < 150 * 1024)
            [sections[TODocumentPickerSortingSizeMedium] addObject:item];
        else if (item.fileSize < 1000 * 1024)
            [sections[TODocumentPickerSortingSizeBig] addObject:item];
        else
            [sections[TODocumentPickerSortingSizeHuge] addObject:item];
    }
    
    if (self.sortingType == TODocumentPickerSortTypeSizeAscending)
        self.sectionedItems = sections;
    else
        self.sectionedItems = [[sections reverseObjectEnumerator] allObjects];
}

@end
