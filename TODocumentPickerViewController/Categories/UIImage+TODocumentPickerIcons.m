//
//  UIImage+TODocumentPickerIcons.m
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

#import "UIImage+TODocumentPickerIcons.h"

@implementation UIImage (TODocumentPickerIcons)

+ (UIImage *)TO_downloadIcon
{
    UIImage *downloadIcon = nil;
    UIGraphicsBeginImageContextWithOptions((CGSize){24,23}, NO, 0.0f);
    {
        //// Color Declarations
        UIColor* downloadColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
        //// cloud Drawing
        UIBezierPath* cloudPath = [UIBezierPath bezierPath];
        [cloudPath moveToPoint: CGPointMake(9, 15)];
        [cloudPath addLineToPoint: CGPointMake(4.97, 15)];
        [cloudPath addCurveToPoint: CGPointMake(1.02, 11.04) controlPoint1: CGPointMake(2.78, 15) controlPoint2: CGPointMake(1.02, 13.25)];
        [cloudPath addCurveToPoint: CGPointMake(3.96, 6.99) controlPoint1: CGPointMake(1.02, 9.1) controlPoint2: CGPointMake(1.76, 7.08)];
        [cloudPath addCurveToPoint: CGPointMake(3.69, 5.96) controlPoint1: CGPointMake(3.83, 6.66) controlPoint2: CGPointMake(3.69, 6.34)];
        [cloudPath addCurveToPoint: CGPointMake(5.28, 3.57) controlPoint1: CGPointMake(3.69, 4.85) controlPoint2: CGPointMake(4.4, 4.09)];
        [cloudPath addCurveToPoint: CGPointMake(7.15, 3.09) controlPoint1: CGPointMake(5.74, 3.3) controlPoint2: CGPointMake(6.61, 3.09)];
        [cloudPath addCurveToPoint: CGPointMake(8.63, 3.92) controlPoint1: CGPointMake(7.95, 3.09) controlPoint2: CGPointMake(8.09, 3.4)];
        [cloudPath addCurveToPoint: CGPointMake(9.86, 2.4) controlPoint1: CGPointMake(8.76, 3.41) controlPoint2: CGPointMake(9.45, 2.8)];
        [cloudPath addCurveToPoint: CGPointMake(13.88, 1.04) controlPoint1: CGPointMake(10.77, 1.5) controlPoint2: CGPointMake(12.23, 1.04)];
        [cloudPath addCurveToPoint: CGPointMake(19.09, 4.54) controlPoint1: CGPointMake(16.62, 1.04) controlPoint2: CGPointMake(18.72, 2.54)];
        [cloudPath addCurveToPoint: CGPointMake(18.99, 6.25) controlPoint1: CGPointMake(19.19, 5.09) controlPoint2: CGPointMake(19.29, 5.79)];
        [cloudPath addCurveToPoint: CGPointMake(22.95, 10.49) controlPoint1: CGPointMake(22.18, 5.98) controlPoint2: CGPointMake(22.95, 8.01)];
        [cloudPath addCurveToPoint: CGPointMake(18.33, 15) controlPoint1: CGPointMake(22.95, 12.98) controlPoint2: CGPointMake(20.79, 15)];
        [cloudPath addLineToPoint: CGPointMake(15, 15)];
        [downloadColor setStroke];
        cloudPath.lineWidth = 2;
        cloudPath.lineJoinStyle = kCGLineJoinRound;
        [cloudPath stroke];
        
        
        //// arrow Drawing
        UIBezierPath* arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint: CGPointMake(12.93, 8.61)];
        [arrowPath addCurveToPoint: CGPointMake(13, 9.51) controlPoint1: CGPointMake(13, 8.85) controlPoint2: CGPointMake(13, 9.07)];
        [arrowPath addLineToPoint: CGPointMake(13, 17.94)];
        [arrowPath addCurveToPoint: CGPointMake(13, 19.22) controlPoint1: CGPointMake(13, 18.49) controlPoint2: CGPointMake(13, 18.91)];
        [arrowPath addCurveToPoint: CGPointMake(14.5, 17.72) controlPoint1: CGPointMake(13.59, 18.63) controlPoint2: CGPointMake(14.22, 18)];
        [arrowPath addCurveToPoint: CGPointMake(14.66, 17.56) controlPoint1: CGPointMake(14.57, 17.65) controlPoint2: CGPointMake(14.61, 17.61)];
        [arrowPath addCurveToPoint: CGPointMake(15.21, 17.12) controlPoint1: CGPointMake(14.88, 17.34) controlPoint2: CGPointMake(15.02, 17.22)];
        [arrowPath addCurveToPoint: CGPointMake(16.26, 17.31) controlPoint1: CGPointMake(15.56, 16.96) controlPoint2: CGPointMake(15.98, 17.03)];
        [arrowPath addCurveToPoint: CGPointMake(16.51, 18.43) controlPoint1: CGPointMake(16.61, 17.66) controlPoint2: CGPointMake(16.68, 18.08)];
        [arrowPath addCurveToPoint: CGPointMake(15.92, 19.13) controlPoint1: CGPointMake(16.4, 18.65) controlPoint2: CGPointMake(16.24, 18.81)];
        [arrowPath addLineToPoint: CGPointMake(13.12, 21.93)];
        [arrowPath addLineToPoint: CGPointMake(12.43, 22.51)];
        [arrowPath addCurveToPoint: CGPointMake(12, 22.6) controlPoint1: CGPointMake(12.29, 22.58) controlPoint2: CGPointMake(12.15, 22.61)];
        [arrowPath addCurveToPoint: CGPointMake(11.57, 22.51) controlPoint1: CGPointMake(11.85, 22.61) controlPoint2: CGPointMake(11.71, 22.58)];
        [arrowPath addLineToPoint: CGPointMake(10.88, 21.93)];
        [arrowPath addLineToPoint: CGPointMake(8.08, 19.13)];
        [arrowPath addCurveToPoint: CGPointMake(7.51, 18.46) controlPoint1: CGPointMake(7.76, 18.81) controlPoint2: CGPointMake(7.6, 18.65)];
        [arrowPath addCurveToPoint: CGPointMake(7.67, 17.38) controlPoint1: CGPointMake(7.32, 18.08) controlPoint2: CGPointMake(7.39, 17.66)];
        [arrowPath addCurveToPoint: CGPointMake(8.79, 17.12) controlPoint1: CGPointMake(8.02, 17.03) controlPoint2: CGPointMake(8.44, 16.96)];
        [arrowPath addCurveToPoint: CGPointMake(9.34, 17.56) controlPoint1: CGPointMake(8.98, 17.22) controlPoint2: CGPointMake(9.12, 17.34)];
        [arrowPath addLineToPoint: CGPointMake(9.42, 17.64)];
        [arrowPath addCurveToPoint: CGPointMake(11, 19.22) controlPoint1: CGPointMake(9.77, 18) controlPoint2: CGPointMake(10.41, 18.63)];
        [arrowPath addCurveToPoint: CGPointMake(11, 17.94) controlPoint1: CGPointMake(11, 18.78) controlPoint2: CGPointMake(11, 17.94)];
        [arrowPath addCurveToPoint: CGPointMake(11.07, 8.65) controlPoint1: CGPointMake(11, 9.07) controlPoint2: CGPointMake(11, 8.85)];
        [arrowPath addCurveToPoint: CGPointMake(11.95, 8) controlPoint1: CGPointMake(11.21, 8.24) controlPoint2: CGPointMake(11.56, 8)];
        [arrowPath addLineToPoint: CGPointMake(12.05, 8)];
        [arrowPath addCurveToPoint: CGPointMake(12.93, 8.61) controlPoint1: CGPointMake(12.44, 8) controlPoint2: CGPointMake(12.79, 8.24)];
        [arrowPath closePath];
        [downloadColor setFill];
        [arrowPath fill];
        
        downloadIcon = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [downloadIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)TO_documentPickerDefaultFolderForStyle:(TODocumentPickerViewControllerStyle)style
{
    BOOL darkMode = (style == TODocumentPickerViewControllerStyleDark);
    UIColor *backgroundColor, *frontBottomColor, *frontTopColor;
    
    if (darkMode) {
        
    }
    else {
        backgroundColor = [UIColor colorWithRed: 0.553 green: 0.855 blue: 1 alpha: 1];
        frontTopColor = [UIColor colorWithRed: 0.396 green: 0.761 blue: 0.937 alpha: 1];
        frontBottomColor = [UIColor colorWithRed: 0.525 green: 0.835 blue: 0.988 alpha: 1];
    }
    
    return [UIImage TO_documentPickerFolderIconWithSize:kTODocumentPickerDefaultFolderIconSize
                                        backgroundColor:backgroundColor
                                  foregroundBottomColor:frontBottomColor
                                     foregroundTopColor:frontTopColor];
}

+ (UIImage *)TO_documentPickerDefaultFileIconWithExtension:(NSString *)extension
                                                 tintColor:(UIColor *)tintColor
                                                     style:(TODocumentPickerViewControllerStyle)style
{
    BOOL darkMode = (style == TODocumentPickerViewControllerStyleDark);
    UIColor *outlineColor, *backgroundColor, *cornerColor, *formatNameColor;
    
    if (darkMode) {
        
    }
    else {
        outlineColor = [UIColor colorWithRed: 0.851 green: 0.851 blue: 0.851 alpha: 1];
        backgroundColor = [UIColor colorWithRed: 0.976 green: 0.976 blue: 0.976 alpha: 1];
        cornerColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        formatNameColor = [UIColor colorWithRed: 0.039 green: 0.376 blue: 1 alpha: 1];
    }
    
    return [UIImage TO_documentPickerIconWithSize:kTODocumentPickerDefaultFileIconSize
                                     outlineColor:outlineColor
                                  backgroundColor:backgroundColor
                                      cornerColor:cornerColor
                                 formatNameString:extension
                                   formatNameFont:[UIFont boldSystemFontOfSize:15.0f]
                                  formatNameColor:tintColor];
}

+ (UIImage *)TO_documentPickerFolderIconWithSize:(CGSize)size
                                 backgroundColor:(UIColor *)backgroundColor
                           foregroundBottomColor:(UIColor *)foregroundBottomColor
                              foregroundTopColor:(UIColor *)foregroundTopColor
{
    UIImage *folderIconImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    {
        CGRect frame = (CGRect){CGPointZero, size};
        
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Gradient Declarations
        CGFloat folderGradientLocations[] = {0, 1};
        CGGradientRef folderGradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)@[(id)foregroundTopColor.CGColor, (id)foregroundBottomColor.CGColor], folderGradientLocations);
        
        //// Subframes
        CGRect folderIcon = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), frame.size.width, frame.size.height);
        
        
        //// FolderIcon
        {
            //// Back Drawing
            UIBezierPath* backPath = [UIBezierPath bezierPath];
            [backPath moveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.24116 * folderIcon.size.height)];
            [backPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.08210 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00279 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.03568 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.05831 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.04641 * folderIcon.size.height)];
            [backPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00319 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.03361 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.02687 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00352 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.00719 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.01962 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.01586 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00861 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.06505 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00003 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.03695 * folderIcon.size.width, CGRectGetMinY(folderIcon) + -0.00053 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.04632 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00003 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.25266 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00003 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.06505 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00003 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.19495 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.00032 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.34042 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.06351 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.31037 * folderIcon.size.width, CGRectGetMinY(folderIcon) + -0.00027 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.31178 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.02441 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.42140 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10866 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.36906 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10261 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.38329 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10891 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.93445 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10813 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.45950 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10842 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.93445 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10813 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.97181 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.11193 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.95318 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10813 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.96336 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.10839 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.99631 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.14227 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.98281 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.11701 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.99230 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.12828 * folderIcon.size.height)];
            [backPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19140 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.99950 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.15507 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.16761 * folderIcon.size.height)];
            [backPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.24116 * folderIcon.size.height)];
            [backPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.24116 * folderIcon.size.height)];
            [backPath closePath];
            [backgroundColor setFill];
            [backPath fill];
            
            
            //// Front Drawing
            UIBezierPath* frontPath = [UIBezierPath bezierPath];
            [frontPath moveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.06505 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.93495 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.97149 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19275 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.95368 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.96305 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.97313 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19326 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.99681 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.22334 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.98414 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19835 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.99281 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.20936 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.27184 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.23615 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.24805 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.91737 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.99721 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.96379 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.94116 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 1.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.95306 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.99681 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.96587 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.97313 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.99595 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.99281 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.97985 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.98414 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.99086 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.93495 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.96305 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.95368 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.06505 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.02851 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.99646 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.04632 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.03695 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 1.00000 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.02687 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.99595 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00319 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.96587 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.01586 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.99086 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.00719 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.97985 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.91737 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + -0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.95306 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.94116 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.27184 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00279 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.22542 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.24805 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.00000 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.23615 * folderIcon.size.height)];
            [frontPath addLineToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.00319 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.22334 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.02687 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19326 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.00719 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.20936 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.01586 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.19835 * folderIcon.size.height)];
            [frontPath addCurveToPoint: CGPointMake(CGRectGetMinX(folderIcon) + 0.06505 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(folderIcon) + 0.03695 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(folderIcon) + 0.04632 * folderIcon.size.width, CGRectGetMinY(folderIcon) + 0.18921 * folderIcon.size.height)];
            [frontPath closePath];
            CGContextSaveGState(context);
            [frontPath addClip];
            CGRect frontBounds = CGPathGetPathBoundingBox(frontPath.CGPath);
            CGContextDrawLinearGradient(context, folderGradient,
                                        CGPointMake(CGRectGetMidX(frontBounds), CGRectGetMinY(frontBounds)),
                                        CGPointMake(CGRectGetMidX(frontBounds), CGRectGetMaxY(frontBounds)),
                                        kNilOptions);
            CGContextRestoreGState(context);
        }
        
        //// Cleanup
        CGGradientRelease(folderGradient);
        
        folderIconImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [folderIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)TO_documentPickerIconWithSize:(CGSize)size
                              outlineColor:(UIColor *)fileOutline
                           backgroundColor:(UIColor *)backgroundFillColor
                               cornerColor:(UIColor *)topFillColor
                          formatNameString:(NSString *)formatNameString
                            formatNameFont:(UIFont *)formatNameFont
                           formatNameColor:(UIColor *)textColor
{
    UIImage *fileIconImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    {
        CGRect frame = (CGRect){CGPointZero, size};
        
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Subframes
        CGRect fileIcon = CGRectMake(CGRectGetMinX(frame) + 0.51, CGRectGetMinY(frame) + 0.48, frame.size.width - 1, frame.size.height - 0.99);
        
    
        //// FileIcon
        {
            //// Paper Drawing
            UIBezierPath* paperPath = [UIBezierPath bezierPath];
            [paperPath moveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.08491 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00012 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.59433 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00007 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.08491 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00012 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.52969 * fileIcon.size.width, CGRectGetMinY(fileIcon) + -0.00011 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.71279 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.04586 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.65897 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00026 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.67141 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.01482 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.95429 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.22727 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.75417 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.07689 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.92837 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.20860 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.99992 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.30366 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.98020 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.24594 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.99971 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.25673 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.99986 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.93631 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 1.00013 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.35059 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.99986 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.93631 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.99596 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.97289 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.99986 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.95465 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.99960 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.96462 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.96478 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.99688 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.99073 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.98367 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.97915 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.99296 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.91495 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.95162 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.93940 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height)];
            [paperPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.08491 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.03721 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.99727 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.06046 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.04824 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 1.00000 * fileIcon.size.height)];
            [paperPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.03508 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.99688 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.00416 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.97369 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.02071 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.99296 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.00939 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.98447 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.93631 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.96382 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.95465 * fileIcon.size.height)];
            [paperPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.06380 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.00364 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.02803 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.04546 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.00000 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.03630 * fileIcon.size.height)];
            [paperPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.00416 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.02642 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.03508 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00324 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.00939 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.01565 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.02071 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00716 * fileIcon.size.height)];
            [paperPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.08491 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00012 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.04824 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00012 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.06046 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.00012 * fileIcon.size.height)];
            [paperPath closePath];
            [backgroundFillColor setFill];
            [paperPath fill];
            [fileOutline setStroke];
            paperPath.lineWidth = 1;
            [paperPath stroke];
            
            
            //// Flap Drawing
            UIBezierPath* flapPath = [UIBezierPath bezierPath];
            [flapPath moveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.96857 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.25069 * fileIcon.size.height)];
            [flapPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.75163 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.25102 * fileIcon.size.height)];
            [flapPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.70286 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.24810 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.72718 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.25102 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.71389 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.25083 * fileIcon.size.height)];
            [flapPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.67088 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.22471 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.68849 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.24418 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.67611 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.23549 * fileIcon.size.height)];
            [flapPath addCurveToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.66671 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.18734 * fileIcon.size.height) controlPoint1: CGPointMake(CGRectGetMinX(fileIcon) + 0.66671 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.21484 * fileIcon.size.height) controlPoint2: CGPointMake(CGRectGetMinX(fileIcon) + 0.66671 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.20567 * fileIcon.size.height)];
            [flapPath addLineToPoint: CGPointMake(CGRectGetMinX(fileIcon) + 0.66671 * fileIcon.size.width, CGRectGetMinY(fileIcon) + 0.02638 * fileIcon.size.height)];
            [topFillColor setFill];
            [flapPath fill];
            [fileOutline setStroke];
            flapPath.lineWidth = 1;
            flapPath.lineCapStyle = kCGLineCapRound;
            flapPath.lineJoinStyle = kCGLineJoinRound;
            [flapPath stroke];
            
            
            //// Text Drawing
            if (formatNameString.length > 0) {
                CGRect textRect = CGRectMake(CGRectGetMinX(fileIcon) + floor(fileIcon.size.width * 0.02469 - 0.39) + 0.89, CGRectGetMinY(fileIcon) + floor(fileIcon.size.height * 0.30244 - 0.02) + 0.52, floor(fileIcon.size.width * 0.98190 + 0.15) - floor(fileIcon.size.width * 0.02469 - 0.39) - 0.54, floor(fileIcon.size.height * 0.69823 - 0.02) - floor(fileIcon.size.height * 0.30244 - 0.02));
                
                NSString* textContent = formatNameString;
                NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle alloc] init];
                textStyle.alignment = NSTextAlignmentCenter;
                NSDictionary* textFontAttributes = @{NSFontAttributeName: formatNameFont, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: textStyle};
                
                CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
                CGContextSaveGState(context);
                CGContextClipToRect(context, textRect);
                [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (textRect.size.height - textTextHeight) / 2, textRect.size.width, textTextHeight) withAttributes: textFontAttributes];
                CGContextRestoreGState(context);
            }
        }
        
        fileIconImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [fileIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
