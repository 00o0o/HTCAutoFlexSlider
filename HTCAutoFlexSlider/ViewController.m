//
//  ViewController.m
//  HTCAutoFlexSlider
//
//  Created by Clover on 9/15/17.
//  Copyright © 2017 Clover. All rights reserved.
//

#import "ViewController.h"
#import "HTCAutoFlexSliderView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static CGFloat const NAVBAR_HEIGHT = 64.f;

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIImageView *navbarBgImageView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) HTCAutoFlexSliderView *sliderView;
@property (nonatomic, strong) YYLabel *textLabel;

@property (nonatomic, copy) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat sliderMaskAlpha;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageUrls = @[@"http://haitao.nos.netease.com/20170915105147f7bb5625d4154c4a8ff6f02f798f87b0.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/20170915105152c38c8652d39c4eeb9f74f7242ea0811a.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/201709151051531be1c4d05abb49b5a6f8b85908433e00.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/20170915105152c38c8652d39c4eeb9f74f7242ea0811a.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/20170915105153e602d2a4397c45dfad2bf1c9c3aba1fc.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/20170915105152c38c8652d39c4eeb9f74f7242ea0811a.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/201709151051522155ce4674534226981ec5df266179d5.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/20170915105152c38c8652d39c4eeb9f74f7242ea0811a.jpeg?imageView&quality=85&thumbnail=960z960",
                       @"http://haitao.nos.netease.com/2017091510515595d42c52d34f4aeaa3742723f8c1acb1.jpeg?imageView&quality=85&thumbnail=960z960"];
    
    [self.view addSubview:self.navigationBar];
    [self.navigationBar insertSubview:self.navbarBgImageView atIndex:0];
    [self.view insertSubview:self.contentView belowSubview:self.navigationBar];
    [self.contentView addSubview:self.sliderView];
    [self.contentView addSubview:self.textLabel];
    [self _layoutViews];
}

- (void)_layoutViews {
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NAVBAR_HEIGHT);
    }];
    
    [self.navbarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationBar);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(kScreenWidth);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sliderView.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - Views
- (UINavigationBar *)navigationBar {
    if(!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.subviews.firstObject.hidden = YES;
    }
    return _navigationBar;
}

- (UIImageView *)navbarBgImageView {
    if(!_navbarBgImageView) {
        _navbarBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _navbarBgImageView.hidden = YES;
        _navbarBgImageView.clipsToBounds = YES;
        
    }
    return _navbarBgImageView;
}

- (UIScrollView *)contentView {
    if(!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.bounces = NO;
        _contentView.bouncesZoom = NO;
        _contentView.delegate = self;
    }
    return _contentView;
}

- (HTCAutoFlexSliderView *)sliderView {
    if(!_sliderView) {
        _sliderView = [[HTCAutoFlexSliderView alloc] initWithFrame:CGRectZero];
        _sliderView.imageUrls = _imageUrls;
        
    }
    return _sliderView;
}

- (YYLabel *)textLabel {
    if(!_textLabel) {
        _textLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        _textLabel.preferredMaxLayoutWidth = kScreenWidth;
        _textLabel.textContainerInset = UIEdgeInsetsMake(20, 0, 20, 0);
        [_textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        NSString *text = @"前几日一小哥悄悄私戳我——考拉高圆圆，求照片！ 作为妖鹿山第一星探，岂能放过任何一个美女～ 看到仙女本人……（这小哥眼光真不错） 热情温柔美丽大方＆堪比专业级的美妆护肤达人！（街拍酱被种草无数🌱🌱🌱🌱🌱🌱） 👉🏻【个人档案】 ✨顾碧英✨ 花 名： 考拉高圆圆、PP 年 龄： 90后 部 门：网易考拉美容彩妆事业部 岗 位：活动运营 星 座：处女座 恋爱状况：恋爱中……（小哥哥💔街拍酱只能帮到这里了） 👉🏻【服饰搭配】 裙子：逛街随便买的 鞋子：COOE 包包：Kenzo（考拉买的！！！） 手饰：手镯是玛瑙，手串石榴石、绿松、菩提根 👗PP小姐姐平时比较喜欢棉麻的衣服，今天的这身藕粉色裙子十分青春，配上银色的高跟鞋更添气场，造型更是信手拈来~高腰的设计和膝盖以上的长度让整个人看起来比例更加协调美观，同时藕粉色也可以衬得皮肤白嫩白嫩的。 👠对于这双鞋子的搭配，PP小姐姐也是花了小心思的哦~她说：“因为裙子是单色的，同时颜色比较淡雅，给人较为安静的感觉，所以鞋子是关键。漆皮的质感和棉麻反差过大，绒面的搭配又太过沉闷，家里缎面鞋颜色跳跃，白色水钻鞋刚刚恰到好处。白的色调，搭配一颗颗亮亮的小钻，正好起到点睛之笔的作用。” 👉🏻【护肤彩妆】 粉底：cpb钻光 隔离：黑管隔离 口红: YSL8号 定妆：cpb散粉（cpb真爱粉一枚！） 看PP皮肤那么好（羡慕脸嫉妒脸！）街拍酱乘机讨教了一些护肤小妙招。PP小姐姐非常认真地给我上了“一堂课”！并且最后……街拍酱被种草了好多好多好多好用的东西！！！！！（这个月的工资……员工工资回收计划员工工资回收计划！） 💡PP小课堂💡 ❓如何选择护肤品 ❗️选择护肤品时要看成分、功效、口碑还有品牌。 抗皱的首推欧美那些大牌。美白的则主要是日本了，雅诗兰黛、SKII、希思黎，再加上美容仪定期护理，皮肤会变得又好又稳定。 现在安瓶护肤很流行，对皮肤的有效因子有90%甚至98%，是一般晚霜和营养霜的12至13倍，可以用它来定期对皮肤做集中护理。 ❓护肤品一定要买贵的么？以奥尔滨健康水为例，330ML的接近600，而平价版的才一百多，看成分也差不多，区别呢？ ❗️其实大家用了之后就会发现，平价版的只是有短期的效果，而奥尔滨能让你的皮肤在变好之后，继续稳定在一个好的状态，这就是平价版不能达到的效果。另外，成分相同，不代表用的东西就一模一样，猪里脊和猪屁股还都叫猪肉呢，口感可就差多啦~（这个类比，街拍酱服气！） 🔅另外最好让肌肤一周有一次深呼吸的时间，即洁面清洁完成后，除了重点部位（眼周、法令纹等）可适量抹点护肤品外，裸肌睡眠。这样可较好的避免肌肤营养过剩不吸收的问题。 👉🏻【八卦爆料】 🐨“考拉高圆圆”这个称呼最开始是怎么来的？ 👱🏻‍♀️可能都长得比较高吧哈哈哈哈哈 🐨每天上班梳妆打扮大概会花多久时间？ 👱🏻‍♀️15-20分钟，日常上班快手妆，让你天天美美哒（关注考拉美妆的活动，为你推荐全球最潮流的美妆，和超实用的美肤资讯~） 🐨头发真美，给个造型师微信呗~ 👱🏻‍♀️这是我自己弄的，用卷发棒自己做了外卷，让头发有自然随意的弧度，且弹性很好，比直发看起来更加活泼。 🐨在考拉美容彩妆部工作，每天看各种化妆品护肤品，也会买买买吗？ 👱🏻‍♀️当然会！买的最多的就是口红，开心不开心都在买，所以结果就是口红色号一大堆~可以给大家推荐几款橙色系的口红色号，YSL镜面8号，香奈儿96号，TF44号（前两个考拉有售哦~），特别是YSL的，超显白~ （PP小姐姐真是不放过任何一个安利的机会！） 🐨在考拉买过最中意的东西有什么？ 👱🏻‍♀️能说有好多么？先给大家推荐几款常用的呗。奥尔滨健康水+渗透乳（超级适合痘痘肌和敏感肌）、CPB钻光粉底液（添加了护肤的成分，搭配CPB的散粉使用效果更好！）另外雪花秀的套盒啊，雅诗兰黛的精华/眼霜啊，后的礼盒啊，都在考拉买了，正品直采价格优惠，从此摒弃了机场免税店~ （请大家关注考拉美妆新品上新，业界潮流先知晓） 👉🏻【为自己的部门打call】 来考拉买美妆，用好的正品进化颜值！ ——————————————————— #网易街拍# 潮人潮搭，一天一个风格！";
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 4;
        [attrText setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:14],
                                  NSParagraphStyleAttributeName: style}];
        _textLabel.attributedText = attrText;
    }
    return _textLabel;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat a = self.textLabel.top - NAVBAR_HEIGHT - scrollView.contentOffset.y;
    if(a > 0) {
        _navbarBgImageView.hidden = YES;
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset((0-scrollView.contentOffset.y)/2);
        }];
        
        _sliderMaskAlpha = scrollView.contentOffset.y / (self.textLabel.top - NAVBAR_HEIGHT);
        if(_sliderMaskAlpha <= 1.f) {
            _sliderView.blurRadius = _sliderMaskAlpha;
        }
    }else {
        _sliderView.blurRadius = 1.f;
        if(_navbarBgImageView.hidden) {
            _navbarBgImageView.hidden = NO;
            UIImage *image = [self.sliderView snapshotImageAfterScreenUpdates:YES];
            CGRect rect = CGRectMake(0, (self.textLabel.top - NAVBAR_HEIGHT) * kScreenScale, self.sliderView.width * kScreenScale, NAVBAR_HEIGHT * kScreenScale);
            _navbarBgImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
        }
        
    }
}

@end
