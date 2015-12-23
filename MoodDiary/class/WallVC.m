//
//  WallVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "WallVC.h"
#import "WallTableviewcellTableViewCell.h"
#import "MJRefresh.h"

@interface WallVC ()
{
    NSString *nowDateStr;
    UIButton *reloadBtn;
    UIImageView *reloadImage;
}

@property (nonatomic, retain)NSString *start;
@property (nonatomic, retain)NSString *limit;
@property (nonatomic) CGFloat keboardheight;
@property (nonatomic, retain) NSString *nickname;

@end

static const CGFloat MJDuration = 1.0;


@implementation WallVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"心情墙";
    walllist = [[NSMutableArray alloc]init];
    _start = @"0";
    _limit = @"10";
    
    commentheight = [[NSMutableArray alloc]init];
    commentlistarr = [[NSMutableArray alloc]init];
    selectedstate = [[NSMutableArray alloc]init];
    
    subpostid = [[NSString alloc]init];
    nowDateStr = [[NSString alloc]init];
    subpostid = nil;
    
    right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"newwrite"] style:UIBarButtonItemStylePlain target:self action:@selector(writemood)];
    
    clearbtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearbtnclicked)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    typearr = [[NSMutableArray alloc]initWithObjects:@"梁山篇",@"皇帝篇",@"武侠篇",@"动漫篇",@"火影篇", nil];
    nicknamedic = [[NSMutableDictionary alloc]init];
    
    NSString *name = @"nickname";
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    nicknamedic = [json objectFromJSONString];
    
    reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    [reloadBtn addTarget:self action:@selector(getlistdata) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.backgroundColor = [UIColor clearColor];
    
    reloadImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, (SCREEN_HEIGHT-SCREEN_WIDTH+200)/2, SCREEN_WIDTH-200, SCREEN_WIDTH-200)];
    reloadImage.image = [UIImage imageNamed:@"reload"];
    
    [self initKeyboardNotification];
    
    [self initwall];
    
    [self getlistdata];
    
}

- (void)writemood{
    
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        //没有登录
        [self showLoginWindow];
        return;
    }
    
    //发表心情墙
    self.navigationItem.rightBarButtonItem = clearbtn;
    
    //修改昵称
    changenick.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    
    nicknamefield.delegate = self;
    nicknamefield.font = [UIFont systemFontOfSize:16];
    nicknamefield.returnKeyType = UIReturnKeyDone;
    
    nicknamefield.layer.borderWidth = 1;
    nicknamefield.layer.cornerRadius = 5;
    nicknamefield.layer.borderColor = [UIColor whiteColor].CGColor;
    nicknamefield.layer.masksToBounds = YES;
    
    [changenick addSubview:nicknamefield];
    
    [comfirmbtn setTitle:@"发      表" forState:UIControlStateNormal];
    [comfirmbtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    comfirmbtn.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
    comfirmbtn.layer.cornerRadius = 5;
    comfirmbtn.layer.masksToBounds = YES;
    [changenick addSubview:comfirmbtn];
    
    [self.view addSubview:changenick];
    
    [nicknamefield becomeFirstResponder];
}

- (void)clearbtnclicked{
    nicknamefield.text = @"";
    changenick.frame = CGRectMake(0, heightwhenkeyboardshow, SCREEN_WIDTH, 120);
    nicknamefield.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 40);
    comfirmbtn.frame  = CGRectMake(20, changenick.frame.size.height-60, SCREEN_WIDTH-40, 50);
}

- (void)publish{
    
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        //没有登录
        [self showLoginWindow];
        return;
    }
    
    if (nicknamefield.text.length == 0) {
        [self.view showResult:ResultViewTypeFaild text:@"内容不能为空"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem = right;
    
    [AppWebService publishcomment:nicknamefield.text success:^(id result) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeOK text:@"匿名心情发表成功"];
        
        [nicknamefield resignFirstResponder];
        isaftercomment = YES;
        
        nicknamefield.text = @"";
        [self getlistdata];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeFaild text:@"发表失败，请稍后再试"];
    }];
}

- (void)initwall{
    
    walltable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    walltable.delegate = self;
    walltable.dataSource = self;
    walltable.backgroundColor = [UIColor whiteColor];
    [walltable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    walltable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerview.backgroundColor = [UIColor whiteColor];
    [walltable setTableHeaderView:headerview];
    
    [walltable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getlistdata)];
    
    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        walltable.frame = CGRectMake(0, navheight+stateheight, SCREEN_WIDTH, SCREEN_HEIGHT-navheight-stateheight-49);
    }
    
    CGRect frame = walltable.tableHeaderView.frame;
    frame.size.height = 25;
    
    [self.view addSubview:walltable];
}

- (void)getlistdata{
    //下拉刷新
    
    if (isaftercomment == NO) {

        [walltable.header beginRefreshing];
    }
    
    walltable.userInteractionEnabled = NO;
    
    [AppWebService moodwalllist:@"0" limit:_limit success:^(id result) {
        NSLog(@"success");
        
        [reloadImage removeFromSuperview];
        [reloadBtn removeFromSuperview];
        
        NSDate *senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        nowDateStr =[dateformatter stringFromDate:senddate];
        
        isaftercomment = NO;
        NSDictionary *datadic = [[NSDictionary alloc]init];
        datadic = [result objectForKey:@"data"];
        
        NSArray *temarr = [datadic objectForKey:@"posts"];
        
        if (temarr.count>0) {
            
            walllist = [[NSMutableArray alloc]init];
            [walllist addObjectsFromArray:temarr];
            
            for (int i = 0; i<temarr.count; i++) {
                [commentheight addObject:@"0"];
                [commentlistarr addObject:@"nil"];
            }
        }
        
        
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [walltable.header endRefreshing];
            
            
//            [self.view showProgress:NO];
            
            [walltable reloadData];
            
            //添加上拉加载
            [walltable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmorelistdata)];
            
            walltable.userInteractionEnabled = YES;
            
        });
        
    } failed:^(NSError *error) {
        
        isaftercomment = NO;
        
        [self.view addSubview:reloadImage];
        [self.view addSubview:reloadBtn];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [walltable.header endRefreshing];
            
            
            
            [self.view showResult:ResultViewTypeFaild text:@"获取失败"];
            
        });

        walltable.userInteractionEnabled = YES;
        
        NSLog(@"failed");
        
//        [walltable.header endRefreshing];
    }];
}

- (void)getmorelistdata{
    //上拉加载更多
    
    walltable.userInteractionEnabled = NO;
    
    _start = [NSString stringWithFormat:@"%lu",(unsigned long)walllist.count];
    
//    [self.view showProgress:YES text:@"获取心情墙..."];
    [walltable.footer beginRefreshing];
    
    [AppWebService moodwalllist:_start limit:_limit success:^(id result) {
        NSLog(@"success");
        [reloadImage removeFromSuperview];
        [reloadBtn removeFromSuperview];
        NSDictionary *datadic = [[NSDictionary alloc]init];
        datadic = [result objectForKey:@"data"];
        
        NSArray *temarr = [datadic objectForKey:@"posts"];
        
        if (temarr.count>0) {
            [walllist addObjectsFromArray:temarr];
            
            for (int i = 0; i<temarr.count; i++) {
                [commentheight addObject:@"0"];
                [commentlistarr addObject:@"nil"];
            }
        }
        
        //模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [walltable.footer endRefreshing];
            
//            [self.view showProgress:NO];
            
            [walltable reloadData];
            
            walltable.userInteractionEnabled = YES;
            
        });
        
    } failed:^(NSError *error) {
//        [self.view showProgress:NO];
        
        [self.view addSubview:reloadImage];
        [self.view addSubview:reloadBtn];
        [self.view showResult:ResultViewTypeFaild text:@"获取失败"];
        walltable.userInteractionEnabled = YES;
        NSLog(@"failed");
    }];
}

- (void)initKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initKeyboardNotification];
    
    changenick = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 120)];
    nicknamefield = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
    comfirmbtn  = [[UIButton alloc]initWithFrame:CGRectMake(20, changenick.frame.size.height-60, SCREEN_WIDTH-40, 50)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self hideview:changenick height:SCREEN_HEIGHT];
    walltable.userInteractionEnabled = YES;
    [nicknamefield resignFirstResponder];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)comfirmbtnpress:(UIButton *)sender{
    
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        //没有登录
        [self showLoginWindow];
        return;
    }
    
    //评论某人
    if (nicknamefield.text.length == 0) {
        [self.view showResult:ResultViewTypeFaild text:@"内容不能为空"];
        return;
    }
    
    //发表评论
    NSInteger index = sender.tag;
    NSDictionary *temdic = [walllist objectAtIndex:index];
    
    NSString *postid = [temdic objectForKey:@"id"];
    
    [AppWebService addcomment:postid content:nicknamefield.text commentid:subpostid success:^(id result) {
        
        
        [self.view showResult:ResultViewTypeOK text:@"评论成功"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = [walllist objectAtIndex:index];
        [self getcommentlist:[dic objectForKey:@"id"] start:@"0" limit:@"10" index:[NSString stringWithFormat:@"%ld",(long)index]];
        
        isaftercomment = YES;
        
        [self getlistdata];
        
        subpostid = nil;
        
        self.navigationItem.rightBarButtonItem = right;
        
        [nicknamefield resignFirstResponder];
        nicknamefield.text = @"";
        
    } failed:^(NSError *error) {
        
        [self.view showResult:ResultViewTypeOK text:@"评论失败，请稍后再试"];
        subpostid = nil;
    }];
    
    [nicknamefield resignFirstResponder];
}

- (void)commentbtnclicked:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    
    changenick.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    
    nicknamefield.delegate = self;
    nicknamefield.font = [UIFont systemFontOfSize:16];
    nicknamefield.returnKeyType = UIReturnKeyDone;
    
    
    nicknamefield.layer.borderWidth = 1;
    nicknamefield.layer.cornerRadius = 5;
    nicknamefield.layer.borderColor = [UIColor whiteColor].CGColor;
    nicknamefield.layer.masksToBounds = YES;
    
    [changenick addSubview:nicknamefield];
    
    [comfirmbtn setTitle:@"发      表" forState:UIControlStateNormal];
    comfirmbtn.tag = sender.tag;
    [comfirmbtn addTarget:self action:@selector(comfirmbtnpress:) forControlEvents:UIControlEventTouchUpInside];
    comfirmbtn.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
    comfirmbtn.layer.cornerRadius = 5;
    comfirmbtn.layer.masksToBounds = YES;
    [changenick addSubview:comfirmbtn];
    
    [self.view addSubview:changenick];
    
    [nicknamefield becomeFirstResponder];
}

- (void)favouritebtnclicked:(UIButton *)sender{
    //发表评论
    
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        //没有登录
        [self showLoginWindow];
        return;
    }
    
    NSInteger index = sender.tag;
    NSDictionary *temdic = [walllist objectAtIndex:index];
    
    NSString *postid = [temdic objectForKey:@"id"];
    
//    [self.view showProgress:YES];
    
    [AppWebService favourite:postid success:^(id result) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeOK text:@"点赞成功"];
        int num = [sender.titleLabel.text intValue];
        
        num = num + 1;
        [sender setTitle:[NSString stringWithFormat:@"%d",num] forState:UIControlStateNormal];
        sender.selected = YES;
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void)getcommenthight:(NSMutableArray *)sender index:(NSString *)index{
    //获取评论高度
    int i = [index intValue];
    NSMutableArray *temarr = [[NSMutableArray alloc]init];
    temarr = [sender objectAtIndex:i];
    CGFloat temhight = 0;
    
    for (int j = 0; j<temarr.count; j++) {
        
        NSDictionary *commentdic = [temarr objectAtIndex:j];
        NSString *content = [commentdic objectForKey:@"content"];
        CGSize contentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:14 text:content];
#pragma mark - 此处修改评论间距
        temhight = temhight + (contentsize.height + 8.0f);
    }
    
    [commentheight replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",temhight]];
    
    [walltable reloadData];
    
}

- (void)getcommentlist:(NSString *)postid start:(NSString *)start limit:(NSString *)limit index:(NSString *)index{
    //获取心情下面的评论
    [AppWebService getcomment:postid start:start limit:limit success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *datadic = [[NSDictionary alloc]init];
        datadic = [result objectForKey:@"data"];
        NSArray *commentdataarr = [datadic objectForKey:@"comments"];
        
        NSMutableArray *commentarr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<commentdataarr.count; i++) {
            NSDictionary *temdic = [[NSDictionary alloc]init];
            temdic = [commentdataarr objectAtIndex:i];
            
            NSDictionary *accountdic = [temdic objectForKey:@"account"];
            NSString *nickNameStr = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"anonymity"]];
            
            //此处到时候由后台统一随机分配昵称
//            int x = arc4random() % (typearr.count-1);
//            NSString *typestr = [typearr objectAtIndex:x];
//            
//            NSArray *nicknamearr = [nicknamedic objectForKey:typestr];
//            
//            int y = arc4random() % (nicknamearr.count-1);
            
            NSString *content = [NSString stringWithFormat:@"%@ : %@",nickNameStr,[temdic objectForKey:@"content"]];
            
            NSMutableDictionary *datadic = [[NSMutableDictionary alloc]init];
            
            [datadic setValue:content forKey:@"content"];
            [datadic setValue:[temdic objectForKey:@"id"] forKey:@"id"];
            [datadic setValue:[temdic objectForKey:@"date"] forKey:@"date"];
            
            [commentarr  addObject:datadic];
            
        }
        
        if (commentarr.count<[limit intValue]) {
            morecomment = NO;
        }
        else
        {
            morecomment = YES;
            [commentarr addObject:@"点击加载更多评论"];
        }
        
        [commentlistarr replaceObjectAtIndex:[index intValue] withObject:commentarr];
        
        [self getcommenthight:commentlistarr index:index];
        
    } failed:^(NSError *error) {
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void)subcommentbtnclicked:(UIButton *)sender{
    
    //哪一个cell;
    NSInteger index = sender.tag/100;
    //第几个评论;
    NSInteger whichindex = sender.tag%100;
    
    NSMutableArray *list  = [commentlistarr objectAtIndex:index];
    
    NSDictionary *commentdic = [list objectAtIndex:whichindex];
    
    subpostid = [commentdic objectForKey:@"id"];
    
    if ([sender.titleLabel.text isEqual: @"点击加载更多评论"]) {
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = [walllist objectAtIndex:index];
        
        [self getcommentlist:[dic objectForKey:@"id"] start:[NSString stringWithFormat:@"%lu",(unsigned long)list.count] limit:@"10" index:[NSString stringWithFormat:@"%ld",(long)index]];
        
        return;
    }
    
    //适应下面函数
    sender.tag = index;
    
    [self commentbtnclicked:sender];
}

#pragma mark - KeyboardNotification
-(void) keyboardWillShow:(NSNotification *) note
{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    _keboardheight = kbSize.height;
    
    heightwhenkeyboardshow = SCREEN_HEIGHT - _keboardheight-changenick.frame.size.height;
    
    [self showview:changenick height:(SCREEN_HEIGHT - _keboardheight-changenick.frame.size.height)];
    walltable.userInteractionEnabled = NO;
    
}

-(void) keyboardWillHide:(NSNotification *) note
{
    _keboardheight = 0;
    [self hideview:changenick height:SCREEN_HEIGHT];
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return walllist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *temdic = [[NSDictionary alloc]init];
    temdic = [walllist objectAtIndex:indexPath.row];
    
    NSString *content = [temdic objectForKey:@"content"];
    CGSize contentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:16 text:content];
    
    
    if ([selectedstate containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        CGFloat temheight = [[commentheight objectAtIndex:indexPath.row] floatValue];
        
        NSDictionary *temdic = [walllist objectAtIndex:indexPath.row];
        
        int commentcount = [[temdic objectForKey:@"commentCount"] intValue];
        
        return contentsize.height+40+60+temheight+commentcount*1.5f+5;
    }
    else
    {
        return contentsize.height+40+60+5;
    }
    
}


#pragma mark - uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([selectedstate containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        [selectedstate removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    else{
        [selectedstate addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = [walllist objectAtIndex:indexPath.row];
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [self getcommentlist:[dic objectForKey:@"id"] start:@"0" limit:@"10" index:index];
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"wall";
    WallTableviewcellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WallTableviewcellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.delegate = self;
    
    if ([selectedstate containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        //如果行被选中，表示评论已展开
        id class = [commentlistarr objectAtIndex:indexPath.row];
        
        if ([class isKindOfClass:[NSString class]]) {
            //没有评论
            [cell setcontent:[walllist objectAtIndex:indexPath.row] commentarr:nil height:0 more:NO number:indexPath.row  nowDate:(NSString *)nowDateStr];
        }
        else
        {
            //有评论
            
            CGFloat temheight = [[commentheight objectAtIndex:indexPath.row] floatValue];
            
            [cell setcontent:[walllist objectAtIndex:indexPath.row] commentarr:[commentlistarr objectAtIndex:indexPath.row] height:temheight more:morecomment number:indexPath.row nowDate:(NSString *)nowDateStr];
        }
    }
    else
    {
        //行没有选中
        [cell setcontent:[walllist objectAtIndex:indexPath.row] commentarr:nil height:0 more:NO number:indexPath.row  nowDate:(NSString *)nowDateStr];
    }
    
    NSInteger tag = indexPath.row;
    
    cell.commentbtn.tag = tag;
    cell.favouritebtn.tag = indexPath.row;
    
    [cell.commentbtn addTarget:self action:@selector(commentbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favouritebtn addTarget:self action:@selector(favouritebtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - uitextviewdelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize constraintSize;
    
    constraintSize.width = SCREEN_WIDTH-40;
    constraintSize.height = 120;
    CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (sizeFrame.height<40) {
        nicknamefield.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 40);
        return;
    }
    
    changenick.frame = CGRectMake(0, changenick.frame.origin.y, SCREEN_WIDTH, 50+sizeFrame.height+30);
    
    comfirmbtn.frame = CGRectMake(20, 50+sizeFrame.height+30-60, SCREEN_WIDTH-40, 50);
    
    [self showview:changenick height:(SCREEN_HEIGHT - _keboardheight-50-sizeFrame.height-30)];
    
    textView.frame = CGRectMake(20,10,SCREEN_WIDTH-40,sizeFrame.height);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        self.navigationItem.rightBarButtonItem = right;
        return NO;
    }
    return YES; 
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
