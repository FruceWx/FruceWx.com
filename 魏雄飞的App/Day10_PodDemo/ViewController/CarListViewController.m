//
//  CarListViewController.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CarListViewController.h"
#import "NetManager.h"
#import "CarMsgCell.h"
#import "WebViewController.h"
#import "ResultController.h"

#import "iCarousel.h"



@interface CarListViewController ()<iCarouselDelegate, iCarouselDataSource, UISearchResultsUpdating>
@property (nonatomic) NSMutableArray<CarMsgListResultNewslistModel *> *dataList;
@property (nonatomic) NSInteger page;

/******* TableView的头  *******/
@property (nonatomic) UIView *headerView;
@property (nonatomic) iCarousel *ic;
@property (nonatomic) UIPageControl *pc;
//存放头部请求数据的
@property (nonatomic) NSArray< CarMsgListResultFocusimgModel *> *focusList;

@property (nonatomic) NSTimer *timer;


@property (nonatomic) UISearchController *searchC;

@end
@implementation CarListViewController




-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    NSMutableArray *resultArr = [NSMutableArray new];
    [_dataList enumerateObjectsUsingBlock:^(CarMsgListResultNewslistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            if ([obj.title containsString:searchString]) {
                [resultArr addObject:obj];
            }
            
        
    }];
    
    
    ResultController *resultC = (ResultController *)_searchC.searchResultsController;
    resultC.results = resultArr;
    [resultC.tableView reloadData];
}


#pragma mark - ic Delegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _focusList.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        view = iv;
    }
    [((UIImageView *)view) setImageURL:_focusList[index].imgurl.yx_URL];
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        value = YES; //允许循环滚动
    }
    return value;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _pc.currentPage = carousel.currentItemIndex;
}
//头部滚动栏点击后触发
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSInteger ID = _focusList[index].ID;
    //[self pushToDetailVC:ID];
    [self pushToDetailVC:ID cellAtIndex:self.dataList[index]];
}

#pragma mark - Life



- (instancetype)initWithMsgType:(MsgType)msgType{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.msgType = msgType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[CarMsgCell class] forCellReuseIdentifier:@"CarMsgCell"];
    
    
    MJWeakSelf
    [self.tableView addHeaderRefresh:^{
        [NetManager getCarMsgListWithPage:1 lasttime:@"0" msgType:weakSelf.msgType handler:^(CarMsgListModel *model, NSError *error) {
            if (error) {
                [weakSelf.view showMsg:error.description];
            }else{
                //把之前的定时器关掉
                [weakSelf.timer invalidate];
                
                _focusList = model.result.focusimg;
                if (weakSelf.focusList.count > 0) {
                    
                        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
                        weakSelf.pc.numberOfPages = weakSelf.focusList.count;
                        [weakSelf.ic reloadData];
                        //开启定时器  BlocksKit提供的类别方法
                        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
                            [weakSelf.ic scrollToItemAtIndex:weakSelf.ic.currentItemIndex + 1 animated:YES];
                        } repeats:YES];
                    
                    
                }else{
                    weakSelf.tableView.tableHeaderView = weakSelf.searchC.searchBar;
                }
                
                [weakSelf.dataList removeAllObjects];
                [weakSelf.dataList addObjectsFromArray:model.result.newslist];
                _page = 1;
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
    [self.tableView beginHeaderRefresh];
    
    [self.tableView addFooterRefresh:^{
        [NetManager getCarMsgListWithPage:_page + 1 lasttime:weakSelf.dataList.lastObject.lasttime msgType:weakSelf.msgType handler:^(CarMsgListModel *model, NSError *error) {
            if (error) {
                [weakSelf.view showMsg:error.description];
            }else{
                _page += 1;
                [weakSelf.dataList addObjectsFromArray:model.result.newslist];
                [weakSelf.tableView endFooterRefresh];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
    ResultController *resultC = [ResultController new];
    _searchC = [[UISearchController alloc]initWithSearchResultsController:resultC];
    _searchC.searchResultsUpdater = self;
    _searchC.searchBar.placeholder = @"请输入要搜索的内容";
    //_searchC.hidesNavigationBarDuringPresentation = NO;
    _searchC.active = YES;
    _searchC.definesPresentationContext = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarMsgCell" forIndexPath:indexPath];
    CarMsgListResultNewslistModel *model = self.dataList[indexPath.row];
        
    
            cell.titleLb.text = model.title;
            cell.timeLb.text = model.time;
            [cell.iconIV setImageURL:model.smallpic.yx_URL];
            NSInteger replyCount = model.replycount;
            NSString *str = nil;
            if (replyCount >= 10000) {
                str = [NSString stringWithFormat:@"%.1f万评论", replyCount / 10000.0];
            }else{
                str = [NSString stringWithFormat:@"%ld评论", replyCount];
            }
            cell.replyLb.text = str;
            
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self pushToDetailVC:self.dataList[indexPath.row].ID];
    [self pushToDetailVC:self.dataList[indexPath.row].ID cellAtIndex:self.dataList[indexPath.row]];
}

- (void)pushToDetailVC:(NSInteger)ID cellAtIndex:(CarMsgListResultNewslistModel *)cell{
    NSString *detailPath = [NSString stringWithFormat:@"http://cont.app.autohome.com.cn/autov5.0.0/content/news/newscontent-n%ld-t0-rct1.json", ID];
    WebViewController *vc = [[WebViewController alloc] initWithURL:detailPath.yx_URL];
    vc.webTitle = cell.title;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    
    //[self.navigationController pushViewController:navi animated:YES];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - Lazy

- (NSMutableArray<CarMsgListResultNewslistModel *> *)dataList {
    if(_dataList == nil) {
        _dataList = [[NSMutableArray<CarMsgListResultNewslistModel *> alloc] init];
    }
    return _dataList;
}

- (UIView *)headerView{
    if (!_headerView) {
        //tableView的头 是用 = 赋值的
        //tableView.tableHeaderView = *****;
        //我们并没有进行addSubView的方式添加, 所以不能使用Masonry
        // 376 189
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.tableView.width * 189 / 376)];
        
        _ic = [iCarousel new];
        _ic.delegate = self;
        _ic.dataSource = self;
        [_headerView addSubview:_ic];
        [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _ic.scrollSpeed = 0;
        
        _pc = [UIPageControl new];
        _pc.userInteractionEnabled = NO;
        [_headerView addSubview:_pc];
        [_pc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-8);
            make.bottom.equalTo(10);
        }];
        
    }
    return _headerView;
}








@end
