//
//  PaperVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "PaperVC.h"
#import "ArticleDetailViewController.h"
#import "AppWebService.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface PaperVC (){
    CGFloat height;
    NSMutableArray *articleArray;
    NSInteger numbersOfRow;
    //NSInteger selectedRowOfIndexPath;
    UIWebView *webView;
    
    UIButton *reloadBtn;
    UIImageView *reloadImage;
}

@end

@implementation PaperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    height = 135;
    
    self.title = @"阅读";
    self.view.backgroundColor = [UIColor whiteColor];
    
    reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    [reloadBtn addTarget:self action:@selector(initArticle) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.backgroundColor = [UIColor clearColor];
    
    reloadImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, (SCREEN_HEIGHT-SCREEN_WIDTH+200)/2, SCREEN_WIDTH-200, SCREEN_WIDTH-200)];
    reloadImage.image = [UIImage imageNamed:@"reload"];
    
    [self initTableView];
    [self initArticle];

}


- (void)initArticle{
    
    articleTableView.userInteractionEnabled = NO;
//    [self.view showProgress:YES text:@"获取美文..."];
    
    [AppWebService articleListWithStart:@"0" limit:@"10" success:^(id result) {
        [reloadBtn removeFromSuperview];
        [reloadImage removeFromSuperview];
        NSDictionary *tempdata  = [result objectForKey:@"data"];
        articleArray = [[NSMutableArray alloc]initWithArray:[tempdata objectForKey:@"acticles"]]; //这里接口有拼写错误
        numbersOfRow = [articleArray count];
//        [self.view showProgress:NO];
        [articleTableView.header endRefreshing];
        [articleTableView reloadData];
        articleTableView.userInteractionEnabled = YES;
        
        [articleTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmoredata)];
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
        [self.view addSubview:reloadImage];
        [self.view addSubview:reloadBtn];
//        [self.view showProgress:NO];
        articleTableView.userInteractionEnabled = YES;
        
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [articleTableView.header endRefreshing];
    }];
}

- (void)getmoredata{
    
    NSInteger count = [articleArray count];
    NSString *string = [[NSString alloc]initWithFormat:@"%ld",(long)count];
    
    [AppWebService articleListWithStart:string limit:@"10" success:^(id result) {
        
        [reloadBtn removeFromSuperview];
        [reloadImage removeFromSuperview];
        
        NSDictionary *tempdata  = [result objectForKey:@"data"];
        NSMutableArray *articleArray2 = [[NSMutableArray alloc]initWithArray:[tempdata objectForKey:@"acticles"]]; //这里接口有拼写错误
        for (NSDictionary *dic in articleArray2) {
            [articleArray addObject:dic];
        }
        
        numbersOfRow = [articleArray count];
        
        [articleTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmoredata)];
        
        [articleTableView.footer endRefreshing];
        [articleTableView reloadData];
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
//        [self.view showProgress:NO];
        
        if(![[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"暂时没有数据"]&&articleArray.count == 0)
        {
            //如果不是暂时没有数据
            [self.view addSubview:reloadImage];
            [self.view addSubview:reloadBtn];
        }
        
        if([[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"暂时没有数据"]){
            //加载完毕
            [articleTableView removeFooter];
        }
        
        self.view.userInteractionEnabled = YES;
        
        
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [articleTableView.footer endRefreshing];
    }];
}

- (void)initTableView{
    NSLog(@"0");
    
    articleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49-upsideheight)];
    articleTableView.delegate = self;
    articleTableView.dataSource = self;
    articleTableView.tableFooterView = [[UIView alloc]init];
    articleTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [articleTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    articleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载和下拉刷新
    [articleTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(initArticle)];
    
    CGRect frame = articleTableView.tableHeaderView.frame;
    frame.size.height = 25;
    articleTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:articleTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numbersOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"article";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self setElementInCell:cell atIndexPath:indexPath];
    }
        [self configElementInCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    ArticleDetailViewController *articleDetailViewController = [[ArticleDetailViewController alloc]init];
    NSString *tempString = [dic objectForKey:@"url"];
    tempString = [@"http://etotech.net:8080" stringByAppendingString:tempString];
    articleDetailViewController.url = [NSURL URLWithString:tempString];
    articleDetailViewController.titleString = [dic objectForKey:@"title"];
    articleDetailViewController.dateString = [dic objectForKey:@"date"];
    articleDetailViewController.digest = [dic objectForKey:@"digest"];
    articleDetailViewController.frameheight = SCREEN_HEIGHT-upsideheight-49;
    
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        articleDetailViewController.thumbnailURL = url;
    }else{
        articleDetailViewController.thumbnailURL = nil;
    }

    articleDetailViewController.IDString = [dic objectForKey:@"id"];
    
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
}


- (void)setElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    
    UIView *tempBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH-20, height-4 )];
    tempBackgroundView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:tempBackgroundView];
    
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 95, 95)];
    
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    }else{
        UIImage *image = [UIImage imageNamed:@"no_pic"];
        [imageView setImage:image];
    }
    
    imageView.tag = 30;
    [cell addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(125, 15, SCREEN_WIDTH - 140 , 40)];
    title.tag = 31;
    title.text = [dic objectForKey:@"title"];
//    title.backgroundColor = [UIColor redColor];
    title.numberOfLines = 2;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.font = [UIFont systemFontOfSize:14];
    title.contentMode = UIViewContentModeCenter;
    [cell addSubview:title];
    
    UILabel *digest = [[UILabel alloc]initWithFrame:CGRectMake(125, 50, SCREEN_WIDTH - 140, 55)];
    digest.tag = 32;
    digest.text = [dic objectForKey:@"digest"];
    digest.textColor = [UIColor grayColor];
//    time.backgroundColor = [UIColor greenColor];
    digest.font = [UIFont systemFontOfSize:12];
    digest.contentMode = UIViewContentModeCenter;
    digest.numberOfLines = 0;
    [cell addSubview:digest];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(125, 105, 110, 15)];
    time.backgroundColor = [UIColor clearColor];
    time.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]];
    time.textColor = [UIColor grayColor];
//    timeAndSource.adjustsFontSizeToFitWidth = YES;
    time.font = [UIFont systemFontOfSize:11];
    time.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:time];
    
    UILabel *source = [[UILabel alloc]initWithFrame:CGRectMake(235, 105, SCREEN_WIDTH-255, 15)];
    source.backgroundColor = [UIColor clearColor];
    source.text = [NSString stringWithFormat:@"来自：%@",[dic objectForKey:@"source"]];
    source.textColor = [UIColor grayColor];
    //    timeAndSource.adjustsFontSizeToFitWidth = YES;
    source.font = [UIFont systemFontOfSize:11];
    source.textAlignment = NSTextAlignmentRight;
    [cell addSubview:source];
    
    cell.backgroundColor = [UIColor clearColor];
}

- (void)configElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:30];
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    }else{
        UIImage *image = [UIImage imageNamed:@"no_pic"];
        [imageView setImage:image];
    }
    
    
    UILabel *title = (UILabel *)[cell viewWithTag:31];
    title.text = [dic objectForKey:@"title"];
    UILabel *time  = (UILabel *)[cell viewWithTag:32];
    time.text = [dic objectForKey:@"digest"];
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
