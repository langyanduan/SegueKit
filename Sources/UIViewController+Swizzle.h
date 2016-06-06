//
//  UIViewController+Swizzle.h
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Swizzle)
/**
 * You should never call this method directly.
 *
 * @note This function swizzle the 'prepareForSegue:sender:' of current class if needed.
 */
- (void)swz_swizzleSegueIfNeeded;
@end
