//
//  PageViewController.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PageViewController.h"
#import "CarListViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.showOnNavigationBar = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuBGColor = [UIColor clearColor];
        self.viewFrame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    }
    return self;
}

- (NSArray<NSString *> *)titles{
    return @[@"最新", @"新闻", @"评测", @"导购", @"行情", @"用车", @"技术", @"文化", @"改装", @"游记"];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    CarListViewController *vc = [[CarListViewController alloc] initWithMsgType:index];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
