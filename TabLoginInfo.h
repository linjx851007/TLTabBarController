//
//  TabLoginInfo.h
//  TLTabBarController
//
//  Created by Linjx on 2020/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TabLoginInfoDelegate <NSObject>
- (void)touchLoginInfoButton;
@end

@interface TabLoginInfo : UIView
@property(nonatomic, weak) id<TabLoginInfoDelegate>loginDelegate;
- (void)reloadHeadInfo:(NSString*)headname img:(NSString*)img;
@end

NS_ASSUME_NONNULL_END
