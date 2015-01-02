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

#define DOWN_ARROW  @"▾"
#define UP_ARROW    @"▴"

@interface TODocumentPickerSegmentedControl ()

+ (NSArray *)items;
- (void)segmentedControlTapped:(id)sender;

@end

@implementation TODocumentPickerSegmentedControl

+ (NSArray *)items
{
    return @[NSLocalizedString(@"Name ▾", nil),
             NSLocalizedString(@"Size", nil),
             NSLocalizedString(@"Date", nil)];
}

- (instancetype)init
{
    if (self = [super initWithItems:[TODocumentPickerSegmentedControl items]]) {
        [self addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

#pragma mark - Action Events -
- (void)segmentedControlTapped:(id)sender
{
    NSLog(@"Tapped");
}

// Allows the control to detect taps on top of the already-selected segment.
// Solution by Andy Drizen / Bob de Graf - http://stackoverflow.com/a/21654606/599344
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventAllTouchEvents];
    [super touchesEnded:touches withEvent:event];
}

@end
