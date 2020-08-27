//
//  TabLoginInfo.m
//  TLTabBarController
//
//  Created by Linjx on 2020/8/11.
//

#import "TabLoginInfo.h"

@interface TabLoginInfo()
@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *upLabel;
@property(nonatomic,strong) UILabel *downLabel;
@property(nonatomic,strong) UIButton *clickButton;
@property(nonatomic,assign) BOOL isLogin;
@end

@implementation TabLoginInfo
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo:) name:@"loadUserInfo" object:nil];
    }
    [self loadUI];
    return self;
}
- (void)loadUserInfo:(NSNotification*)notification
{
    NSDictionary *dict = [notification userInfo];
    BOOL isLogin = [[dict objectForKey:@"islogin"] boolValue];
    NSString *nickName = [dict objectForKey:@"nickname"];
    NSString *headurl = [dict objectForKey:@"headurl"];
    self.isLogin = isLogin;
    if (self.isLogin)
    {
        [self reloadHeadInfo:nickName img:headurl];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)loadUI
{
    CGFloat topmarge = 2;
    CGFloat leftmarge = 10;
    CGSize headsize = CGSizeMake(self.frame.size.height - topmarge*2, self.frame.size.height - topmarge*2);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftmarge, topmarge, headsize.width, headsize.height)];
    self.headImg = imgView;
    NSString *imgPath = [NSString stringWithFormat:@"skin/main/%@",@"icon_head_0.png"];
    UIImage *img = [UIImage imageNamed:imgPath];
    imgView.image = img;
    [self addSubview:self.headImg];
    
    CGFloat labW = self.frame.size.width - leftmarge*2 - headsize.width;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(headsize.width + self.headImg.frame.origin.x + 10, 10,labW, self.frame.size.height/2 - 10)];
    self.upLabel = label1;
    [self addSubview:self.upLabel];
    self.upLabel.text = @"登录/注册";
    self.upLabel.textColor = [UIColor grayColor];
    self.upLabel.font = [UIFont systemFontOfSize:12.0f];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(headsize.width + self.headImg.frame.origin.x + 10, self.frame.size.height/2,labW, self.frame.size.height/2- 10)];
    self.downLabel = label2;
    [self addSubview:self.downLabel];
    self.downLabel.text = @"登录可享受更多服务";
    self.downLabel.textColor = [UIColor grayColor];
    self.downLabel.font = [UIFont systemFontOfSize:10.0f];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clickButton];
    self.clickButton.frame = self.bounds;
    self.clickButton.backgroundColor = [UIColor clearColor];
    [self.clickButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)allClick
{
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(touchLoginInfoButton)])
    {
        if (!self.isLogin)
        {
            [self.loginDelegate performSelector:@selector(touchLoginInfoButton) withObject:nil];
        }
        
    }
}
- (void)reloadHeadInfo:(NSString*)headname img:(NSString*)img
{
    if (self.isLogin)
    {
        self.upLabel.text = headname;
        self.downLabel.text = @"欢迎来到麒麟！";
        self.upLabel.textColor = [UIColor colorWithRed:224.0/255.0 green:164.0/255.0 blue:80.0/255.0 alpha:1.0];
        [self.headImg performSelector:@selector(tt_setImageWithURL:) withObject:[NSURL URLWithString:img]];
    }
    else{
        NSString *imgPath = [NSString stringWithFormat:@"skin/main/%@",@"icon_head_0.png"];
        UIImage *img = [UIImage imageNamed:imgPath];
        self.headImg.image = img;
        self.upLabel.text = @"登录/注册";
        self.downLabel.text = @"登录可享受更多服务";
        self.upLabel.textColor = [UIColor grayColor];
    }
    
}

@end
