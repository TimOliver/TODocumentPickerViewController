//
//  TODocumentPickerConfiguration.h
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 11/07/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TODocumentPickerConstants.h"

@interface TODocumentPickerConfiguration : NSObject

/* Whether this controller shows and manages the navigation controller toolbar (Default is YES) */
@property (nonatomic, assign) BOOL showToolbar;

/* File formats that may be selected by this controller. (If nil, all files may be selected) */
@property (nonatomic, strong, nullable) NSArray *allowedFileExtensions;

/* Shows files that weren't on the allowed extensions list, but grayed out (Default is NO) */
@property (nonatomic, assign) BOOL showExcludedFileExtensions;

/* If dealing with custom formats, this lets you add custom icons for those formats (Images must be 40x40 points) */
@property (nonatomic, strong, nullable) NSDictionary *fileFormatIcons;

/* The default icon if the file format isn't recognized, or other icons aren't available. */
@property (nonatomic, strong, nullable) UIImage *defaultIcon;

/* The icon used for folder entries. */
@property (nonatomic, strong, nullable) UIImage *folderIcon;

/* A dictionary of file extension strings to images to use as icons for each file format. */
@property (nonatomic, strong, nullable) NSDictionary *fileIcons;

/* If desired, a custom table view cell class that can contain additional controls or formatting. */
@property (nonatomic, assign, nullable) Class tableViewCellClass;

/* Attributes for applying a new colour scheme to this view controller. */
@property (nonatomic, strong, nullable) NSDictionary *themeAttributes;

@end
