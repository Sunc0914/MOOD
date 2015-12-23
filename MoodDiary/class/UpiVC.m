//
//  UpiVC.m
//  MoodDiary
//
//  Created by Sunc on 15/10/20.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "UpiVC.h"
#import "ResultVC.h"
#import "QueryVC.h"

@interface UpiVC ()
{
    CGFloat totalBtnHeight;
    
    CGFloat realHeight;
    
    BOOL fromResultPage;
}

@end

@implementation UpiVC

@synthesize testname;
@synthesize collectionview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(upload)];
    
    choicearr = [[NSMutableArray alloc]init];
    
    [self initkind];
    [self initcollectionview];
    [self initanswerbtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (fromResultPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)initcollectionview{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) collectionViewLayout:flowLayout];
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.pagingEnabled = YES;
    collectionview.showsHorizontalScrollIndicator = NO;
    collectionview.showsVerticalScrollIndicator = NO;
    [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"testcell"];
    collectionview.dataSource = self;
    collectionview.delegate = self;
    
    
    [self.view addSubview:collectionview];
    
}

- (void)initanswerbtn{
    btarr = [[NSMutableArray alloc]init];
    
    totalBtnHeight = 40*5+20*3;
    
    realHeight = SCREEN_HEIGHT-upsideheight-collectionview.frame.size.height-totalBtnHeight;
    
    if (realHeight>0) {
        collectionview.frame = CGRectMake(0, upsideheight, SCREEN_WIDTH, 250);
    }
    else
    {
        realHeight = 0;
    }
    
    numberlabel.text = @"1/64";
    NSArray *answerarr = [[NSArray alloc]initWithObjects:@"是",@"否", nil];
    for (int i = 0; i<2; i++) {
        answerBt = [[UIButton alloc]initWithFrame:CGRectMake(30, collectionview.frame.size.height+collectionview.frame.origin.y+40*i+20+realHeight/3, SCREEN_WIDTH-60, 30)];
        answerBt.tag = i;
        answerBt.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
        [answerBt setTitle:[answerarr objectAtIndex:i] forState:UIControlStateNormal];
        answerBt.layer.masksToBounds = YES;
        answerBt.layer.cornerRadius = 5;
        [answerBt setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [answerBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [answerBt addTarget:self action:@selector(btclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:answerBt];
        [btarr addObject:answerBt];
    }
    
    numberlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, collectionview.frame.origin.y+collectionview.frame.size.height-30, 60, 30)];
    numberlabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:numberlabel];
    
}

- (void)initkind{
    
    self.title = @"UPI测评";
    
    NSString *name = @"upi";
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *result = [json objectFromJSONString];
    
    sclarr = [[NSArray alloc]initWithArray:[result objectForKey:@"data"]];
    
}

- (void)btclicked:(UIButton *)sender{
    
    [self sclpress:sender];
    
}

- (void)sclpress:(UIButton *)sender{
    
    if (itemIndex>(choicearr.count)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请按顺序做题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (choicearr.count == 64) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已做完全部题目，请提测评交结果" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    last = now;
    now = [NSDate date];
    if (last) {
        //防作弊
        NSTimeInterval sec = [now timeIntervalSinceDate:last];
        if (sec < 0.5) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您做的过快，请根据自身情况认真答题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if (sender.tag == 0) {
        NSString *str = @"1";
        [choicearr addObject:str];
    }
    else if (sender.tag == 1)
    {
        NSString *str = @"2";
        [choicearr addObject:str];
    }
    
    if (choicearr.count < 64) {
        [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:choicearr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    if (choicearr.count == 64) {
        //答题完毕
        self.navigationItem.rightBarButtonItem = right;
        
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
    else
    {
        NSString *number = [NSString stringWithFormat:@"%lu/64",choicearr.count+1];
        numberlabel.text = number;
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
}

- (void)upload
{
    NSLog(@"%lu",(unsigned long)choicearr.count);
    [self.view showProgress:YES text:@"上传结果..."];
    self.view.userInteractionEnabled = NO;
    NSString *string = [choicearr componentsJoinedByString:@","];
    NSString *replaced = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"%@",string);
    [AppWebService uploadresult:replaced type:@"5" success:^(id result) {
        NSLog(@"success");
        
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        
        NSString *msg = [NSString stringWithFormat:@"%@",[result objectForKey:@"msg"]];
        
        if (![msg isEqualToString:@"无效问卷"]) {
            msg = @"您的结果正常，如有疑问，请联系学校心理咨询中心";
        }
        
        if ([msg isEqualToString:@"<null>"]) {
            msg = @"您的结果正常，如有疑问，请联系学校心理咨询中心";
        }
        
        NSDictionary *temdic = [result objectForKey:@"data"];
        NSDictionary *studic = [temdic objectForKey:@"student"];
        NSDictionary *accountdic = [studic objectForKey:@"account"];
        
        //        [self.view showResult:ResultViewTypeOK text:msg];
        
        UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        NSDate *date = [[NSDate alloc]init];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *datestr = [dateformatter stringFromDate:date];
        NSMutableDictionary *resultdic = [[NSMutableDictionary alloc]initWithDictionary:userinfo.testresult];
        [resultdic setObject:[[NSString alloc]initWithFormat:@"%@(测评时间：%@)",msg,datestr] forKey:@"holland"];
        userinfo.testresult = resultdic;
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        
        userinfo.accountType = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"accountType"]];
        userinfo.birthday = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"birthday"]];
        userinfo.email = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"email"]];
        userinfo.userid = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"userid"]];
        userinfo.idCard = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"idCard"]];
        userinfo.loginCount = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"loginCount"]];
        userinfo.name = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"name"]];
        userinfo.nickname = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"name"]];
        userinfo.phone = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"phone"]];
        userinfo.photo = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"photo"]];
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"registerDate"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"sex"]];
        userinfo.signature = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"signature"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"status"]];
        userinfo.useraccount = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"username"]];
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        
        //设置说明页面题目做完状态
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"心理咨询", nil];
        alert.tag = 10086;
        [alert show];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        
    }];
    
}

#pragma mark - uicollectionviewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 64;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testcell" forIndexPath:indexPath];
    
    UILabel *questionlable = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH-40, 150)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:16];
    questionlable.backgroundColor = [UIColor whiteColor];
    questionlable.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:questionlable];
    
    int group = (int)((indexPath.row)/10);
    int num = (int)((indexPath.row)%10);
    numberlabel.text = [NSString stringWithFormat:@"%ld/64",((long)indexPath.row+1)];
    NSArray *arr = [sclarr objectAtIndex:group];
    NSString *str = [arr objectAtIndex:num];
    NSLog(@"%@",str);
    questionlable.text = str;
    
    return cell;
}

#pragma mark - uicollectionviewdelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    itemIndex = (scrollView.contentOffset.x ) / collectionview.frame.size.width;
    if ((itemIndex) < choicearr.count) {
        
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
        
        int j = [[choicearr lastObject] intValue];
        switch (j) {
            case 1:
                [[btarr objectAtIndex:0] setSelected:YES];
                break;
            case 2:
                [[btarr objectAtIndex:1] setSelected:YES];
                break;
                
            default:
                break;
        }
        
        if (choicearr.count>0) {
            [choicearr removeLastObject];
        }
    }
}

#pragma mark - uialertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1)
        {
            QueryVC *query = [[QueryVC alloc]init];
            query.isToRoot = YES;
            query.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:query animated:YES];
            
        }
    }
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
