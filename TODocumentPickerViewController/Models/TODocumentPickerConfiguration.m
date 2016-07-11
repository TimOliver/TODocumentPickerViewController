//
//  TODocumentPickerConfiguration.m
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 11/07/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TODocumentPickerConfiguration.h"
#import "UIImage+TODocumentPickerIcons.h"

@implementation TODocumentPickerConfiguration

- (instancetype)init
{
    if (self = [super init]) {
        _showToolbar = YES;
    }

    return self;
}

- (UIImage *)defaultIcon
{
    if (_defaultIcon == nil) {
        _defaultIcon = [UIImage TO_documentPickerDefaultIcon];
    }

    return _defaultIcon;
}

- (UIImage *)folderIcon
{
    if (_folderIcon == nil) {
        _folderIcon = [UIImage TO_documentPickerFolderIcon];
    }

    return _folderIcon;
}

@end
