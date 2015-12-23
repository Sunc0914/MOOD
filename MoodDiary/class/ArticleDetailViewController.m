    //
//  ArticleDetailViewController.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/4.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "DataModel.h"
#import "ArticleDetail.h"
#import "UMSocial.h"
@interface ArticleDetailViewController (){
    UIWebView *webView;
    NSInteger lastPosition;
    UIView *buttonView;
    UIButton *likeButton;
    UIButton *shareButton;
    UIButton *collectButton;
    BOOL buttonFlag;
    DataModel *_dataModel;
}

@end

@implementation ArticleDetailViewController
@synthesize frameheight;
@synthesize digest;
@synthesize likenumelabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataModel = [[DataModel alloc]init];
    [self initWebView];
    
    socialData = [[UMSocialData alloc] initWithIdentifier:[NSString stringWithFormat:@"%@%@",_url,_thumbnailURL]];
    socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
    
}

- (void)initWebView{
    
    self.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, frameheight)];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    webView.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    buttonFlag = NO;
}

- (void)setButton{
    if (buttonFlag == 0) {
        buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 140 -5, frameheight+upsideheight-50, 140, 40)];
        buttonView.backgroundColor = [UIColor clearColor];
        
        likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, 38, 38)];
        
        [likeButton setImage:[UIImage imageNamed:@"newunlike"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"newlike"] forState:UIControlStateSelected];

        [likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:likeButton];
        
        likenumelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 14, 20, 20)];
        [likeButton addSubview:likenumelabel];
        likenumelabel.adjustsFontSizeToFitWidth = YES;
        likenumelabel.backgroundColor = [UIColor clearColor];
        likenumelabel.textColor = [UIColor whiteColor];
        likenumelabel.textAlignment = NSTextAlignmentCenter;
        
        
        [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
            // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
            NSInteger likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
            likenumelabel.text = [NSString stringWithFormat:@"%ld",(long)likeNumber];
            NSLog(@"likeNum is %ld",(long)likeNumber);
        }];
        
        islike = socialData.isLike;
        
        if (islike) {
            likeButton.selected = YES;
        }
        else{
            likeButton.selected = NO;
        }
        
        
        NSLog(@"collectButtonTapped");
        ArticleDetail *articlDetail = [[ArticleDetail alloc]init];
        articlDetail.thumbnailURL = _thumbnailURL;
        articlDetail.titleString = _titleString;
        articlDetail.dateString = _dateString;
        articlDetail.articleURL = _url;
        articlDetail.IDString = _IDString;
        articlDetail.digest = digest;
        
        BOOL flag;
        flag = [_dataModel addObject:articlDetail];
        
        collectButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 40, 40)];
        [collectButton setImage:[UIImage imageNamed:@"newuncollect"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"newcollect"] forState:UIControlStateSelected];
        [collectButton addTarget:self action:@selector(collectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if (flag == 1) {
            //未收藏
            collectButton.selected = NO;
        }
        else{
            collectButton.selected = YES;
        }
        [buttonView addSubview:collectButton];
        
        flag = [_dataModel addObject:articlDetail];
        
        
        shareButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 40, 40)];
        [shareButton setImage:[UIImage imageNamed:@"newshare"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"newunshare"] forState:UIControlStateSelected];
        [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:shareButton];
        
        [self.view addSubview:buttonView];
    }else{
        [buttonView removeFromSuperview];
    }
    buttonFlag = !buttonFlag;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPosition = webView.scrollView.contentOffset.y;
    if (currentPosition - lastPosition >25) {
        if (buttonFlag == 1) {
            [self setButton];
        }
        lastPosition = currentPosition;
    }else if( lastPosition - currentPosition >25 ){
        if (buttonFlag == 0) {
            [self setButton];
        }
        lastPosition = currentPosition;
    }
}

#pragma mark - ButtonTapped
- (void)likeButtonTapped:(id)sender{
    
    //把你的文章或者音乐的标识，作为@"identifier"
    
    islike = socialData.isLike;
    
    if (islike) {
        likeButton.selected = NO;
    }
    else{
        likeButton.selected = YES;
    }
    
    [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
        //获取请求结果
        NSLog(@"resposne is %@",response);
    }];
    
    [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
        // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
        NSInteger likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
        likenumelabel.text = [NSString stringWithFormat:@"%ld",(long)likeNumber];
        NSLog(@"likeNum is %ld",(long)likeNumber);
    }];
    
    NSLog(@"likeButtonTapped");
}

- (void)collectButtonTapped:(id)sender{
    
    NSLog(@"collectButtonTapped");
    ArticleDetail *articlDetail = [[ArticleDetail alloc]init];
    articlDetail.thumbnailURL = _thumbnailURL;
    articlDetail.titleString = _titleString;
    articlDetail.dateString = _dateString;
    articlDetail.articleURL = _url;
    articlDetail.IDString = _IDString;
    articlDetail.digest = digest;
    
    BOOL flag;
    flag = [_dataModel addObject:articlDetail];
    
    if (flag == 1) {
        collectButton.selected = YES;
        [self.view showResult:ResultViewTypeOK text:@"收藏成功"];
        NSLog(@"已收藏");
    }else{
        NSLog(@"已取消收藏");
        collectButton.selected = NO;
        [self.view showResult:ResultViewTypeOK text:@"取消收藏"];
    }
    
    [_dataModel saveArticles];
}

- (void)shareButtonTapped:(id)sender{
    NSArray *sharearr = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,nil];

    NSData * data = [NSData dataWithContentsOfURL:_thumbnailURL];
    
    //设置点击分享内容跳转链接qq
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@",_url];
    
    //设置点击分享内容跳转链接qq空间
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@",_url];
    
    //设置分享标题qq
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"%@",_titleString];
    
    //设置分享标题qq空间
    [UMSocialData defaultData].extConfig.qzoneData.title = [NSString stringWithFormat:@"%@",_titleString];
    
    //设置分享平台
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:[NSString stringWithFormat:@"%@  (分享自心情日记iOS客户端) %@",digest,_url]
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:sharearr
                                       delegate:self];
    
    //设置微信和朋友圈跳转链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",_url];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",_url];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"%@",_titleString];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@",_titleString];
    

            [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"3214415900"}];
    

            [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"2091897557"] completion:nil];

}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据responseCode得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [self.view showResult:ResultViewTypeOK text:[NSString stringWithFormat:@"分享成功"]];
    }
    else{
        [self.view showResult:ResultViewTypeFaild text:@"分享失败，请检查分享内容或重新授权"];
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
