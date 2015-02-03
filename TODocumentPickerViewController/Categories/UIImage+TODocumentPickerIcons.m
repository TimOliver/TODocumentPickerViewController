//
//  UIImage+TODocumentPickerIcons.m
//  TODocumentPickerViewControllerExample
//
//  Created by Tim Oliver on 2/3/15.
//  Copyright (c) 2015 Tim Oliver. All rights reserved.
//

#import "UIImage+TODocumentPickerIcons.h"

@implementation UIImage (TODocumentPickerIcons)

+ (UIImage *)TO_documentPickerFolderIcon
{
    UIImage *folderIcon = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){33,27}, NO, 0.0f);
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
        [rectanglePath moveToPoint: CGPointMake(0.5, 23.61)];
        [rectanglePath addCurveToPoint: CGPointMake(3.41, 26.5) controlPoint1: CGPointMake(0.5, 25.21) controlPoint2: CGPointMake(1.8, 26.5)];
        [rectanglePath addLineToPoint: CGPointMake(29.59, 26.5)];
        [rectanglePath addCurveToPoint: CGPointMake(32.5, 23.61) controlPoint1: CGPointMake(31.2, 26.5) controlPoint2: CGPointMake(32.5, 25.21)];
        [rectanglePath addLineToPoint: CGPointMake(32.5, 6.39)];
        [rectanglePath addCurveToPoint: CGPointMake(29.59, 3.5) controlPoint1: CGPointMake(32.5, 4.79) controlPoint2: CGPointMake(31.2, 3.5)];
        [rectanglePath addCurveToPoint: CGPointMake(15.5, 3.5) controlPoint1: CGPointMake(29.59, 3.5) controlPoint2: CGPointMake(17.5, 3.5)];
        [rectanglePath addCurveToPoint: CGPointMake(10.5, 0.5) controlPoint1: CGPointMake(13.5, 3.5) controlPoint2: CGPointMake(12.5, 0.5)];
        [rectanglePath addCurveToPoint: CGPointMake(3.41, 0.5) controlPoint1: CGPointMake(8.5, 0.5) controlPoint2: CGPointMake(3.41, 0.5)];
        [rectanglePath addCurveToPoint: CGPointMake(0.5, 3.39) controlPoint1: CGPointMake(1.8, 0.5) controlPoint2: CGPointMake(0.5, 1.79)];
        [rectanglePath addLineToPoint: CGPointMake(0.5, 23.61)];
        [rectanglePath closePath];
        [UIColor.blackColor setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = UIBezierPath.bezierPath;
        [rectangle2Path moveToPoint: CGPointMake(32.5, 10.5)];
        [rectangle2Path addCurveToPoint: CGPointMake(29.5, 7.5) controlPoint1: CGPointMake(32.5, 8.84) controlPoint2: CGPointMake(31.16, 7.5)];
        [rectangle2Path addLineToPoint: CGPointMake(3.5, 7.5)];
        [rectangle2Path addCurveToPoint: CGPointMake(0.5, 10.5) controlPoint1: CGPointMake(1.84, 7.5) controlPoint2: CGPointMake(0.5, 8.84)];
        [UIColor.blackColor setStroke];
        rectangle2Path.lineWidth = 1;
        [rectangle2Path stroke];
        
        folderIcon = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return folderIcon;
}

+ (UIImage *)TO_documentPickerDefaultIcon
{
    UIImage *documentIcon = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){33,37}, NO, 0.0f);
    {
        //// Group
        {
            //// Page Drawing
            UIBezierPath* pagePath = UIBezierPath.bezierPath;
            [pagePath moveToPoint: CGPointMake(5.5, 33.5)];
            [pagePath addLineToPoint: CGPointMake(28.5, 33.5)];
            [pagePath addLineToPoint: CGPointMake(28.5, 11.41)];
            [pagePath addLineToPoint: CGPointMake(19.3, 2.5)];
            [pagePath addLineToPoint: CGPointMake(5.5, 2.5)];
            [pagePath addLineToPoint: CGPointMake(5.5, 33.5)];
            [pagePath closePath];
            [UIColor.blackColor setStroke];
            pagePath.lineWidth = 1;
            [pagePath stroke];
            
            
            //// Fold Drawing
            UIBezierPath* foldPath = UIBezierPath.bezierPath;
            [foldPath moveToPoint: CGPointMake(19.5, 2.5)];
            [foldPath addLineToPoint: CGPointMake(19.5, 11.5)];
            [foldPath addLineToPoint: CGPointMake(28.5, 11.5)];
            [UIColor.blackColor setStroke];
            foldPath.lineWidth = 1;
            [foldPath stroke];
        }

        
        documentIcon = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return documentIcon;
}

@end
