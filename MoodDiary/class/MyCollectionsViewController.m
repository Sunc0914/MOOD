//
//  MyCollectionsViewController.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MyCollectionsViewController.h"
#import "DataModel.h"
#import "ArticleDetailViewController.h"
#import "ArticleDetail.h"
@interface MyCollectionsViewController (){
    UITableView *collectionTableView;
    DataModel *_dataModel;
    NSInteger height;
}

@end

@implementation MyCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = 80;
    _dataModel = [[DataModel alloc]init];
    [self initTableView];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)initTableView{
    collectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT -upsideheight)];
    collectionTableView.delegate = self;
    collectionTableView.dataSource = self;
    //collectionTableView.editing = YES;
    collectionTableView.backgroundColor = [UIColor whiteColor];
    [collectionTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    //collectionTableView.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
    [self.view addSubview:collectionTableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataModel articles]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return height;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Collections";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setElementInCell:cell atIndexPath:indexPath];
    }
    [self configElementInCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetailViewController *articelDetailViewController = [[ArticleDetailViewController alloc]init];
    ArticleDetail *articleDetail = [_dataModel.articles objectAtIndex:indexPath.row];
    
    articelDetailViewController.url = articleDetail.articleURL;
    articelDetailViewController.IDString = articleDetail.IDString;
    articelDetailViewController.frameheight = SCREEN_HEIGHT-upsideheight;
    articelDetailViewController.thumbnailURL = articleDetail.thumbnailURL;
    articelDetailViewController.titleString = articleDetail.titleString;
    articelDetailViewController.digest = articleDetail.digest;
    
    [self.navigationController pushViewController:articelDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_dataModel.articles removeObjectAtIndex:indexPath.row];
    [_dataModel saveArticles];
    [collectionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)setElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ArticleDetail *articleDetail = [_dataModel.articles objectAtIndex:indexPath.row];
    
    UIView *tempBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH-20, height-4 )];
   // tempBackgroundView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:196.0/255.0 blue:235.0/255.0 alpha:1.0];
    [cell addSubview:tempBackgroundView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 118 , 30)];
    title.tag = 31;
    title.text = articleDetail.titleString;
    [cell addSubview:title];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH - 100, 30)];
    time.tag = 32;
    time.text = articleDetail.dateString;
    time.textColor = [UIColor grayColor];
    time.font = [UIFont systemFontOfSize:12];
    [cell addSubview:time];
    
    //cell.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];


}

- (void)configElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ArticleDetail *articleDetail = [_dataModel.articles objectAtIndex:indexPath.row];
    UILabel *title = (UILabel *)[cell viewWithTag:31];
    title.text = articleDetail.titleString;
    UILabel *time  = (UILabel *)[cell viewWithTag:32];
    time.text = articleDetail.dateString;
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
