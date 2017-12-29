//
//  TODocumentPickerTableViewController.m
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
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TODocumentPickerViewController.h"
#import "TODocumentPickerTableView.h"
#import "TODocumentPickerHeaderView.h"
#import "TODocumentPickerItemManager.h"
#import "TODocumentPickerItem.h"
#import "TODocumentPickerConfiguration.h"

@interface TODocumentPickerViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

/* Root Controller Management */
@property (nonatomic, strong, readwrite) TODocumentPickerViewController *rootViewController;

/* The file path that this controller represents */
@property (nonatomic, readwrite, copy, nullable) NSString *filePath;

/* The configuration object holding all common properties */
@property (nonatomic, readwrite, strong, nonnull)  TODocumentPickerConfiguration *configuration;

/* View management */
@property (nonatomic, strong) TODocumentPickerHeaderView *headerView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *feedbackLabel;
@property (nonatomic, strong) UILabel *toolBarLabel;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *selectAllButton;
@property (nonatomic, strong) UIBarButtonItem *chooseButton;

/* Edit mode toggle */
@property (nonatomic, strong) UIBarButtonItem *selectButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

/* Edit mode toolbar items */
@property (nonatomic, strong) NSArray *nonEditingToolbarItems;
@property (nonatomic, strong) NSArray *editingToolbarItems;

/* Cell label fonts */
@property (nonatomic, strong) UIFont *cellFolderFont;
@property (nonatomic, strong) UIFont *cellFileFont;

/* Item Manager */
@property (nonatomic, strong) TODocumentPickerItemManager *itemManager;

/* Currently visible sorting mode */
@property (nonatomic, assign) TODocumentPickerSortType sortingType;

/* Single use flag to check for the first time we appear onscreen */
@property (nonatomic, assign) BOOL viewInitiallyAppeared;

/* Single flag to determine that we've started laying out views */
@property (nonatomic, assign) BOOL viewInitiallyLaidOut;

/* State tracking */
@property (nonatomic, readonly) BOOL sectionIndexVisible; /* Check to see if we have enough items to warrant an index. */
@property (nonatomic, readonly) BOOL allCellsSelected;

/* Serial queue for posting updates to the items property asynchronously. */
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation TODocumentPickerViewController

#pragma mark - View Setup -
- (instancetype)initWithFilePath:(NSString *)filePath
{
    return [self initWithConfiguration:[[TODocumentPickerConfiguration alloc] init] filePath:filePath];
}

- (instancetype)initWithConfiguration:(TODocumentPickerConfiguration *)configuration filePath:(NSString *)filePath
{
    if (self = [super init]) {
        [self commonInit];
        _configuration = configuration;
        _filePath = filePath ? filePath : @"/";
        _rootViewController = self;
    }

    return self;
}

- (instancetype)initWithRootViewController:(TODocumentPickerViewController *)rootController filePath:(NSString *)filePath
{
    if (self = [super init]) {
        [self commonInit];
        _configuration = rootController.configuration;
        _filePath = filePath ? filePath : @"/";
        _rootViewController = rootController;
    }

    return self;
}

- (void)commonInit
{
    _cellFolderFont = [UIFont systemFontOfSize:17.0f];
    _cellFileFont   = [UIFont systemFontOfSize:17.0f];
    _itemManager = [[TODocumentPickerItemManager alloc] init];
    _serialQueue = dispatch_queue_create("TODocumentPickerViewController.itemBuilderQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)dealloc
{
    /* Cancel any in-progress requests */
    if ([self.dataSource respondsToSelector:@selector(documentPickerViewController:cancelRequestForFilePath:)]) {
        [self.dataSource documentPickerViewController:self cancelRequestForFilePath:self.filePath];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectZero;
    __weak typeof(self)weakSelf = self;
    
    /* Configure table */
    self.tableView = [[TODocumentPickerTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64.0f;
    self.tableView.sectionIndexBackgroundColor = self.view.backgroundColor;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    /* Table item manager setup */
    self.itemManager.tableView = self.tableView;
    self.itemManager.contentReloadedHandler = ^{ [weakSelf updateViewContent]; };
    
    /* Configure header view and components */
    self.headerView = [TODocumentPickerHeaderView new];
    self.headerView.searchTextChangedHandler = ^(NSString *searchText) {
        weakSelf.itemManager.searchString = searchText;
        [weakSelf showFeedbackLabelIfNeeded];
    };
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    [tableHeaderView addSubview:self.headerView];
    self.tableView.tableHeaderView = tableHeaderView;

    /* Handler for changing sort type */
    self.headerView.sortControl.sortTypeChangedHandler = ^{
        weakSelf.sortingType = self.headerView.sortControl.sortingType;
    };
    
    /* Create the incidental loading indicator. */
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    frame = self.loadingView.frame;
    frame.origin.x = (CGRectGetWidth(self.tableView.bounds) - CGRectGetWidth(frame)) * 0.5f;
    frame.origin.y = CGRectGetHeight(self.headerView.frame) + ((self.tableView.rowHeight - CGRectGetHeight(frame)) * 0.5f) + self.tableView.rowHeight;
    self.loadingView.frame = frame;
    [self.tableView addSubview:self.loadingView];
    [self.loadingView startAnimating];

    /* Set-up the Edit/Cancel buttons */
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectButtonTapped)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(selectButtonTapped)];
    self.navigationItem.rightBarButtonItem = self.selectButton;

    /* Set-up Select All button */
    self.selectAllButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select All", @"") style:UIBarButtonItemStylePlain target:self action:@selector(selectAllButtonTapped)];

    /* Set-up the toolbar */
    [self configureToolbar];
}

- (void)configureToolbar
{
    // If another controller is controlling the toolbar, defer to them
    if (self.configuration.showToolbar == NO) {
        self.toolBarLabel = nil;
        self.doneButton = nil;
        self.chooseButton = nil;

        return;
    }

    // Unhide the navigation controller's toolbar
    if (self.navigationController.toolbarHidden) {
        self.navigationController.toolbarHidden = NO;
    }

    /* Toolbar files/folders count label */
    if (self.toolBarLabel == nil) {
        self.toolBarLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,215,44}];
        self.toolBarLabel.font = [UIFont systemFontOfSize:12.0f];
        self.toolBarLabel.textColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
        self.toolBarLabel.textAlignment = NSTextAlignmentCenter;
        self.toolBarLabel.text = NSLocalizedString(@"Loading...", nil);
    }

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarLabel];

    /* Toolbar button elements */
    if (self.nonEditingToolbarItems == nil) {
        if (self.doneButton == nil) {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(doneButtonTapped)];
        }

        self.nonEditingToolbarItems = @[self.doneButton, spaceItem, labelItem, spaceItem, spaceItem];
    }

    /* Set up editing buttons */
    if (self.editingToolbarItems == nil) {
        if (self.chooseButton == nil) {
            self.chooseButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Choose", @"")
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(chooseButtonTapped)];
        }

        UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
        actionItem.enabled = NO;

        self.editingToolbarItems = @[actionItem, spaceItem, labelItem, spaceItem, self.chooseButton];
    }

    [self updateToolbarItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    /* Absolutely make sure this view controller is being presented via navigation controller */
    if (self.navigationController == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"TODocumentPickerViewController MUST be presented under a UINavigationController"];
    }

    /* Fire this off only on the initial appearence of the controller */
    if (!self.viewInitiallyAppeared) {
        /* So start querying for items at this point, and not sooner */
        [self reloadItemsFromDataSource];

        /* Set the title when applicable */
        if ([self.dataSource respondsToSelector:@selector(documentPickerViewController:titleForFilePath:)]) {
            self.title = [self.dataSource documentPickerViewController:self titleForFilePath:self.filePath];
        }
        else {
            self.title = (self.filePath.length > 0 ? self.filePath.lastPathComponent : @"/");
        }

        self.viewInitiallyAppeared = YES;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    /* Scroll the table downwards so the header view is initially hidden. */
    if (self.viewInitiallyLaidOut == NO) {
        [self resetTableViewInitialOffset];
        self.viewInitiallyLaidOut = YES;
    }
}

- (void)resetAfterInitialItemLoad
{
    /* After the initial content has loaded, add the pull-to-refresh controler */
    if (self.refreshControl == nil) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    }

    /* Stop the refresh control */
    [self.refreshControl endRefreshing];

    /* Delete the activity indicator since we won't need it again */
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
}

- (void)resetTableViewInitialOffset
{
    CGPoint contentOffset = self.tableView.contentOffset;
    if (@available(iOS 11.0, *)) {
        contentOffset.y = -self.tableView.adjustedContentInset.top + CGRectGetHeight(self.headerView.frame);
    }
    else {
        contentOffset.y = -self.tableView.contentInset.top + CGRectGetHeight(self.headerView.frame);
    }
    self.tableView.contentOffset = contentOffset;
}

- (void)resetHeaderConstraints
{
    NSInteger width = 0;

    /* Work out the width of the section index view */
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

    CGFloat newWidth = CGRectGetWidth(self.tableView.bounds) - width;
    if ((NSInteger)newWidth == (NSInteger)CGRectGetWidth(self.headerView.frame))
        return;
    
    CGRect frame = self.headerView.frame;
    frame.size.width = newWidth;
    self.headerView.frame = frame;
}

- (void)setupFeedbackLabel
{
    if (self.feedbackLabel != nil)
        return;
    
    self.feedbackLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,20,44}];
    self.feedbackLabel.font = [UIFont systemFontOfSize:14.0f];
    self.feedbackLabel.textAlignment = NSTextAlignmentCenter;
    self.feedbackLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
}

#pragma mark - Content Request Handling -
- (void)reloadItemsFromDataSource
{
    if (self.dataSource == nil) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    id completionHandler = ^(NSArray<TODocumentPickerItem *> *items) {
        [weakSelf setItems:items];
    };

    [self.dataSource documentPickerViewController:self requestItemsForFilePath:self.filePath completionHandler:completionHandler];
}

- (void)setItems:(NSArray<TODocumentPickerItem *> *)items forFilePath:(NSString *)filePath
{
    NSArray *controllers = self.navigationController.viewControllers;
    NSInteger index = [controllers indexOfObject:self.rootViewController];
    if (index == NSNotFound) {
        return;
    }

    // If file path is nil, assume the root controller
    if (filePath.length == 0) {
        self.rootViewController.items = items;
        return;
    }

    //Starting from the root controller, loop through each controller up the chain to find the one we need to update
    while (index < controllers.count) {
        id controller = controllers[index++];
        if ([controller isKindOfClass:[TODocumentPickerViewController class]] == NO) {
            continue;
        }

        TODocumentPickerViewController *documentPickerController = (TODocumentPickerViewController *)controller;
        if (documentPickerController.filePath.length == 0) {
            continue; // The root controller has already been done at this point
        }

        if ([documentPickerController.filePath caseInsensitiveCompare:filePath] == NSOrderedSame) {
            documentPickerController.items = items;
            return;
        }
    }
}

#pragma mark - Event Handling -
- (void)refreshControlTriggered
{
    if (self.dataSource) {
        [self reloadItemsFromDataSource];
        return;
    }

    [self.refreshControl endRefreshing];
}

- (void)selectButtonTapped
{
    [self setEditing:!self.editing animated:YES];
    [self updateBarButtonsAnimated:YES];
}

- (void)updateBarButtonsAnimated:(BOOL)animated
{
    //Swap the 'Select/Cancel' buttons
    [self.navigationItem setRightBarButtonItem:(self.editing ? self.cancelButton : self.selectButton) animated:animated];

    //Hide 'back' if it was visible
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationItem setHidesBackButton:self.editing animated:animated];
    }

    //Add the 'Select All' button in place of the 'Back' button
    [self.navigationItem setLeftBarButtonItems:self.editing ? @[self.selectAllButton] : nil animated:animated];
}

- (void)selectAllButtonTapped
{
    if (self.editing == NO)
        return;

    // Work out if we're selecting, or deselecting all items
    BOOL selected = (self.allCellsSelected == NO);

    // Go through and apply the selection to every item
    for (NSInteger i = 0; i < [self.tableView numberOfSections]; i++) {
        for (NSInteger j = 0; j < [self.tableView numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            if (selected)
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            else
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }

    // Update the Select button text
    self.selectAllButton.title = self.allCellsSelected ? NSLocalizedString(@"Select None", @"") : NSLocalizedString(@"Select All", @"");

    // Update the toolbar state
    [self updateToolbarItems];
}

- (void)doneButtonTapped
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseButtonTapped
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *selectedIndexPaths = self.tableView.indexPathsForSelectedRows;

    for (NSIndexPath *indexPath in selectedIndexPaths) {
        TODocumentPickerItem *item = [self.itemManager itemForIndexPath:indexPath];
        [items addObject:item];
    }

    // Make immutable
    items = (NSMutableArray *)[NSArray arrayWithArray:items];

    if ([self.documentPickerDelegate respondsToSelector:@selector(documentPickerViewController:didSelectItems:inFilePath:)]) {
        [self.documentPickerDelegate documentPickerViewController:self didSelectItems:items inFilePath:self.filePath];
    }
}

#pragma mark - Table View Data Source -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemManager.numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class tableViewCellClass = self.configuration.tableViewCellClass;
        if (tableViewCellClass == nil) {
            tableViewCellClass = [UITableViewCell class];
        }
        
        cell = [[tableViewCellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
    }

    // Configure the cell with the item
    TODocumentPickerItem *item = [self.itemManager itemForIndexPath:indexPath];
    cell.textLabel.text         = item.fileName;
    cell.detailTextLabel.text   = item.localizedMetadata;
    cell.accessoryType          = item.isFolder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.textLabel.font         = item.isFolder ? self.cellFolderFont : self.cellFileFont;
    cell.imageView.image        = item.isFolder ? self.configuration.folderIcon : self.configuration.defaultIcon;

    // Give the data source a chance to perform additional configuration
    if ([self.dataSource respondsToSelector:@selector(documentPickerViewController:configureCell:withItem:)]) {
        [self.dataSource documentPickerViewController:self configureCell:cell withItem:item];
    }

    return cell;
}

#pragma mark - Table View Delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If editing, update the UI state, but otherwise let the table do its thing
    if (self.editing) {
        [self updateToolbarItems];
        return;
    }

    // Play the deselection animation
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Get the item we tapped
    TODocumentPickerItem *item = [self.itemManager itemForIndexPath:indexPath];

    // If the item is not a folder, inform the delegate
    if (!item.isFolder) {
        if ([self.documentPickerDelegate respondsToSelector:@selector(documentPickerViewController:didSelectItems:inFilePath:)]) {
            [self.documentPickerDelegate documentPickerViewController:self didSelectItems:@[item] inFilePath:self.filePath];
        }
        return;
    }

    // If we selected a folder spawn a new document picker and push it to the navigation controller
    NSString *newFilePath = [self.filePath stringByAppendingPathComponent:item.fileName];
    if (newFilePath == nil) {
        newFilePath = [@"/" stringByAppendingPathComponent:item.fileName];
    }

    TODocumentPickerViewController *newController = [[TODocumentPickerViewController alloc] initWithRootViewController:self.rootViewController filePath:newFilePath];
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        [self updateToolbarItems];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Dismiss the keyboard if it's visible
    [self.headerView dismissKeyboard];

    //Update the header clipping, so it's not visible under translucent bars
    if (@available(iOS 11.0, *)) {
        self.headerView.clippingHeight = scrollView.adjustedContentInset.top + scrollView.contentOffset.y;
    }
    else {
        self.headerView.clippingHeight = scrollView.contentInset.top + scrollView.contentOffset.y;
    }
}

#pragma mark - Update View Content -
- (void)updateViewContent
{
    [self resetHeaderConstraints];
    [self updateToolbarItems];

    self.selectButton.enabled = (self.items.count > 0);
}

- (void)showFeedbackLabelIfNeeded
{
    self.feedbackLabel.hidden = YES;

    //Cancel if searching AND resulting rows is greater than one
    if (self.itemManager.searchString.length > 0 && self.itemManager.numberOfItems > 0)
        return;

    //Cnacel if not searching and items are present
    if (self.itemManager.searchString.length == 0 && self.items.count > 0)
        return;

    if (self.feedbackLabel == nil) {
        self.feedbackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.feedbackLabel.font = [UIFont systemFontOfSize:16.0f];
        self.feedbackLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        self.feedbackLabel.textAlignment = NSTextAlignmentCenter;
        [self.tableView addSubview:self.feedbackLabel];
    }

    self.feedbackLabel.hidden = NO;

    if (self.headerView.searchBar.text.length > 0)
        self.feedbackLabel.text = NSLocalizedString(@"No Results Found", @"");
    else
        self.feedbackLabel.text = NSLocalizedString(@"Folder is Empty", @"");

    [self.feedbackLabel sizeToFit];

    CGRect frame = self.feedbackLabel.frame;
    frame.origin.x = (CGRectGetWidth(self.tableView.bounds) - CGRectGetWidth(frame)) * 0.5f;
    frame.origin.y = CGRectGetHeight(self.headerView.frame) + ((self.tableView.rowHeight - CGRectGetHeight(frame)) * 0.5f) + self.tableView.rowHeight;
    self.feedbackLabel.frame = frame;
}

- (void)updateFooterLabel
{
    // If editing, show the number of selected items in the tool bar
    if (self.editing) {
        NSInteger numberOfSelectedItems = self.tableView.indexPathsForSelectedRows.count;
        NSString *labelText = nil;

        if (numberOfSelectedItems == 1) {
            labelText = [NSString stringWithFormat:NSLocalizedString(@"%ld item selected", @""), numberOfSelectedItems];
        }
        else {
            labelText = [NSString stringWithFormat:NSLocalizedString(@"%ld items selected", @""), numberOfSelectedItems];
        }

        self.toolBarLabel.text = labelText;

        return;
    }

    // If not editing, print the number of folders/files
    NSInteger numberOfFolders = 0, numberOfFiles = 0;
    for (TODocumentPickerItem *item in self.items) {
        if (item.isFolder)
            numberOfFolders++;
        else
            numberOfFiles++;
    }

    // 'folder' or 'folders' depending on number
    NSString *pluralFolders = (numberOfFolders == 1) ? NSLocalizedString(@"folder", nil) : NSLocalizedString(@"folders", nil);
    NSString *pluralFiles = (numberOfFiles == 1) ? NSLocalizedString(@"file", nil) : NSLocalizedString(@"files", nil);

    NSString *labelText = nil;
    if (numberOfFolders && numberOfFiles)
        labelText = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)numberOfFolders, pluralFolders, (long)numberOfFiles, pluralFiles];
    else if (numberOfFolders)
        labelText = [NSString stringWithFormat:@"%ld %@", (long)numberOfFolders, pluralFolders];
    else if (numberOfFiles)
        labelText = [NSString stringWithFormat:@"%ld %@", (long)numberOfFiles, pluralFiles];
    else {
        if (self.loadingView && self.loadingView.hidden == NO)
            labelText = NSLocalizedString(@"Loading...", nil);
        else
            labelText = NSLocalizedString(@"No files or folders found", nil);
    }

    self.toolBarLabel.text = labelText;
}

- (void)updateToolbarItems
{
    if (self.configuration.showToolbar == NO) {
        return;
    }

    // Update footer label text
    [self updateFooterLabel];

    // Set the toolbar items depending on state
    if (self.editing == NO && self.toolbarItems != self.nonEditingToolbarItems) {
        [self setToolbarItems:self.nonEditingToolbarItems animated:YES];
    }
    else if (self.editing && self.toolbarItems != self.editingToolbarItems) {
        [self setToolbarItems:self.editingToolbarItems animated:YES];
    }

    // Update the choose button only if we're editing
    if (self.editing == NO) {
        return;
    }

    self.chooseButton.enabled = ([self.tableView indexPathsForSelectedRows].count > 0);
}

#pragma mark - Accessors -
- (void)setItems:(NSArray *)items
{
    if (items == self.itemManager.items)
        return;
    
    //if the items are actually 0, reset the views now,
    //but still set the value via the serial queue to ensure no collisions
    if (items.count == 0) {
        [self resetAfterInitialItemLoad];
        [self showFeedbackLabelIfNeeded];
    }
    
    // perform sorting on a separate queue to ensure no hiccups in the refresh UI
    dispatch_async(self.serialQueue, ^{
        self.itemManager.items = items;
        
        //Force the end refresh animation to happen on another iteration of the run loop
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetAfterInitialItemLoad];
        });
    });
}

- (NSArray *)items
{
    return self.itemManager.items;
}

- (void)setSortingType:(TODocumentPickerSortType)sortingType
{
    self.itemManager.sortingType = sortingType;
}

- (TODocumentPickerSortType)sortingType
{
    return self.itemManager.sortingType;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self updateViewContent];
}

- (BOOL)allCellsSelected
{
    return [self.tableView indexPathsForSelectedRows].count == self.itemManager.numberOfItems;
}

- (id<TODocumentPickerViewControllerDataSource>)dataSource
{
    if (_dataSource == nil) {
        return self.rootViewController.dataSource;
    }

    return _dataSource;
}

- (id<TODocumentPickerViewControllerDelegate>)documentPickerDelegate
{
    if (_documentPickerDelegate == nil && self != self.rootViewController) {
        return self.rootViewController.documentPickerDelegate;
    }

    return _documentPickerDelegate;
}

@end
