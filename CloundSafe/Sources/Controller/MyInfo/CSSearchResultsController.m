//
//  CSSearchResultsController.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import "CSSearchResultsController.h"
#import "CSContact.h"
#import "CSContactInoContorller.h"
@interface CSSearchResultsController ()

@end

@implementation CSSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc]init]];//清除tableView多余的分割线
    self.tableView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"最佳匹配";
    [header addSubview:label];
    self.tableView.tableHeaderView = header;
    
}
//收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.phoneSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchContactCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchContactCell"];
    }
    CSContact *contact = self.phoneSource[indexPath.row];
    cell.textLabel.text = contact.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.selectBlock();
    CSContactInoContorller *info = [[CSContactInoContorller alloc]initWithContact:self.phoneSource[indexPath.row]];
    
    [self.weakController.navigationController pushViewController:info animated:YES];
}

@end
