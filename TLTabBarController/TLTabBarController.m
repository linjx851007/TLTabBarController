//
//  TLTabBarController.m
//  TLKit
//
//  Created by 李伯坤 on 2017/7/18.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "TLTabBarController.h"
#import "TLTabBarControllerProtocol.h"
#import "TLTabBar.h"
#import "UITabBarItem+TLPrivateExtension.h"

#define     TL_DOUBLE_CLICK_TIME_INTERVAL       0.5

#pragma mark - ## TLTabBarControllerDelegateEvent
@interface TLTabBarControllerDelegateEvent : NSObject <UITabBarControllerDelegate>

@property (nonatomic, strong) NSDate *lastClickDate;

- (id)initWithTabBarController:(TLTabBarController *)tabBarController;

@end

@implementation TLTabBarControllerDelegateEvent

- (id)initWithTabBarController:(TLTabBarController *)tabBarController
{
    if (self = [super init]) {
        [tabBarController setDelegate:self];
    }
    return self;
}

#pragma mark - # UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *vc = viewController;
    if (([viewController isKindOfClass:[UINavigationController class]] || [viewController isMemberOfClass:[UINavigationController class]]) && viewController.childViewControllers.count > 0) {
        vc = viewController.childViewControllers.lastObject;
    }
    
    // 判断是否已选中
    NSInteger index = [tabBarController.tabBar.items indexOfObject:viewController.tabBarItem];
    if (tabBarController.selectedIndex == index) {
        NSDate *date = [NSDate date];
        BOOL isDoubleClick = NO;
        // 判断是不是双击
        if (self.lastClickDate) {
            CGFloat time = [date timeIntervalSinceDate:self.lastClickDate];
            isDoubleClick = time < TL_DOUBLE_CLICK_TIME_INTERVAL;
        }
    
        if (isDoubleClick) {
            self.lastClickDate = nil;
            if ([vc respondsToSelector:@selector(tabBarItemDidDoubleClick)]) {
                [(UIViewController<TLTabBarControllerProtocol> *)vc tabBarItemDidDoubleClick];
            }
        }
        else {
            self.lastClickDate = date;
            if (self.lastClickDate) {
                if ([vc respondsToSelector:@selector(tabBarItemDidClick:)]) {
                    [(UIViewController<TLTabBarControllerProtocol> *)vc tabBarItemDidClick:YES];
                }
            }
        }
        return NO;
    }
    
    // 根据自定义事件判断是否允许选中
    BOOL canSelected = YES;
    if (viewController.tabBarItem.clickActionBlock) {
        canSelected = viewController.tabBarItem.clickActionBlock();
    }
    if (canSelected) {
        if ([vc respondsToSelector:@selector(tabBarItemDidClick:)]) {
            [(UIViewController<TLTabBarControllerProtocol> *)vc tabBarItemDidClick:NO];
        }
    }
    return canSelected;
}

@end


#pragma mark - ## TLTabBarController
@interface TLTabBarController ()<TLTabBarDelegate>

@property (nonatomic, strong) TLTabBarControllerDelegateEvent *delegateEvent;

@end

@implementation TLTabBarController

- (void)loadView
{
    [super loadView];
    
    self.delegateEvent = [[TLTabBarControllerDelegateEvent alloc] initWithTabBarController:self];
    [self setValue:[TLTabBar new] forKey:@"tabBar"];
    
    TLTabBar *tabbar1 = (TLTabBar*)self.tabBar;
    tabbar1.tabDelegate = self;
    
}
- (void)touchTabLogin
{
    if (self.tabbarCtrlDelegate && [self.tabbarCtrlDelegate respondsToSelector:@selector(tabbarCtrlLogin)])
    {
        [self.tabbarCtrlDelegate performSelector:@selector(tabbarCtrlLogin) withObject:nil];
    }
}
- (void)reloadHeadInfo:(NSString*)headname img:(NSString*)img
{
    TLTabBar *tabbar = (TLTabBar*)self.tabBar;
    [tabbar.loginHeader reloadHeadInfo:headname img:img];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    TLTabBar *tabbar1 = (TLTabBar*)self.tabBar;
    [tabbar1 p_resetTabBarItems];
}
-(BOOL)shouldAutorotate {
    // 不想其子页面支持旋转，可直接返回 NO
    return [self.selectedViewController shouldAutorotate];
}
-(NSUInteger)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}
-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)addChildViewController:(UIViewController *)viewController actionBlock:(BOOL (^)())actionBlock
{
    [super addChildViewController:viewController];
    
    if (actionBlock) {
        if (([viewController isKindOfClass:[UINavigationController class]] || [viewController isMemberOfClass:[UINavigationController class]]) && viewController.childViewControllers.count > 0) {
            [viewController.childViewControllers.firstObject.tabBarItem setClickActionBlock:actionBlock];
        }
        else {
            [viewController.tabBarItem setClickActionBlock:actionBlock];
        }
    }
}

- (void)addPlusItemWithSystemTabBarItem:(UITabBarItem *)systemTabBarItem actionBlock:(void (^)())actionBlock
{
    [systemTabBarItem setIsPlusButton:YES];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.tabBarItem = systemTabBarItem;
    
    [self addChildViewController:vc actionBlock:^BOOL{
        if (actionBlock) {
            actionBlock();
        }
        return NO;
    }];
}

@end

