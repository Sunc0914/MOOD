//
//  depressVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/24.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "depressVC.h"
#import "AdviceVC.h"

@interface depressVC ()
{
    CGFloat totalBtnHeight;
    
    CGFloat realHeight;
}

@end

@implementation depressVC
@synthesize testname;
@synthesize depressCollectionview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title = @"抑郁测评";
    
    right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(upload)];
    
    choicearr = [[NSMutableArray alloc]init];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"根据过去两周的情况，请您回答是否存在下列描述的状况级频率！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    alert.tag = 10000;
    [alert show];

}

- (void)initcollectionview{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    depressCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, upsideheight+10, SCREEN_WIDTH, 220) collectionViewLayout:flowLayout];
    depressCollectionview.backgroundColor = [UIColor clearColor];
    depressCollectionview.pagingEnabled = YES;
    depressCollectionview.showsHorizontalScrollIndicator = NO;
    depressCollectionview.showsVerticalScrollIndicator = NO;
    [depressCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"depresscell"];
    depressCollectionview.dataSource = self;
    depressCollectionview.delegate = self;

    [self.view addSubview:depressCollectionview];
}

- (void)initanswerbtn{
    btarr = [[NSMutableArray alloc]init];
    
    totalBtnHeight = 40*4+20*3;
    
    realHeight = SCREEN_HEIGHT-upsideheight-depressCollectionview.frame.size.height-totalBtnHeight;
    
    if (realHeight>0) {
        depressCollectionview.frame = CGRectMake(0, upsideheight+realHeight/3+10, SCREEN_WIDTH, 220);
    }
    else
    {
        realHeight = 0;
    }
    
    NSLog(@"%f",depressCollectionview.frame.origin.y);
    
    numberlabel.text = @"1/9";
    NSArray *answerarr = [[NSArray alloc]initWithObjects:@"完全不会",@"好几天",@"一半以上的天数",@"几乎每天", nil];
    for (int i = 0; i<4; i++) {
        answerBt = [[UIButton alloc]initWithFrame:CGRectMake(30, depressCollectionview.frame.origin.y+depressCollectionview.frame.size.height+40*i+20+realHeight/3, SCREEN_WIDTH-60, 30)];
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
    
    numberlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, depressCollectionview.frame.origin.y+depressCollectionview.frame.size.height-30, 50, 30)];
    [self.view addSubview:numberlabel];
}

- (void)initkind{
    
    NSString *name = @"yiyu";
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *result = [json objectFromJSONString];
    
    depressarr = [[NSArray alloc]initWithArray:[result objectForKey:@"data"]];
    
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
    
    if (choicearr.count == 9) {
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
    
    if (choicearr.count < 9) {
        [depressCollectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:choicearr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    if (choicearr.count == 9) {
        //答题完毕
        self.navigationItem.rightBarButtonItem = right;
        
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
    else
    {
        NSString *number = [NSString stringWithFormat:@"%lu/9",choicearr.count+1];
        numberlabel.text = number;
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
}

- (void)upload{
    [depressCollectionview removeFromSuperview];
    
    for (UIButton *btn in btarr) {
        [btn removeFromSuperview];
    }
    
    [numberlabel removeFromSuperview];
    
    int result = 0;
    
    for (int i = 0; i<choicearr.count; i++) {
        int answer = [[choicearr objectAtIndex:i] intValue];
        int temscore = 0;
        
        if (answer == 1) {
            temscore = 0;
        }
        else if (answer == 2)
        {
            temscore = 1;
        }
        else if (answer == 3)
        {
            temscore = 2;
        }
        else if (answer == 4)
        {
            temscore = 3;
        }
        
        result = result + temscore;
    }
    
    NSString *string = [choicearr componentsJoinedByString:@","];
    NSString *replaced = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"%@",string);
    

    
    [AppWebService uploadupsetanddepress:replaced points:[NSString stringWithFormat:@"%d",result] type:@"2" success:^(id result) {
        self.navigationItem.rightBarButtonItem = nil;

    } failed:^(NSError *error) {

        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 44+realHeight/2, SCREEN_WIDTH, 250)];
    back.backgroundColor = [UIColor whiteColor];
    
    UILabel *questionlable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 80)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:16];
    questionlable.backgroundColor = [UIColor clearColor];
    questionlable.textAlignment = NSTextAlignmentCenter;
    
    [back addSubview:questionlable];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 90, 200, 160)];
    
    [back addSubview:imgview];
    
    [self.view addSubview:back];
    
    if (result<4) {
        //无
        imgview.image = [UIImage imageNamed:@"yiyu_result0.jpg"];
        questionlable.text = @"没有抑郁";
    }
    else if (result>=5&&result<=9){
        //轻度
        imgview.image = [UIImage imageNamed:@"yiyu_result1.jpg"];
        questionlable.text = @"轻度抑郁，请观察等待，随访时重复PHQ-9";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"轻度抑郁，请观察等待，随访时重复PHQ-9" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"抑郁二三事",@"走出抑郁", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>=10&&result<=14){
        //中度
        imgview.image = [UIImage imageNamed:@"yiyu_result2.jpg"];
        questionlable.text = @"中度抑郁，需要制定治疗计划，考虑咨询、随访或药物治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"中度抑郁，需要制定治疗计划，考虑咨询、随访或药物治疗" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"抑郁二三事",@"走出抑郁", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>=15&&result<=19){
        //中重度
        imgview.image = [UIImage imageNamed:@"yiyu_result3.jpg"];
        questionlable.text = @"中度抑郁，请采用积极的药物治疗或心理治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"中度抑郁，请采用积极的药物治疗或心理治疗" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"抑郁二三事",@"走出抑郁", nil];
        alert.tag = 10086;
        [alert show];
    }
    else if (result>=20&&result<=27){
        //重度
        imgview.image = [UIImage imageNamed:@"yiyu_result4.jpg"];
        questionlable.text = @"重度抑郁，需要立即选择药物治疗，若严重损伤或治疗无效，建议转至精神疾病治疗专家，进行心理治疗或综合治疗";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重度抑郁，需要立即选择药物治疗，若严重损伤或治疗无效，建议转至精神疾病治疗专家，进行心理治疗或综合治疗" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"抑郁二三事",@"走出抑郁", nil];
        alert.tag = 10086;
        [alert show];
    }
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *datestr = [dateformatter stringFromDate:date];
    NSMutableDictionary *temdic = [[NSMutableDictionary alloc]initWithDictionary:userinfo.testresult];
    [temdic setObject:[[NSString alloc]initWithFormat:@"%@(测评时间：%@)",questionlable.text,datestr] forKey:@"depress"];
    userinfo.testresult = temdic;
    [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];

}

#pragma mark - uicollectionviewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return depressarr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"depresscell" forIndexPath:indexPath];
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel *questionlable = [[UILabel alloc]initWithFrame:CGRectMake(30, -20, SCREEN_WIDTH-60, 50)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:14];
    questionlable.backgroundColor = [UIColor clearColor];
//    questionlable.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:questionlable];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, questionlable.frame.origin.y+questionlable.frame.size.height+10, 178, 160)];
    imgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"yiyu%ld.jpg",(long)indexPath.row]];
    [cell.contentView addSubview:imgview];
    
    
    numberlabel.adjustsFontSizeToFitWidth = YES;
    
    numberlabel.text = [NSString stringWithFormat:@"%ld/9",((long)indexPath.row+1)];
    NSString *str = [depressarr objectAtIndex:indexPath.row];
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
    itemIndex = (scrollView.contentOffset.x ) / depressCollectionview.frame.size.width;
    
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        [self initkind];
        [self initcollectionview];
        [self initanswerbtn];
    }else if (alertView.tag == 10086){
        if (buttonIndex == 1) {
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"yiyu23";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if(buttonIndex ==2){
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"zouchuyiyu";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if (buttonIndex == 0){
            
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
