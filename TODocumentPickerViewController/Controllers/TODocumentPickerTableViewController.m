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

/* View management */
@property (nonatomic, strong) TODocumentPickerHeaderView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *toolBarLabel;
@property (nonatomic, strong) UIBarButtonItem *selectButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

/* Cell label fonts */
@property (nonatomic, strong) UIFont *cellFolderFont;
@property (nonatomic, strong) UIFont *cellFileFont;

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
    
    self.cellFolderFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    self.cellFileFont   = [UIFont systemFontOfSize:17.0f];
    
    /* Configure table */
    self.tableView.rowHeight = 54.0f;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    /* Pull-to-refresh control */
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    
    /* Configure header view and components */
    /* Place the header view in a container view to allow navigation bar pinning */
    self.headerView = [TODocumentPickerHeaderView new];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableHeaderView = tableHeaderView;
    self.headerView.frame = tableHeaderView.bounds;
    [self.view addSubview:self.headerView];
    
    /* Toolbar files/folders count label */
    self.toolBarLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,215,44}];
    self.toolBarLabel.font = [UIFont systemFontOfSize:12.0f];
    self.toolBarLabel.textColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
    self.toolBarLabel.textAlignment = NSTextAlignmentCenter;
    self.toolBarLabel.text = NSLocalizedString(@"No files or folders found", nil);
    
    /* Toolbar button elements */
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectButtonTapped)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarLabel];
    self.toolbarItems = @[self.selectButton, spaceItem, labelItem, spaceItem];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
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
    if (self.editing) {
        self.selectButton.title = NSLocalizedString(@"Cancel", nil);
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
    else {
        self.selectButton.title = NSLocalizedString(@"Select", nil);
        [self.navigationItem setRightBarButtonItem:self.doneButton animated:animated];
    }
    
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

#pragma mark - Scroll View Handling - 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.headerView.frame;
    CGFloat halfHeight = CGRectGetHeight(frame) * 0.5f;
    
    CGFloat offset = 0.0f;
    if (self.navigationController.navigationBar.translucent)
        offset = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    frame.origin.y = MAX(0, scrollView.contentOffset.y + (offset - halfHeight));
    
    self.headerView.frame = frame;
    [self.view bringSubviewToFront:self.headerView];
    
    [self.headerView setNavigationBarHidden:(frame.origin.y <= 0.0f + FLT_EPSILON) animated:YES];
    [self.headerView dismissKeyboard];
}

@end
