//
//  TODocumentPickerSegmentedControl.m
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
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TODocumentPickerSegmentedControl.h"

#define ARROW_WIDTH 7
#define ARROW_HEIGHT 4

typedef NS_ENUM(NSInteger, TODocumentPickerSegmentedControlImage) {
    TODocumentPickerSegmentedControlImageDefault=0,
    TODocumentPickerSegmentedControlImageDescending=1,
    TODocumentPickerSegmentedControlImageAscending=2
};

@interface TODocumentPickerSegmentedControl ()

@property (nonatomic, readonly) NSArray *segmentedControlImages;

- (void)segmentedControlTapped:(id)sender;
- (void)updateItemsForCurrentSortType;

/* Generates an 'off', 'descending' and 'ascending' images of the supplied text */
+ (NSArray *)TO_documentPickerSegmentedControlItemsForTitle:(NSString *)title;
+ (void)drawArrowAtPoint:(CGPoint)point ascending:(BOOL)ascending;

@end

@implementation TODocumentPickerSegmentedControl

#pragma mark - Class Creation -

- (instancetype)init
{
    NSArray *items = @[self.segmentedControlImages[0][0], self.segmentedControlImages[1][0], self.segmentedControlImages[2][0]];
    
    if (self = [super initWithItems:items]) {
        [self addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.selectedSegmentIndex = 0;
    [self updateItemsForCurrentSortType];
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
    for (NSInteger i = 0; i < self.segmentedControlImages.count; i++)
        [self setImage:[self.segmentedControlImages[i] firstObject] forSegmentAtIndex:i];
    
    switch (self.sortingType) {
        case TODocumentPickerSortTypeNameAscending:  [self setImage:self.segmentedControlImages[0][TODocumentPickerSegmentedControlImageAscending] forSegmentAtIndex:0]; break;
        case TODocumentPickerSortTypeNameDescending: [self setImage:self.segmentedControlImages[0][TODocumentPickerSegmentedControlImageDescending] forSegmentAtIndex:0]; break;
        case TODocumentPickerSortTypeSizeAscending:  [self setImage:self.segmentedControlImages[1][TODocumentPickerSegmentedControlImageAscending] forSegmentAtIndex:1]; break;
        case TODocumentPickerSortTypeSizeDescending: [self setImage:self.segmentedControlImages[1][TODocumentPickerSegmentedControlImageDescending] forSegmentAtIndex:1]; break;
        case TODocumentPickerSortTypeDateAscending:  [self setImage:self.segmentedControlImages[2][TODocumentPickerSegmentedControlImageAscending] forSegmentAtIndex:2]; break;
        case TODocumentPickerSortTypeDateDescending: [self setImage:self.segmentedControlImages[2][TODocumentPickerSegmentedControlImageDescending] forSegmentAtIndex:2]; break;
    }
}

#pragma mark - Accessors -
- (NSArray *)segmentedControlImages
{
    static NSArray *_segmentedControlImages;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *segmentedControlImages = [NSMutableArray array];
        [segmentedControlImages addObject:[TODocumentPickerSegmentedControl TO_documentPickerSegmentedControlItemsForTitle:NSLocalizedString(@"Name", @"Segmented Control Name")]];
        [segmentedControlImages addObject:[TODocumentPickerSegmentedControl TO_documentPickerSegmentedControlItemsForTitle:NSLocalizedString(@"Size", @"Segmented Control Size")]];
        [segmentedControlImages addObject:[TODocumentPickerSegmentedControl TO_documentPickerSegmentedControlItemsForTitle:NSLocalizedString(@"Date", @"Segmented Control Date")]];
        _segmentedControlImages = [NSArray arrayWithArray:segmentedControlImages];
    });
    
    return _segmentedControlImages;
}

#pragma mark - Segmented Control Image generation -

//Annoyingly, [drawInRect:withAttributes] has no easy 'center' option. Sticking to the old way for now
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

+ (NSArray *)TO_documentPickerSegmentedControlItemsForTitle:(NSString *)title
{
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    NSMutableArray *images = [NSMutableArray array];
    
    //Work out the size of all of the images
    CGSize imageSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    imageSize.width += (ARROW_WIDTH + 3) * 2; //Add enough padding on either side so the content is still center
    
    CGRect frame = (CGRect){CGPointZero, imageSize};
    
    for (NSInteger i = 0; i <= 2; i++) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
        {
            //draw the text
            [[UIColor blackColor] set];
            [title drawInRect:frame withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
            //depending on the iteration, draw the arrow
            if (i > 0) {
                CGPoint arrowPoint = CGPointZero;
                arrowPoint.x = CGRectGetMaxX(frame) - ARROW_WIDTH;
                arrowPoint.y = ceil((CGRectGetHeight(frame) - ARROW_HEIGHT) * 0.5f);
                
                [TODocumentPickerSegmentedControl drawArrowAtPoint:arrowPoint ascending:(i==2)];
            }
            
            [images addObject:UIGraphicsGetImageFromCurrentImageContext()];
        }
        UIGraphicsEndImageContext();
    }
    
    return images;
}

#pragma GCC diagnostic pop

+ (void)drawArrowAtPoint:(CGPoint)point ascending:(BOOL)ascending
{
    CGRect frame = {(CGPoint)point, {ARROW_WIDTH,ARROW_HEIGHT}};
    
    UIBezierPath* arrowPath = UIBezierPath.bezierPath;
    if (!ascending) {
        [arrowPath moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMinY(frame))];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 4)];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
    }
    else {
        [arrowPath moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMaxY(frame))];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame))];
        [arrowPath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
    }
    
    [arrowPath closePath];
    [[UIColor blackColor] setFill];
    [arrowPath fill];
}

@end
