//
//  upsetVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/24.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "upsetVC.h"
#import "AdviceVC.h"

@interface upsetVC ()
{
    CGFloat totalBtnHeight;
    
    CGFloat realHeight;
}

@end

@implementation upsetVC
@synthesize testname;
@synthesize upsetCollectionview;

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

- (void)initcollectionview{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    upsetCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, upsideheight+10, SCREEN_WIDTH, 220) collectionViewLayout:flowLayout];
    upsetCollectionview.backgroundColor = [UIColor clearColor];
    upsetCollectionview.pagingEnabled = YES;
    upsetCollectionview.showsHorizontalScrollIndicator = NO;
    upsetCollectionview.showsVerticalScrollIndicator = NO;
    [upsetCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"upsetcell"];
    upsetCollectionview.dataSource = self;
    upsetCollectionview.delegate = self;
    
    
    [self.view addSubview:upsetCollectionview];
    
}

- (void)initanswerbtn{
    btarr = [[NSMutableArray alloc]init];
    
    totalBtnHeight = 40*4+20*3;
    
    realHeight = SCREEN_HEIGHT-upsideheight-upsetCollectionview.frame.size.height-totalBtnHeight;
    
    if (realHeight>0) {
        upsetCollectionview.frame = CGRectMake(0, upsideheight+realHeight/3+10, SCREEN_WIDTH, 220);
    }
    else
    {
        realHeight = 0;
    }
    
    numberlabel.text = @"1/20";
    NSArray *answerarr = [[NSArray alloc]initWithObjects:@"没有或很少时间",@"小部分时间",@"相当多时间",@"绝大部分或全部时间", nil];
    for (int i = 0; i<4; i++) {
        answerBt = [[UIButton alloc]initWithFrame:CGRectMake(30, upsetCollectionview.frame.size.height+upsetCollectionview.frame.origin.y+40*i+20+realHeight/3, SCREEN_WIDTH-60, 30)];
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
    
    numberlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, upsetCollectionview.frame.origin.y+upsetCollectionview.frame.size.height-30, 50, 30)];
    numberlabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:numberlabel];
}

- (void)initkind{
    
    self.title = @"焦虑测评";
    
    NSString *name = @"jiaolv";
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *result = [json objectFromJSONString];
    
    upsetarr = [[NSArray alloc]initWithArray:[result objectForKey:@"data"]];
    
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
    
    if (choicearr.count == 20) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已做完全部题目，请提测评交结果" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    last = now;
    now = [NSDate date];
    if (last) {
        //防作弊
        NSTimeInterval sec = [now timeIntervalSinceDate:last];
        if (sec < 0.3) {
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
    else if (sender.tag == 2 )
    {
        NSString *str = @"3";
        [choicearr addObject:str];
    }
    else if (sender.tag == 3)
    {
        NSString *str = @"4";
        [choicearr addObject:str];
    }
    
    if (choicearr.count < 20) {
        [upsetCollectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:choicearr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    if (choicearr.count == 20) {
        //答题完毕
        self.navigationItem.rightBarButtonItem = right;
        
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
    else
    {
        NSString *number = [NSString stringWithFormat:@"%lu/20",choicearr.count+1];
        numberlabel.text = number;
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
}

- (void)upload{
    
    [upsetCollectionview removeFromSuperview];
    [numberlabel removeFromSuperview];
    
    for (UIButton *btn in btarr) {
        [btn removeFromSuperview];
    }
    
    int result = 0;
    
    for (int i = 0; i<choicearr.count; i++) {
        int answer = [[choicearr objectAtIndex:i] intValue];
        int temscore = 0;
        
        if (i==5||i==8||i==12||i==16||i==18) {
            //反向计分项
            if (answer == 1) {
                temscore = 4;
            }
            else if (answer == 2)
            {
                temscore = 3;
            }
            else if (answer == 3)
            {
                temscore = 2;
            }
            else if (answer == 4)
            {
                temscore = 1;
            }
        }
        else{
            if (answer == 1) {
                temscore = 1;
            }
            else if (answer == 2)
            {
                temscore = 2;
            }
            else if (answer == 3)
            {
                temscore = 3;
            }
            else if (answer == 4)
            {
                temscore = 4;
            }
        }
        
        result = result + temscore;
    }
    
    result = result * 1.25;
    
    NSString *string = [choicearr componentsJoinedByString:@","];
    NSString *replaced = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"%@",string);
    
    
    [AppWebService uploadupsetanddepress:replaced points:[NSString stringWithFormat:@"%d",result] type:@"1" success:^(id result) {
        self.navigationItem.rightBarButtonItem = nil;
    } failed:^(NSError *error) {
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, upsideheight+44+realHeight/2, SCREEN_WIDTH, 250)];
    back.backgroundColor = [UIColor whiteColor];
    
    UILabel *questionlable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 50)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:14];
    questionlable.backgroundColor = [UIColor clearColor];
    questionlable.textAlignment = NSTextAlignmentCenter;
    [back addSubview:questionlable];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 90, 200, 160)];
    
    [back addSubview:imgview];
    
    [self.view addSubview:back];
    

    if (result<16) {
        //无
        imgview.image = [UIImage imageNamed:@"jiaolv_picresult0.jpg"];
        questionlable.text = @"没有焦虑";
    }
    else if (result>=16){
        //轻度
        imgview.image = [UIImage imageNamed:@"jiaolv_picresult1.jpg"];
        questionlable.text = @"轻度焦虑，请观察等待，随访时重复PHQ-9";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"轻度焦虑，请观察等待，随访时重复PHQ-9" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"5个战胜焦虑的技巧",@"如何克服焦虑", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>32){
        //中度
        imgview.image = [UIImage imageNamed:@"jiaolv_picresult2.jpg"];
        questionlable.text = @"中度焦虑，需要制定治疗计划，考虑咨询、随访或药物治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"中度焦虑，需要制定治疗计划，考虑咨询、随访或药物治疗" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"5个战胜焦虑的技巧",@"如何克服焦虑", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>48){
        //重度
        imgview.image = [UIImage imageNamed:@"jiaolv_picresult3.jpg"];
        questionlable.text = @"中度焦虑，请采用积极的药物治疗或心理治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"中度焦虑，请采用积极的药物治疗或心理治疗" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"5个战胜焦虑的技巧",@"如何克服焦虑", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>64){
        //重度
        imgview.image = [UIImage imageNamed:@"jiaolv_picresult4.jpg"];
        questionlable.text = @"重度焦虑，需要立即选择药物治疗，若严重损伤或治疗无效，建议转至精神疾病治疗专家，进行心理治疗或综合治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重度焦虑，需要立即选择药物治疗，若严重损伤或治疗无效，建议转至精神疾病治疗专家，进行心理治疗或综合治疗" delegate:self cancelButtonTitle:@"好的"otherButtonTitles:@"5个战胜焦虑的技巧",@"如何克服焦虑", nil];
        alert.tag = 10086;
        [alert show];
    }
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *datestr = [dateformatter stringFromDate:date];
    NSMutableDictionary *temdic = [[NSMutableDictionary alloc]initWithDictionary:userinfo.testresult];
    [temdic setObject:[[NSString alloc]initWithFormat:@"%@(测评时间：%@)",questionlable.text,datestr] forKey:@"upset"];
    userinfo.testresult = temdic;
    [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
    
}

#pragma mark - uicollectionviewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return upsetarr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upsetcell" forIndexPath:indexPath];
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel *questionlable = [[UILabel alloc]initWithFrame:CGRectMake(30, -20, SCREEN_WIDTH-60, 50)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:16];
    questionlable.backgroundColor = [UIColor clearColor];
    questionlable.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:questionlable];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, questionlable.frame.origin.y+questionlable.frame.size.height+10, 200, 160)];
    imgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"jiaolv%ld.jpg",(long)indexPath.row]];
    [cell.contentView addSubview:imgview];
    
    numberlabel.text = [NSString stringWithFormat:@"%ld/20",((long)indexPath.row+1)];
    NSString *str = [upsetarr objectAtIndex:indexPath.row];
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
    itemIndex = (scrollView.contentOffset.x ) / upsetCollectionview.frame.size.width;
    
    for (UIButton *tembt in btarr) {
        tembt.selected = NO;
    }
    
    if ((itemIndex) < choicearr.count) {
        
        int j = [[choicearr lastObject] intValue];
        switch (j) {
            case 1:
                [[btarr objectAtIndex:0] setSelected:YES];
                break;
            case 2:
                [[btarr objectAtIndex:1] setSelected:YES];
                break;
            case 3:
                [[btarr objectAtIndex:2] setSelected:YES];
                break;
            case 4:
                [[btarr objectAtIndex:3] setSelected:YES];
                break;
                
            default:
                break;
        }
        
        if ((choicearr.count-itemIndex)==1) {
            [choicearr removeLastObject];
        }
    }
}

#pragma mark - uialertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10086) {
        if (buttonIndex == 1) {
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"jiaolv5";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if(buttonIndex ==2){
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"kefujiaolvzhihu";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if (buttonIndex == 0){
//            [self.navigationController popToRootViewControllerAnimated:YES];
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
