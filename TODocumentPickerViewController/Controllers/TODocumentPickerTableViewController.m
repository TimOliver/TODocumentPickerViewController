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

@property (nonatomic, strong) TODocumentPickerHeaderView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;

- (void)refreshControlTriggered;

@end

@implementation TODocumentPickerTableViewController

#pragma mark - View Setup -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    
    self.headerView = [TODocumentPickerHeaderView new];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableHeaderView = tableHeaderView;
    
    self.headerView.frame = tableHeaderView.bounds;
    [tableHeaderView addSubview:self.headerView];
    
}

#pragma mark - Event Handling -
- (void)refreshControlTriggered
{
    if (self.refreshControlHandler)
        self.refreshControlHandler();
    else
        [self.refreshControl endRefreshing];
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
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    TODocumentPickerItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.fileName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)item.fileSize];
    
    return cell;
}

#pragma mark - Table View Delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Accessors -
- (void)setItems:(NSArray *)items
{
    if (items == _items)
        return;
    
    _items = items;
    [self.tableView reloadData];
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
    [self.view bringSubviewToFront:self.tableView.tableHeaderView];
    
    [self.headerView setNavigationBarHidden:(frame.origin.y <= 0.0f + FLT_EPSILON) animated:YES];
}

@end
