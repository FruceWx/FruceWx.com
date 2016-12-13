//
//  ResultController.m
//  Day10_PodDemo
//
//  Created by 魏雄飞 on 2016/12/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ResultController.h"
#import "CarMsgCell.h"
#import "WebViewController.h"

@interface ResultController ()

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[CarMsgCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self pushToDetailVC:self.dataList[indexPath.row].ID];
    [self pushToDetailVC:self.results[indexPath.row].ID cellAtIndex:self.results[indexPath.row]];
}

- (void)pushToDetailVC:(NSInteger)ID cellAtIndex:(CarMsgListResultNewslistModel *)cell{
    NSString *detailPath = [NSString stringWithFormat:@"http://cont.app.autohome.com.cn/autov5.0.0/content/news/newscontent-n%ld-t0-rct1.json", ID];
    WebViewController *vc = [[WebViewController alloc] initWithURL:detailPath.yx_URL];
    vc.webTitle = cell.title;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (![cell viewWithTag:400]) {
        UIImageView *iconIV = [[UIImageView alloc] init];
        [cell.contentView addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(80, 60));
            make.centerY.equalTo(0);
            make.left.equalTo(11);
        }];
        iconIV.layer.cornerRadius = 4;
        iconIV.tag = 400;
    }
    cell.iconIV = (UIImageView *)[cell viewWithTag:400];
    [cell.iconIV setImageURL:_results[indexPath.row].smallpic.yx_URL];
    
    if (![cell viewWithTag:400]) {
        UILabel *titleLb = [[UILabel alloc] init];
        [cell.contentView addSubview:titleLb];
        titleLb.numberOfLines = 0;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(cell.iconIV);
            make.left.equalTo(cell.iconIV.mas_right).offset(8);
            make.right.equalTo(-8);
            make.height.lessThanOrEqualTo(35);
        }];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.numberOfLines = 1;
        titleLb.tag = 300;
    }
    cell.titleLb = (UILabel *)[cell viewWithTag:300];
    cell.titleLb.text = _results[indexPath.row].title;
    
    if (![cell viewWithTag:200]) {
        UILabel *timeLb = [[UILabel alloc] init];
        [cell.contentView addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.titleLb);
            make.bottom.equalTo(cell.iconIV);
        }];
        timeLb.font = [UIFont systemFontOfSize:12];
        timeLb.textColor = [UIColor grayColor];
        timeLb.tag = 200;
    }
    cell.timeLb = (UILabel *)[cell viewWithTag:200];
    cell.timeLb.text = _results[indexPath.row].time;
    
    if (![cell viewWithTag:100]) {
        UILabel *replyLb = [[UILabel alloc] init];
        [cell.contentView addSubview:replyLb];
        [replyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.titleLb);
            make.bottom.equalTo(cell.iconIV);
        }];
        replyLb.font = [UIFont systemFontOfSize:12];
        replyLb.textColor = [UIColor grayColor];
        replyLb.tag = 100;
    }
    cell.replyLb = (UILabel *)[cell viewWithTag:100];
    NSInteger replyCount = _results[indexPath.row].replycount;
    NSString *str = nil;
    if (replyCount >= 10000) {
        str = [NSString stringWithFormat:@"%.1f万评论", replyCount / 10000.0];
    }else{
        str = [NSString stringWithFormat:@"%ld评论", replyCount];
    }
    cell.replyLb.text = str;

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
