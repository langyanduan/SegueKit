//
//  UIViewController+SegueSwizzle.m
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

#import <objc/message.h>
#import "UIViewController+SegueSwizzle.h"
//#import "SegueKit-Swift.h"

@implementation UIViewController (SegueSwizzle)

+ (void)swz_swizzleIfNeeded {
    assert([NSThread isMainThread]);
    
    static const void *kSwizzledFlag = &kSwizzledFlag;
    if (objc_getAssociatedObject(self, kSwizzledFlag) == nil) {
        objc_setAssociatedObject(self, kSwizzledFlag, @(true), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        SEL originalSelector = @selector(prepareForSegue:sender:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        const char *typeEncoding = method_getTypeEncoding(originalMethod);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL aopSelector = @selector(aop_prepareFor:and:);   // import from swift
#pragma clang diagnostic pop
        void (*aopCall)(id, SEL, UIStoryboardSegue *, Class) = (__typeof(aopCall))objc_msgSend;
        
        Class currentClass = self;
        
        if (class_getInstanceMethod(self, originalSelector) != class_getInstanceMethod(class_getSuperclass(self), originalSelector)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            SEL swizzledSelector = @selector(swz_prepareForSegue:sender:);
#pragma clang diagnostic pop
            
            IMP imp = imp_implementationWithBlock(^(id object, UIStoryboardSegue *segue, id sender) {
                assert([object isKindOfClass:[UIViewController class]]);
                aopCall(object, aopSelector, segue, currentClass);
                
                void (*selfCall)(id, SEL, UIStoryboardSegue *, id) = (__typeof(selfCall))objc_msgSend;
                selfCall(object, swizzledSelector, segue, sender);
            });
            class_addMethod(self, swizzledSelector, imp, typeEncoding);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            IMP imp = imp_implementationWithBlock(^(id object, UIStoryboardSegue *segue, id sender) {
                assert([object isKindOfClass:[UIViewController class]] && ![object isMemberOfClass:[UIViewController class]]);
                aopCall(object, aopSelector, segue, currentClass);
                
                void (*superCall)(struct objc_super *, SEL, UIStoryboardSegue *, id) = (__typeof(superCall))objc_msgSendSuper;
                struct objc_super superInfo = {
                    .receiver = object,
                    .super_class = class_getSuperclass(currentClass)
                };
                superCall(&superInfo, originalSelector, segue, sender);
            });
            class_addMethod(self, originalSelector, imp, typeEncoding);
        }
    }
}

- (void)swz_swizzleIfNeeded {
    [[self class] swz_swizzleIfNeeded];
}

@end
