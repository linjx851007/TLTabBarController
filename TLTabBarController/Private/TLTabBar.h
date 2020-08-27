//
//  TLTabBar.h
//  TLKit
//
//  Created by 李伯坤 on 2017/7/18.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

/**
 *  重新设置item图文位置，响应区域处理
 */

#import "UITabBar+TLExtension.h"
#import "TabLoginInfo.h"
@protocol TLTabBarDelegate <NSObject>
- (void)touchTabLogin;
@end
@interface TLTabBar : UITabBar
@property (nonatomic, strong) TabLoginInfo *loginHeader;
@property(nonatomic, weak) id<TLTabBarDelegate>tabDelegate;
- (void)p_resetTabBarItems;
@end
