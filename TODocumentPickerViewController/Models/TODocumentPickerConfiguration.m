//
//  TODocumentPickerConfiguration.m
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

#import "TODocumentPickerConstants.h"

#import "TODocumentPickerConfiguration.h"
#import "TODocumentPickerTheme.h"
#import "UIImage+TODocumentPickerIcons.h"

@interface TODocumentPickerConfiguration ()

@property (nonatomic, strong, readwrite) TODocumentPickerTheme *theme;

@end

@implementation TODocumentPickerConfiguration

- (instancetype)init
{
    if (self = [super init]) {
        _showToolbar = YES;
        _theme = [[TODocumentPickerTheme alloc] init];
    }

    return self;
}

- (UIImage *)defaultIcon
{
    if (_defaultIcon == nil) {
        _defaultIcon = [UIImage TO_documentPickerDefaultFileIconWithExtension:nil
                                                                    tintColor:nil
                                                                        style:self.style];
    }

    return _defaultIcon;
}

- (UIImage *)folderIcon
{
    if (_folderIcon == nil) {
        _folderIcon = [UIImage TO_documentPickerDefaultFolderForStyle:self.style];
    }

    return _folderIcon;
}

- (void)setStyle:(TODocumentPickerViewControllerStyle)style
{
    if (style == _style) { return; }
    _style = style;
    
    _defaultIcon = nil;
    _defaultIcon = nil;
}

@end
