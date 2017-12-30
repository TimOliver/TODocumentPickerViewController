//
//  TODocumentPickerTableViewCell.m
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

#import "TODocumentPickerTableViewCell.h"

static const CGFloat kTODocumentPickerTableViewCellImagePadding = 15.0f;

@interface TODocumentPickerTableViewCell ()

@property (nonatomic, assign) CGFloat textFontHeight;
@property (nonatomic, assign) CGFloat detailTextFontHeight;

@end

@implementation TODocumentPickerTableViewCell

@synthesize imageView = __imageView;
@synthesize textLabel = __textLabel;
@synthesize detailTextLabel = __detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    __textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    __textLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightRegular];
    __textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:__textLabel];
    
    __detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    __detailTextLabel.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    __detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:__detailTextLabel];

    __imageView = [[UIImageView alloc] initWithImage:nil];
    __imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:__imageView];
    
    _textFontHeight = __textLabel.font.ascender - __textLabel.font.descender;
    _detailTextFontHeight = __detailTextLabel.font.ascender - __detailTextLabel.font.descender;
}

- (void)configureCellForStyle:(TODocumentPickerViewControllerStyle)style
{
    BOOL darkMode = (style == TODocumentPickerViewControllerStyleDark);
    
    self.textLabel.textColor = darkMode ? [UIColor whiteColor] : [UIColor blackColor];
    self.detailTextLabel.textColor = darkMode ? [UIColor colorWithWhite:0.6f alpha:1.0f] : [UIColor colorWithWhite:0.5f alpha:1.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentFrame = CGRectZero;
    contentFrame.origin.x = self.layoutMargins.left;
    contentFrame.origin.y = self.layoutMargins.top;
    contentFrame.size.width = CGRectGetWidth(self.contentView.frame) - (self.layoutMargins.left + self.layoutMargins.right);
    contentFrame.size.height = CGRectGetHeight(self.contentView.frame) - (self.layoutMargins.top + self.layoutMargins.bottom);
    
    CGRect frame = CGRectZero;
    frame.origin.x = contentFrame.origin.x;
    frame.origin.y = contentFrame.origin.y;
    frame.size.height = contentFrame.size.height;
    frame.size.width = contentFrame.size.height;
    self.imageView.frame = CGRectIntegral(frame);
    
    CGFloat midY = CGRectGetMidY(contentFrame);
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + kTODocumentPickerTableViewCellImagePadding;
    frame.origin.y = ceilf(midY - self.textFontHeight);
    frame.size.width = contentFrame.size.width - frame.origin.x;
    frame.size.height = self.textFontHeight;
    self.textLabel.frame = CGRectIntegral(frame);
    
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + kTODocumentPickerTableViewCellImagePadding;
    frame.origin.y = ceilf(midY);
    frame.size.width = contentFrame.size.width - frame.origin.x;
    frame.size.height = self.detailTextFontHeight;
    self.detailTextLabel.frame = CGRectIntegral(frame);
}

@end
