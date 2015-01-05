//
//  TODocumentPickerSegmentedControl.m
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
#import "TODocumentPickerSegmentedControl.h"

#define DOWN_ARROW  @"▼"
#define UP_ARROW    @"▲"

@interface TODocumentPickerSegmentedControl ()

@property (nonatomic, strong) NSArray *items;

- (void)segmentedControlTapped:(id)sender;
- (void)updateItemsForCurrentSortType;

@end

@implementation TODocumentPickerSegmentedControl

#pragma mark - Class Creation -

- (instancetype)init
{
    _items = @[NSLocalizedString(@"Name", nil), NSLocalizedString(@"Size", nil), NSLocalizedString(@"Date", nil)];
    
    if (self = [super initWithItems:_items]) {
        [self addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

#pragma mark - Interaction Detection -

//Detects when the same segment is tapped twice
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger oldValue = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    
    if (oldValue == self.selectedSegmentIndex) {
        switch (oldValue) {
            case 0:
                if (self.sortingType == TODocumentPickerSortTypeNameAscending) {
                    self.sortingType = TODocumentPickerSortTypeNameDescending;
                }
                else {
                    self.sortingType = TODocumentPickerSortTypeNameAscending;
                }
                break;
            case 1:
                if (self.sortingType == TODocumentPickerSortTypeSizeAscending) {
                    self.sortingType = TODocumentPickerSortTypeSizeDescending;
                }
                else {
                    self.sortingType = TODocumentPickerSortTypeSizeAscending;
                }
                break;
            case 2:
                if (self.sortingType == TODocumentPickerSortTypeDateAscending) {
                    self.sortingType = TODocumentPickerSortTypeDateDescending;
                }
                else {
                    self.sortingType = TODocumentPickerSortTypeDateAscending;
                }
                break;
        }
        
        [self updateItemsForCurrentSortType];
        
        if (self.sortTypeChangedHandler)
            self.sortTypeChangedHandler();
    }
}

- (void)segmentedControlTapped:(id)sender
{
    switch (self.selectedSegmentIndex) {
        case 0: //Name
            self.sortingType = TODocumentPickerSortTypeNameAscending;
            break;
        case 1: //Size
            self.sortingType = TODocumentPickerSortTypeSizeAscending;
            break;
        case 2: //Date
            self.sortingType = TODocumentPickerSortTypeDateAscending;
            break;
    }
    
    [self updateItemsForCurrentSortType];
    
    if (self.sortTypeChangedHandler)
        self.sortTypeChangedHandler();
}

#pragma mark - Update Items -
- (void)updateItemsForCurrentSortType
{
    //Reset all of the items
    for (NSInteger i = 0; i < self.items.count; i++)
        [self setTitle:self.items[i] forSegmentAtIndex:i];
    
    switch (self.sortingType) {
        case TODocumentPickerSortTypeNameAscending:  [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[0], UP_ARROW] forSegmentAtIndex:0]; break;
        case TODocumentPickerSortTypeNameDescending: [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[0], DOWN_ARROW] forSegmentAtIndex:0]; break;
        case TODocumentPickerSortTypeSizeAscending:  [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[1], UP_ARROW] forSegmentAtIndex:1]; break;
        case TODocumentPickerSortTypeSizeDescending: [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[1], DOWN_ARROW] forSegmentAtIndex:1]; break;
        case TODocumentPickerSortTypeDateAscending:  [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[2], UP_ARROW] forSegmentAtIndex:2]; break;
        case TODocumentPickerSortTypeDateDescending: [self setTitle:[NSString stringWithFormat:@"%@ %@", self.items[2], DOWN_ARROW] forSegmentAtIndex:2]; break;
    }
}

@end
