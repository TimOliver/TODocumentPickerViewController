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
#import "TODocumentPickerHeaderView.h"

@interface TODocumentPickerTableViewController () <UISearchBarDelegate>

/* Localized item collation management */
@property (nonatomic, strong) UILocalizedIndexedCollation *indexedCollation;

/* View management */
@property (nonatomic, strong) TODocumentPickerHeaderView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;
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
@property (nonatomic, strong) NSArray *filteredItems;   /* Items filtered via search */

/* Visible comics (Will be a subarray for names) */
@property (nonatomic, readonly) NSArray *visibleItems;

@property (nonatomic, assign) TODocumentPickerSortType sortingType;

/* Ensure that the header bar content isn't obscured by the table view section index. */
- (void)setupHeaderConstraints;

/* Called when the user swipes down to refresh. */
- (void)refreshControlTriggered;
- (void)selectButtonTapped;
- (void)doneButtonTapped:(id)sender;

- (void)updateFooterLabel;

- (void)updateBarButtonsAnimated:(BOOL)animated;

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
    self.tableView.rowHeight = 54.0f;
    self.tableView.sectionIndexBackgroundColor = self.view.backgroundColor;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    /* Pull-to-refresh control */
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    
    /* Configure header view and components */
    /* Place the header view in a container view to allow navigation bar pinning */
    self.headerView = [TODocumentPickerHeaderView new];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = tableHeaderView;
    self.headerView.frame = tableHeaderView.bounds;
    [tableHeaderView addSubview:self.headerView];
    
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
    
    //Slightly redundant, but must be called here to ensure the table view has finished setting itself up beforehand
    [self setupHeaderConstraints];
}

- (void)setupHeaderConstraints
{
    //Skip if we've already added constraints
    if (self.headerView.superview.constraints.count > 0)
        return;
    
    //Extract the section index view
    UIView *indexView = nil;
    for (UIView *view in self.tableView.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"ViewIndex"].length == 0)
            continue;
        
        indexView = view;
        break;
    }
    
    if (indexView == nil)
        return;
    
    UIView *parentView = self.headerView.superview;
    NSInteger width = (NSInteger)CGRectGetWidth(indexView.frame);
    
    NSString *constraint = [NSString stringWithFormat:@"H:|[headerView]-%ld-|", (long)width];
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:@{@"headerView":self.headerView}]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
    }
        
    TODocumentPickerItem *item = self.items[indexPath.row];
    cell.textLabel.text         = item.fileName;
    cell.detailTextLabel.text   = item.localizedMetadata;
    cell.accessoryType          = item.isFolder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.textLabel.font         = item.isFolder ? self.cellFolderFont : self.cellFileFont;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *localizedSectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    NSMutableArray *sectionTitles = [@[@"{search}"] mutableCopy];
    [sectionTitles addObjectsFromArray:localizedSectionTitles];
    return sectionTitles;
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
    [self.tableView reloadData];
    
    [self updateFooterLabel];
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    if (_sortingType == sortingType)
        return;
    
    _sortingType = sortingType;
    
    // Change the section index color to appear 'disabled'z
    UIColor *disabledColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.tableView.sectionIndexColor = (_sortingType > TODocumentPickerSortTypeNameDescending) ? disabledColor : nil;
        
    [self.tableView reloadData];
}

- (NSArray *)visibleItems
{
    
    
    return self.sortedItems;
}

#pragma mark - Footer Label -
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

@end
