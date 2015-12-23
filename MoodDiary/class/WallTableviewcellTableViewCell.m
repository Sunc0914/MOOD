//
//  WallTableviewcellTableViewCell.m
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "WallTableviewcellTableViewCell.h"
#define malecolor [UIColor colorWithRed:102/255.0 green:153/255.0 blue:204/255.0 alpha:1.0];
#define femalecolor [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
#define contentmale [UIColor colorWithRed:210/255.0 green:235/255.0 blue:245/255.0 alpha:1.0];
#define contentfemale [UIColor colorWithRed:253/255.0 green:225/255.0 blue:224/255.0 alpha:1.0];

@implementation WallTableviewcellTableViewCell

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        lineview = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 35)];
        lineview.backgroundColor = [UIColor clearColor];
        lineview.alpha = 0.5f;
        [self addSubview:lineview];
        
        namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
        
        img = [[UIImageView alloc]initWithFrame:CGRectMake(220+10, 10, 30, 25)];
        img.backgroundColor = [UIColor clearColor];
        
        contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(15+10, lineview.frame.origin.y+lineview.frame.size.height, SCREEN_WIDTH-25-20, 40)];
        contentlabel.lineBreakMode = NSLineBreakByCharWrapping;
        contentlabel.numberOfLines = 0;
        contentlabel.font = [UIFont systemFontOfSize:16];
        contentlabel.backgroundColor = [UIColor clearColor];
        
        backview = [[UIView alloc]initWithFrame:CGRectMake(10, lineview.frame.origin.y+lineview.frame.size.height, SCREEN_WIDTH-20, 80)];
        
        
        //
        timelabel = [[UILabel alloc]initWithFrame:CGRectMake(15+10, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 200, 25)];
        timelabel.font = [UIFont systemFontOfSize:14];
        
        _commentbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-120-10, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30)];
        _commentbtn.backgroundColor = [UIColor clearColor];
        [_commentbtn setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:109/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_commentbtn setTitleColor:[UIColor colorWithRed:43/255.0 green:169/255.0 blue:111/255.0 alpha:1.0] forState:UIControlStateSelected];
        [_commentbtn setImage:[UIImage imageNamed:@"comment_none"] forState:UIControlStateNormal];
        [_commentbtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateSelected];
        [_commentbtn setImageEdgeInsets:UIEdgeInsetsMake(7,15,5,17)];
        
        _favouritebtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-60, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30)];
        _favouritebtn.backgroundColor = [UIColor clearColor];
        [_favouritebtn setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:109/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_favouritebtn setTitleColor:[UIColor colorWithRed:43/255.0 green:169/255.0 blue:111/255.0 alpha:1.0] forState:UIControlStateSelected];;
        [_favouritebtn setImage:[UIImage imageNamed:@"favourite_none"] forState:UIControlStateNormal];
        [_favouritebtn setImage:[UIImage imageNamed:@"favourite"] forState:UIControlStateSelected];
        [_favouritebtn setImageEdgeInsets:UIEdgeInsetsMake(5,17,5,17)];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-5, SCREEN_WIDTH-20, 20)];
        
        [self addSubview:line];
        
        commentline = [[UIView alloc]init];
        commentline.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        commentview  =[[UIView alloc]initWithFrame:CGRectMake(20+10, _commentbtn.frame.origin.y+_commentbtn.frame.size.height+10, SCREEN_WIDTH-30-20, 16)];
        
        sexbackview = [[UIImageView alloc]init];
        sexbackview.backgroundColor = [UIColor clearColor];
        
        [self addSubview:backview];
        [lineview addSubview:timelabel];
        [self addSubview:_commentbtn];
        [self addSubview:_favouritebtn];
        
        
        [lineview addSubview:namelabel];
        [lineview addSubview:img];
        
        [backview addSubview:sexbackview];
        [self addSubview:contentlabel];
        [self addSubview:commentview];
        [self addSubview:commentline];
        
    }
    return self;
}

- (void)setcontent:(NSDictionary *)sender commentarr:(NSMutableArray *)arr height:(CGFloat )height more:(BOOL)more number:(NSInteger) index  nowDate:(NSString *)nowDateStr{
    
    NSDictionary *accountdic = [NSDictionary dictionaryWithDictionary:[sender objectForKeyedSubscript:@"account"]];
    
    img.frame = CGRectMake(10, 4, 30, 30);
    
    //昵称
    NSString *nickname = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"anonymity"]];
    
    if([nickname isEqualToString:@"<null>"])
    {
        nickname = @"咸蛋超人";
    }
    
    CGSize namesize = [self maxlabeisize:CGSizeMake(999, 25) fontsize:14 text:nickname];
    namelabel.frame = CGRectMake(img.frame.origin.x+5+img.frame.size.width, 5, namesize.width, 25);
    namelabel.font = [UIFont systemFontOfSize:14];
    namelabel.text = nickname;
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.textColor = [UIColor whiteColor];
    
    //内容
    NSString *content = [sender objectForKey:@"content"];
    CGSize contentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:16 text:content];
    contentlabel.frame = CGRectMake(10+10, lineview.frame.origin.y+lineview.frame.size.height+15, SCREEN_WIDTH-40, contentsize.height);
    contentlabel.font = [UIFont systemFontOfSize:16];
    contentlabel.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    contentlabel.text = content;
    contentlabel.backgroundColor = [UIColor clearColor];
    
    //背景
    backview.frame = CGRectMake(10, lineview.frame.origin.y+lineview.frame.size.height, SCREEN_WIDTH-20, contentsize.height+40+15);
    
    //性别符号高度
    CGFloat sexheight = backview.frame.size.height*4/5;
    
    //性别
    NSString *sex;
    sex = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"sex"]];
    if ([sex isEqualToString:@"1"]) {
        img.image = [UIImage imageNamed:@"male"];
        lineview.backgroundColor = malecolor;
        backview.backgroundColor = contentmale;
        sexbackview.image = [UIImage imageNamed:@"male_back"];
        sexbackview.frame = CGRectMake(0, backview.frame.size.height-sexheight, sexheight/1.5f, sexheight);
    }
    else if ([sex isEqualToString:@"0"]){
        img.image = [UIImage imageNamed:@"female"];
        lineview.backgroundColor = femalecolor;
        backview.backgroundColor = contentfemale;
        sexbackview.image = [UIImage imageNamed:@"female_back"];
        sexbackview.frame = CGRectMake(0, backview.frame.size.height-sexheight, sexheight*2/3, sexheight);
    }
    else
    {
        img.image = [UIImage imageNamed:@"female"];
        lineview.backgroundColor = femalecolor;
        backview.backgroundColor = contentfemale;
        sexbackview.image = [UIImage imageNamed:@"female_back"];
        sexbackview.frame = CGRectMake(0, backview.frame.size.height-sexheight, sexheight*2/3, sexheight);
    }
    
    //时间
    timelabel.text = [self timeCaculation:[sender objectForKey:@"date"] publishDate:nowDateStr];
    timelabel.frame = CGRectMake(SCREEN_WIDTH-15-80-10, 5, 80, 25);
    timelabel.font = [UIFont systemFontOfSize:13];
    timelabel.backgroundColor = [UIColor clearColor];
    timelabel.textAlignment = NSTextAlignmentRight;
    timelabel.textColor = [UIColor whiteColor];
    
    //评论
    if ([[sender objectForKey:@"commentCount"] intValue] == 0) {
        _commentbtn.selected = NO;
    }
    else
    {
        _commentbtn.selected = YES;
    }
    
    [_commentbtn setTitle:[NSString stringWithFormat:@"%@",[sender objectForKey:@"commentCount"]] forState:UIControlStateNormal];
    _commentbtn.frame = CGRectMake(SCREEN_WIDTH-10-120-10, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30);
    
    //点赞
    if ([[sender objectForKey:@"favourCount"] intValue] == 0) {
        _favouritebtn.selected = NO;
    }
    else{
        _favouritebtn.selected = YES;
    }
    
    [_favouritebtn setTitle:[NSString stringWithFormat:@"%@",[sender objectForKey:@"favourCount"]] forState:UIControlStateNormal];
    _favouritebtn.frame = CGRectMake(SCREEN_WIDTH-15-60, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30);
    
    //评论
    if (arr == nil) {
        //没有评论
        [commentview removeFromSuperview];
        [commentline removeFromSuperview];
//        line.frame = CGRectMake(10, _commentbtn.frame.origin.y+_commentbtn.frame.size.height+5, SCREEN_WIDTH-20, 20);
    }
    else
    {
        //有评论
        
        for (UIView *view in commentview.subviews) {
            [view removeFromSuperview];
        }
        
        commentview.frame = CGRectMake(10, _commentbtn.frame.origin.y+_commentbtn.frame.size.height+5, SCREEN_WIDTH-20, height);
        
        CGFloat btnheight = 0;
        for (int i= 0; i<arr.count; i++) {
            NSDictionary *commentdic = [arr objectAtIndex:i];
            
            NSString *content = [commentdic objectForKey:@"content"];
//            NSString *date = [commentdic objectForKey:@"date"];
            
            CGSize commentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:14 text:content];
            
            UILabel *contentlb = [[UILabel alloc]initWithFrame:CGRectMake(10, btnheight, SCREEN_WIDTH-40, commentsize.height+8)];
            contentlb.text = content;
            contentlb.font = [UIFont systemFontOfSize:14];
            contentlb.textAlignment = NSTextAlignmentLeft;
            contentlb.textColor = [UIColor darkGrayColor];
            contentlb.textAlignment = NSTextAlignmentLeft;
            contentlb.numberOfLines=0;
            contentlb.lineBreakMode = NSLineBreakByWordWrapping;
            contentlb.backgroundColor = [UIColor clearColor];
            [commentview addSubview:contentlb];
            
//            UILabel *datelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, contentlb.frame.origin.y+contentlb.frame.size.height-2, SCREEN_WIDTH-30, 12)];
//            datelabel.text = date;
//            datelabel.font = [UIFont systemFontOfSize:12];
//            datelabel.textAlignment = NSTextAlignmentLeft;
//            datelabel.textColor = [UIColor darkGrayColor];
//            datelabel.textAlignment = NSTextAlignmentLeft;
//            [commentview addSubview:datelabel];
            
#pragma mark - 此处修改评论间距
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnheight, SCREEN_WIDTH-30, commentsize.height+8)];
#pragma mark - 此处修改评论间距
            btnheight = btnheight+commentsize.height+8.0f;
            btn.tag = i + index*100;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
            [commentview addSubview:btn];
        }
        
        [self addSubview:commentview];
        
        commentline.frame = CGRectMake(20, _commentbtn.frame.origin.y+_commentbtn.frame.size.height+4, SCREEN_WIDTH-30, 1);
#pragma mark - 此处修改评论间距
//        line.frame = CGRectMake(10, commentview.frame.origin.y+commentview.frame.size.height, SCREEN_WIDTH-20, 20);
    }
    
    
}

- (NSString *)timeCaculation:(NSString *)nowTime publishDate:(NSString *)beforDate{
    
    NSString *timeStr = [[NSString alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *nowDate = [dateFormatter dateFromString:nowTime];
    
    NSDate *endDate = [dateFormatter dateFromString:beforDate];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:nowDate toDate:endDate options:0];
    
//    NSLog(@"time-----%@",[NSString stringWithFormat:@"距离活动时间还有:%ld年%ld月%ld天%ld时%ld分%ld秒",(long)comps.year,(long)comps.month,(long)comps.day,(long)comps.hour,(long)comps.minute,(long)comps.second]);
    
    if (comps.year>0) {
        timeStr = [NSString stringWithFormat:@"%ld年前",(long)comps.year];
    }
    else if (comps.month>0){
        timeStr = [NSString stringWithFormat:@"%ld月前",(long)comps.month];
    }
    else if (comps.day>=15){
        timeStr = @"半个月前";
    }
    else if (comps.day>0) {
        timeStr = [NSString stringWithFormat:@"%ld天前",(long)comps.day];
    }
    else if (comps.hour>0) {
        timeStr = [NSString stringWithFormat:@"%ld小时前",(long)comps.hour];
    }
    else if (comps.minute>=30){
        timeStr = @"半小时前";
    }
    else if (comps.minute>0){
        timeStr = [NSString stringWithFormat:@"%ld分钟前",(long)comps.minute];
    }
    else
    {
        timeStr = @"刚刚";
    }
    
    return timeStr;
}

- (void)btnclicked:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(subcommentbtnclicked:)]) {
        [_delegate subcommentbtnclicked:sender];
    }
}

//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:labelsize lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
