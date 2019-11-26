//
//  UITableView+NoData.m
//  Pop
//
//  Created by 张宝山 on 2019/11/26.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import "UITableView+NoData.h"
#import <objc/runtime.h>
#import "TableNoDataView.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@protocol TableViewNoDataDelegate <NSObject>
@optional
// 完全自定义占位图
- (UIView *)tb_noDataView;
// 使用默认占位图 提供一张图片可不提供 默认不显示
- (UIImage *)tb_noDataViewImage;
// 使用默认占位图 提供文字 可不提供默认为暂无数据
- (NSString *)tb_noDataViewTitle;
// 使用默认占位图 提供显示文字颜色 可不提供 默认为灰色
- (UIColor *)tb_noDataViewTitleColor;
// 默认占位图 CenterY向下偏移量
- (NSNumber *)tb_noDataViewCenterYOffset;

@end
 
@implementation UITableView (NoData)

+ (void)load {

        Method reloadData = class_getInstanceMethod(self, @selector(reloadData));
        Method tb_reloadData = class_getInstanceMethod(self, @selector(tb_reloadData));
        method_exchangeImplementations(reloadData, tb_reloadData);
        
        Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method tb_dealloc = class_getInstanceMethod(self, @selector(tb_dealloc));
        method_exchangeImplementations(dealloc, tb_dealloc);
}


- (void)tb_reloadData {
    [self tb_reloadData];
    
    // 是否忽略第一次加载
//    if (![self initFinish]) {
//        [self tb_haveData:YES];
//        [self setInitFinish:YES];
//    }
    
    //检测是否有数据
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger number = [self numberOfSections];
        BOOL haveData = NO;
        for (NSInteger i = 0; i < number; i ++) {
            if ([self numberOfRowsInSection:i] > 0){
                haveData = YES;
                break;
            }
        }
        [self tb_haveData:haveData];
    });
}

- (void)tb_haveData:(BOOL)haveData {
    
    //不需要展示占位图
    if (haveData) {
        self.backgroundView = nil;
        return ;
    }
    
    if (self.backgroundView) {
        return ;
    }
    
    //自定义占位图
    if ([self.delegate respondsToSelector:@selector(tb_noDataView)]) {
        self.backgroundView = [self.delegate performSelector:@selector(tb_noDataView)];
        return;
    }
 
    //使用自带的图片文字颜色以及偏移量
    UIImage *img = nil;
    NSString *str = @"暂无数据";
    UIColor *color = [UIColor lightGrayColor];
    CGFloat offset = 0;
    
    //获取图片
    if ([self.delegate respondsToSelector:@selector(tb_noDataViewImage)]) {
        img = [self.delegate performSelector:@selector(tb_noDataViewImage)];
    }
    
    //获取文字
    if ([self.delegate respondsToSelector:@selector(tb_noDataViewTitle)]) {
        str = [self.delegate performSelector:@selector(tb_noDataViewTitle)];
    }
    
    //获取颜色
    if ([self.delegate respondsToSelector:@selector(tb_noDataViewTitleColor)]) {
        color = [self.delegate performSelector:@selector(tb_noDataViewTitleColor)];
    }
    
    //获取偏移量
    if ([self.delegate respondsToSelector:@selector(tb_noDataViewCenterYOffset)]) {
        offset = [[self.delegate performSelector:@selector(tb_noDataViewCenterYOffset)] floatValue];
    }
    
    //创建占位图
    self.backgroundView = [self tb_defaultNoDataViewImage:img title:str color:color offserY:offset];
}

// 默认占位图

- (UIView *)tb_defaultNoDataViewImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color offserY:(CGFloat)offsetY {
    
    //计算位置 照片默认中心偏上
    CGFloat width = self.bounds.size.width;
    CGFloat x = width / 2.0;
    CGFloat y = self.bounds.size.height * (1 - 0.618) + offsetY;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(x - iW / 2, y - iH / 2, iW, iH);
    imgView.image = image;
    
    //文字
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = color;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 24, width, label.font.lineHeight);
    
    //视图
    TableNoDataView *view = [[TableNoDataView alloc] init];
    [view addSubview:imgView];
    [view addSubview:label];
    
    //实现跟随TableView滚动
    [view addObserver:self forKeyPath:kNoDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}

#pragma mark - 标记属性

// 加载完数据的标记属性名
static NSString *const kRLTableViewPropertyInitFinish = @"kRLTableViewPropertyInitFinish";

//设置已经加载完成的数据
- (void)setInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &kRLTableViewPropertyInitFinish, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

//是否已经加载完成数据
- (BOOL)initFinish {
    id obj = objc_getAssociatedObject(self, &kRLTableViewPropertyInitFinish);
    return [obj boolValue];
}

//监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kNoDataViewObserveKeyPath]) {
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        if (frame.origin.y != 0) {
            frame.origin.y = 0;
            self.backgroundView.frame = frame;
        }
    }
}

//移除监听
- (void)freeNoDataViewIfNeeded {
    if ([self.backgroundView isKindOfClass:[TableNoDataView class]]) {
        [self.backgroundView removeObserver:self forKeyPath:kNoDataViewObserveKeyPath context:nil];
    }
}

- (void)tb_dealloc {
    [self tb_dealloc];
    [self freeNoDataViewIfNeeded];
    NSLog(@"tableView销毁");
}

@end
