//
//  UIImage+TODocumentPickerIcons.h
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

#import <UIKit/UIKit.h>
#import "TODocumentPickerConstants.h"

@interface UIImage (TODocumentPickerIcons)

+ (UIImage *)TO_downloadIcon;

+ (UIImage *)TO_documentPickerDefaultFolderForStyle:(TODocumentPickerViewControllerStyle)style;

+ (UIImage *)TO_documentPickerFolderIconWithSize:(CGSize)size
                                 backgroundColor:(UIColor *)backgroundColor
                           foregroundBottomColor:(UIColor *)foregroundBottomColor
                              foregroundTopColor:(UIColor *)foregroundTopColor;

+ (UIImage *)TO_documentPickerDefaultFileIconWithExtension:(NSString *)extension
                                                 tintColor:(UIColor *)tintColor
                                                  style:(TODocumentPickerViewControllerStyle)style;

+ (UIImage *)TO_documentPickerIconWithSize:(CGSize)size
                                     outlineColor:(UIColor *)outlineColor
                                  backgroundColor:(UIColor *)backgroundColor
                                      cornerColor:(UIColor *)cornerColor
                                 formatNameString:(NSString *)formatNameString
                                   formatNameFont:(UIFont *)formatNameFont
                                  formatNameColor:(UIColor *)formatNameColor;

@end
