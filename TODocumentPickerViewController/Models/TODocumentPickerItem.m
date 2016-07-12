//
//  TODocumentPickerItem.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
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

#import "TODocumentPickerItem.h"

@interface TODocumentPickerItem ()

@property (nonatomic, readonly) NSByteCountFormatter *sharedFileSizeFormatter;
@property (nonatomic, readonly) NSDateFormatter *sharedDateFormatter;
@property (nonatomic, copy, readwrite) NSString *localizedMetadata;

/* Rebuild the localized description string */
- (void)formatMetadata;

@end

@implementation TODocumentPickerItem

#pragma mark Accessors -
- (NSString *)localizedMetadata
{
    if (_localizedMetadata == nil)
        [self formatMetadata];
    
    return _localizedMetadata;
}

#pragma mark - Info formatter -
- (void)formatMetadata
{
    NSString *formattedSize = [self.sharedFileSizeFormatter stringFromByteCount:(long long)self.fileSize];
    NSString *formattedDate = [self.sharedDateFormatter stringFromDate:self.lastModifiedDate];
    
    if (!self.isFolder && self.lastModifiedDate && self.fileSize) {
        _localizedMetadata = [NSString stringWithFormat:@"%@ • %@", formattedSize, formattedDate];
    }
    else if (self.lastModifiedDate) {
        _localizedMetadata = formattedDate;
    }
    else if (self.fileSize) {
        _localizedMetadata = formattedSize;
    }
}

- (NSByteCountFormatter *)sharedFileSizeFormatter
{
    static NSByteCountFormatter *_sharedFileSizeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFileSizeFormatter = [[NSByteCountFormatter alloc] init];
        _sharedFileSizeFormatter.allowsNonnumericFormatting = NO;
    });

    return _sharedFileSizeFormatter;
}

- (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *_sharedDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter = [[NSDateFormatter alloc] init];
        _sharedDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _sharedDateFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    
    return _sharedDateFormatter;
}

#pragma mark - System Description -
- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ Size: %ld Folder: %d", self.fileName, (long)self.fileSize, self.isFolder];
}

@end
