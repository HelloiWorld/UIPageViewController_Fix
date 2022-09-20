//
//  UIPageViewController+Fix.m
//
//
//  Created by pengzk on 2022/9/20.
//

#import "UIPageViewController+Fix.h"
#import <objc/runtime.h>

@implementation UIPageViewController (Fix)

+ (void)fix {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method dstMethod = class_getInstanceMethod([UIPageViewController class], NSSelectorFromString(@"_setViewControllers:withCurlOfType:fromLocation:direction:animated:notifyDelegate:completion:"));
        Method srcMethod = class_getInstanceMethod(self, @selector(fix_setViewControllers:withCurlOfType:fromLocation:direction:animated:notifyDelegate:completion:));
        method_exchangeImplementations(dstMethod, srcMethod);
    });
}

- (void)fix_setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers
                  withCurlOfType:(UIPageViewControllerTransitionStyle)type
                    fromLocation:(CGPoint)location
                       direction:(UIPageViewControllerNavigationDirection)direction
                        animated:(BOOL)animated
                  notifyDelegate:(BOOL)notifyDelegate
                      completion:(void (^ __nullable)(BOOL finished))completion {
    if (!viewControllers.count) return;
    // FIEME: 根据animated判断，true的时候如果viewControllers数量不是2也是有问题的，false的时候数量为1
    
    [self fix_setViewControllers:viewControllers withCurlOfType:type fromLocation:location direction:direction animated:animated notifyDelegate:notifyDelegate completion:completion];
}

@end
