//
//  UIViewController+Swizzle.m
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

#import <objc/message.h>
#import "UIViewController+Swizzle.h"

@implementation UIViewController (Swizzle)

+ (void)swz_swizzleSegueIfNeeded {
    assert([NSThread isMainThread]);
    
    static const void *kSwizzledFlag = &kSwizzledFlag;
    if (objc_getAssociatedObject(self, kSwizzledFlag) == nil) {
        objc_setAssociatedObject(self, kSwizzledFlag, @(true), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        SEL originalSelector = @selector(prepareForSegue:sender:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        const char *typeEncoding = method_getTypeEncoding(originalMethod);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL aopSelector = @selector(aop_prepareFor:sender:and:);   // import from swift
#pragma clang diagnostic pop
        void (*aopCall)(id, SEL, UIStoryboardSegue *, id, Class) = (__typeof(aopCall))objc_msgSend;
        
        Class currentClass = self;
        
        if (class_getInstanceMethod(self, originalSelector) != class_getInstanceMethod(class_getSuperclass(self), originalSelector)) {
            // if current implement prepareForSegue, just swizzle it.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            SEL swizzledSelector = @selector(swz_prepareForSegue:sender:);
#pragma clang diagnostic pop
            
            IMP imp = imp_implementationWithBlock(^(id object, UIStoryboardSegue *segue, id sender) {
                assert([object isKindOfClass:[UIViewController class]]);
                aopCall(object, aopSelector, segue, sender, currentClass);
                
                // objc_msgSend 可能会将消息转发到子类的实现中, 这里用 method_invoke 直接将消息发到当前类
                void (*selfCall)(id, Method, UIStoryboardSegue *, id) = (__typeof(selfCall))method_invoke;
                Method swizzledMethod = class_getInstanceMethod(currentClass, swizzledSelector);
                selfCall(object, swizzledMethod, segue, sender);
            });
            class_addMethod(self, swizzledSelector, imp, typeEncoding);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            // if current class has not implement prepareForSegue, add one.
            IMP imp = imp_implementationWithBlock(^(id object, UIStoryboardSegue *segue, id sender) {
                assert([object isKindOfClass:[UIViewController class]] && ![object isMemberOfClass:[UIViewController class]]);
                aopCall(object, aopSelector, segue, sender, currentClass);
                
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

- (void)swz_swizzleSegueIfNeeded {
    [[self class] swz_swizzleSegueIfNeeded];
}

@end
