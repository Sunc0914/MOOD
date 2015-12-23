//
//  FirstpageVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/16.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "FirstpageVC.h"
#import "NewTestVC.h"
#import "SpecificVC.h"
#import "PicturePageVC.h"

@interface FirstpageVC ()

@end

@implementation FirstpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"测评";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initparts];
}

- (void)initparts{
    scrollback = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight+10, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-49-10)];
    scrollback.backgroundColor = [UIColor whiteColor];
    scrollback.delegate = self;
    [self.view addSubview:scrollback];
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, (SCREEN_WIDTH-20)/2)];
    btn1.tag = 1;
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"scl.jpg"] forState:UIControlStateNormal];
    [scrollback addSubview:btn1];
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5;
    [btn1 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn1.frame.origin.y + btn1.frame.size.height+10, SCREEN_WIDTH-20,(SCREEN_WIDTH-20)/2 )];
    btn4.tag = 4;
    btn4.backgroundColor = [UIColor clearColor];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"holland.jpg"] forState:UIControlStateNormal];
    [scrollback addSubview:btn4];
    btn4.layer.masksToBounds = YES;
    btn4.layer.cornerRadius = 5;
    [btn4 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    btn5 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn4.frame.origin.y + btn4.frame.size.height+10, SCREEN_WIDTH-20,(SCREEN_WIDTH-20)/2 )];
    btn5.tag = 5;
    btn5.backgroundColor = [UIColor orangeColor];
    [btn5 setBackgroundImage:[UIImage imageNamed:@"upi.png"] forState:UIControlStateNormal];
    btn5.layer.masksToBounds = YES;
    btn5.layer.cornerRadius = 5;
    [scrollback addSubview:btn5];
    [btn5 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
//    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn5.frame.origin.y + btn5.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/1.4)];
//    btn2.tag = 2;
//    btn2.backgroundColor = [UIColor clearColor];
//    [btn2 setBackgroundImage:[UIImage imageNamed:@"upset.jpg"] forState:UIControlStateNormal];
//    [scrollback addSubview:btn2];
//    btn2.layer.masksToBounds = YES;
//    btn2.layer.cornerRadius = 5;
//    [btn2 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-20-8)/2-10, btn5.frame.origin.y + btn5.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/1.4)];
//    btn3.tag = 3;
//    btn3.backgroundColor = [UIColor clearColor];
//    btn3.layer.masksToBounds = YES;
//    btn3.layer.cornerRadius = 5;
//    [btn3 setBackgroundImage:[UIImage imageNamed:@"depress.jpg"] forState:UIControlStateNormal];
//    [scrollback addSubview:btn3];
//    [btn3 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
//
    
    
    if ((btn5.frame.origin.y+btn5.frame.size.height)<(SCREEN_HEIGHT-upsideheight-49)) {
        scrollback.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-49+10);
    }
    else
    {
        scrollback.contentSize = CGSizeMake(SCREEN_WIDTH, btn5.frame.origin.y+btn5.frame.size.height+10);
    }
    
    scrollback.showsVerticalScrollIndicator = NO;
    
}

- (void)btnpress:(UIButton *)sender{
    
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        //没有登录
        [self showLoginWindow];
        return;
    }
    
    switch (sender.tag) {
        case 1:
            [self pushtoscl];
            break;
        case 2:
            [self pushtojiaolv];
            break;
        case 3:
            [self pushtoyiyu];
            break;
        case 4:
            [self pushtoholland];
            break;
        case 5:
            [self pushtoupi];
            break;

        default:
            break;
    }
}

- (void)pushtoscl{
    
    //scl
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",info.accountType];
    
    NSString *singleChar = [[NSString alloc]init];
    
    NSInteger length = typeStr.length;
    
    if (length > 2) {
        
        singleChar = [typeStr substringWithRange:NSMakeRange(0, 1)];
        
        if ([singleChar isEqualToString:@"1"]) {
            
//            [self.view showResult:ResultViewTypeOK text:@"您的账号为测试账号"];
            //            return;
            
        }
        else if ([singleChar isEqualToString:@"2"]){
            
            singleChar = [typeStr substringWithRange:NSMakeRange(1, 1)];
            
            if ([singleChar isEqualToString:@"0"]) {
                //没有权限
                [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
                return;
            }
            
            if ([singleChar isEqualToString:@"2"]) {
                //已完成测评
                [self.view showResult:ResultViewTypeOK text:@"您已做过测评"];
                return;
            }
        }
    }
    else
    {
        //没有权限
        [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
        return;
    }
    
    SpecificVC *specific = [[SpecificVC alloc]init];
    specific.hidesBottomBarWhenPushed = YES;
    specific.content1 = @"本测试可以帮助你更好地了解自己近期的状态，以便调试自我心态，更好地适应大学生活。";
    specific.content2 = @"测试共有90条项目，请仔细阅读每一条，然后根据最近一星期以内你的实际情况，点击适合的答案，每个项目只能选择一个答案，尽量不选择中性答案。\n\n 测验有时间限制，请凭自己的直觉进行作答。 有些题目你可能从未思考过，或者感到不太容易回答，对于这样的题目，同样要求你做出一种倾向性的选择。请注意不要漏题。";
    specific.testtype = @"SCL90";
    [self.navigationController pushViewController:specific animated:YES];

}

- (void)pushtojiaolv{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *account = info.useraccount;
    
    NSInteger accountInt = [account integerValue];
    
    if(accountInt != 0)
    {
        [self.view showResult:ResultViewTypeFaild text:@"您没有权限做该测评"];
        return;
    }
    
    PicturePageVC *picture = [[PicturePageVC alloc]init];
    picture.testType = @"upset";

    picture.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picture animated:YES];
}

- (void)pushtoyiyu{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *account = info.useraccount;
    
    NSInteger accountInt = [account integerValue];
    
    if(accountInt != 0)
    {
        [self.view showResult:ResultViewTypeFaild text:@"您没有权限做该测评"];
        return;
    }
    
    PicturePageVC *picture = [[PicturePageVC alloc]init];
    picture.testType = @"depress";
    
    picture.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picture animated:YES];
}

- (void)pushtoholland{
    
    //霍兰德
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",info.accountType];
    
    NSString *singleChar = [[NSString alloc]init];
    
    NSInteger length = typeStr.length;
    
    if (length > 2) {
        
        singleChar = [typeStr substringWithRange:NSMakeRange(0, 1)];
        
        if ([singleChar isEqualToString:@"1"]) {
            
//            [self.view showResult:ResultViewTypeOK text:@"您的账号为测试账号"];
//            return;
            
        }
        else if ([singleChar isEqualToString:@"2"]){
            
            singleChar = [typeStr substringWithRange:NSMakeRange(2, 1)];
            
            if ([singleChar isEqualToString:@"0"]) {
                //没有权限
                [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
                return;
            }
            
            if ([singleChar isEqualToString:@"2"]) {
                //已完成测评
                [self.view showResult:ResultViewTypeOK text:@"您已做过测评"];
                return;
            }
            
        }
        
    }
    else
    {
        //没有权限
        [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
        return;
    }

    SpecificVC *specific = [[SpecificVC alloc]init];
    specific.hidesBottomBarWhenPushed = YES;
    specific.content1 = @"    人的个性与职业有着密切的关系，不同职业对从业者的人格特征的要求是有差距的，如果通过科学的测试，可以预知自己的个性特征，这有助于选择适合于个人发展的职业。您将要阅读的这个《职业价格自测问卷》，可以帮助您作个性自评，从而获自己的个性特征更适合从事哪方面的工作。";
    specific.content2 = @"    请根据对每一题目的第一印象作答，不必仔细推敲，答案没有好坏、对错之分。\n\n    具体填写方法是，根据自己的情况，如果符合自己的情况则选择A“是”;\n\n如果不符合自己的情况则选择B“否”.";
    specific.testtype = @"霍兰德";
    [self.navigationController pushViewController:specific animated:YES];
}

- (void)pushtoupi{
    //upi
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",info.accountType];
    
    NSString *singleChar = [[NSString alloc]init];
    
    NSInteger length = typeStr.length;
    
    if (length > 3) {
        
        singleChar = [typeStr substringWithRange:NSMakeRange(0, 1)];
        
        if ([singleChar isEqualToString:@"1"]) {
            
//            [self.view showResult:ResultViewTypeOK text:@"您的账号为测试账号"];
            //            return;
            
        }
        else if([singleChar isEqualToString:@"2"])
        {
            //正常账号
            singleChar = [typeStr substringWithRange:NSMakeRange(3, 1)];
            
            if ([singleChar isEqualToString:@"0"]) {
                //没有权限
                [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
                return;
            }
            
            if ([singleChar isEqualToString:@"2"]) {
                //已完成测评
                [self.view showResult:ResultViewTypeOK text:@"您已做过测评"];
                return;
            }

        }
    }
    else
    {
        //没有权限
        [self.view showResult:ResultViewTypeOK text:@"您没有权限做该测评"];
        return;
    }
    
    SpecificVC *specific = [[SpecificVC alloc]init];
    specific.hidesBottomBarWhenPushed = YES;
    specific.content1 = @"    \n\nUPI是University Personality Inventory的简称，是为了早期发现早期治疗有心理问题的学生而编制的大学生精神卫生、人格健康调查表。\n\n";
    specific.content2 = @"    为我国高校应用最早也最为广泛的心理普查量表之一，主要以大学新生为对象，入学时作为心理健康调查而使用。\n\n有利于有心理问题的学生的早期发现，并提供及时的帮助和必要的治疗，同时起到心理卫生的宣传作用，有助于学生了解心理问题的表现，增强心理保健的意识。";
    specific.testtype = @"UPI";
    [self.navigationController pushViewController:specific animated:YES];
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
