//
//  PersonalInfoVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "PersonalInfoVC.h"

#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SDImageCache.h"

@interface PersonalInfoVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
{
    UIView *sexBackView;
    
    UIPickerView *sexPicker;
}

@property (nonatomic) CGFloat height;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *usersex;
@property (nonatomic) CGFloat keboardheight;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _height = 60;
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    _nickname = [NSString stringWithFormat:@"%@",info.nickname];
    self.title = @"账户设置";
    
    if (info.sex == nil) {
        _usersex = nil;
    }
    else if ([info.sex isEqualToString:@"1"])
    {
        _usersex = @"男";
    }
    else{
        _usersex = @"女";
    }
    
    [self initpersonaltable];
    [self initKeyboardNotification];
    [self initSexPickerModel];
}

- (void)initpersonaltable{
    persontable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    persontable.backgroundColor = [UIColor clearColor];
    persontable.delegate = self;
    persontable.dataSource = self;
    
    persontable.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:persontable];
}

-(void)initSexPickerModel
{
    sexBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
    sexBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    sexBackView.tag = 0;
    [self.view addSubview:sexBackView];
    
    sexPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    sexPicker.backgroundColor = [UIColor clearColor];
    [sexBackView addSubview:sexPicker];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 5, 80, 30)];
    sureBt.tag = 2;//跟row保持一致
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 5;
    sureBt.layer.borderWidth = 0;
    sureBt.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
    [sureBt setTitle:@"完成" forState:UIControlStateNormal];
    [sureBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBt addTarget:self action:@selector(sureBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexBackView addSubview:sureBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:237/255.0 alpha:1.0];
    [sexBackView addSubview:line];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [sexBackView addSubview:line];
}

- (void)sureBtClicked:(UIButton *)sender{
    NSInteger index = [sexPicker selectedRowInComponent:0];
    
    [AppWebService changenick:[NSString stringWithFormat:@"%ld",(long)index] type:@"sex" success:^(id result) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeOK text:@"性别修改成功"];
        
        UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        info.sex = [NSString stringWithFormat:@"%ld",(long)index];
        
        [NSUserDefaults setUserObject:info forKey:USER_STOKRN_KEY];
        
        if (index == 0) {
            _usersex = @"女";
        }
        else if (index == 1){
            _usersex = @"男";
        }
        
        [self inView:sexBackView];
        
        [persontable reloadData];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];

    
}

- (void)comfirmbtnpress:(UIButton *)sender{
    //修改昵称
    [self hideview:changenick height:SCREEN_HEIGHT];
    [changenick resignFirstResponder];
    
    [self.view showProgress:YES];
    [AppWebService changenick:nicknamefield.text type:@"nickname" success:^(id result) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeOK text:@"昵称修改成功"];
        
        UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        info.nickname = [NSString stringWithFormat:@"%@",nicknamefield.text];
        
        _nickname = nicknamefield.text;
        
        [NSUserDefaults setUserObject:info forKey:USER_STOKRN_KEY];
        
        [persontable reloadData];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void)picbtnpress:(UIButton *)sender{
    [self saveuserpic:[UIImage imageNamed:[NSString stringWithFormat:@"pic%ld",(long)sender.tag+1]]];
}

- (void)systembtnpress:(UIButton *)sender{
    [self userPhotoLibrary];
}

- (void)cancelbtnpress:(UIButton *)sender{
    [self hideview:changepicback height:SCREEN_HEIGHT];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self inView:sexBackView];
    [self hideview:changepicback height:SCREEN_HEIGHT];
    [self hideview:changenick height:SCREEN_HEIGHT];
    persontable.userInteractionEnabled = YES;
    [nicknamefield resignFirstResponder];
}

- (void)saveuserpic:(UIImage *)myImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
    [UIImagePNGRepresentation(myImage)writeToFile: filePath  atomically:YES];
    
    [persontable reloadData];
}

- (void)uploadimg:(UIImage *)img{
    
    NSData *data = [[NSData alloc]init];
    
    if (UIImagePNGRepresentation(img) == nil) {
        
        data = UIImageJPEGRepresentation(img, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(img);
    }
    
//    NSString *filewholename=[NSString stringWithFormat:@"%@.png",@"userpic"];
//    
//    [self.view showProgress:YES text:@"上传图像中..."];
//    [AppWebService submitFile:data FileName:filewholename success:^(id result) {
//        [self.view showProgress:NO];
//        [self.view showResult:ResultViewTypeOK text:@"头像上传成功"];
//        
//        [self saveuserpic:img];
//        
//    } failed:^(NSError *error) {
//        [self.view showProgress:NO];
//        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
//        
//    }];
    [self saveuserpic:img];
    [self hideview:changepicback height:SCREEN_HEIGHT];
}

- (UIImage *)loaduserimage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

-(void)popView:(UIView *)sender
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    sender.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    sender.tag = 1;
    persontable.userInteractionEnabled = NO;
    //    [self ViewAnimation:self.pickerView willHidden:NO];
}

-(void)inView:(UIView *)sender
{
    //    [self ViewAnimation:self.pickerView willHidden:YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    sender.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    sender.tag = 0;
    persontable.userInteractionEnabled = YES;
}

- (void)animationFinished{
    
}

#pragma mark - KeyboardNotification
-(void) keyboardWillShow:(NSNotification *) note
{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    _keboardheight = kbSize.height;
    
    [self showview:changenick height:(SCREEN_HEIGHT - _keboardheight-changenick.frame.size.height)];
    persontable.userInteractionEnabled = NO;
    
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _height;
}

#pragma mark - uitableviewdelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    }
    
    for (UIView *V in cell.contentView.subviews) {
        [V removeFromSuperview];
    }
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, _height-12, _height-12)];
    imgview.layer.cornerRadius = imgview.bounds.size.height/2;
    imgview.layer.masksToBounds = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 200, _height-4)];

    
    if (indexPath.row == 0) {
        imgview.backgroundColor = [UIColor clearColor];
        if ([self loaduserimage]==nil) {
            imgview.image = [UIImage imageNamed:@"pic1"];
        }
        else
        {
            imgview.image = [self loaduserimage];
        }
        
        [cell.contentView addSubview:imgview];
    }
    else if (indexPath.row == 1){
        title.text = @"昵    称：";
        
        if (_nickname == nil) {
            
        }
        else{
            title.text = [NSString stringWithFormat:@"昵    称： %@",_nickname];
        }
        
        [cell.contentView addSubview:title];
    }
    
    else if(indexPath.row == 2){
        title.text = @"性    别：";
        
        if (_usersex == nil) {
            
        }
        else{
            title.text = [NSString stringWithFormat:@"性    别： %@",_usersex];
        }
        
        [cell.contentView addSubview:title];
    }
    else if (indexPath.row == 3){
        float cache = [[SDImageCache sharedImageCache] getSize];
        
        cache = cache/1024.0/1024.0;
        
        title.text = @"清除缓存：";
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 2, 80, _height-4)];
        content.textAlignment = NSTextAlignmentRight;
        content.backgroundColor = [UIColor clearColor];
        content.text = [NSString stringWithFormat:@"%.2f M",cache];
        content.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:content];
        cell.accessoryType = UITableViewCellEditingStyleNone;
    }
    
    [cell.contentView  addSubview:imgview];
    [cell.contentView addSubview:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        //修改头像
        changepicback = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 320)];
        changepicback.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        
        float imgwidth = 60;
        float width = (SCREEN_WIDTH-4*imgwidth-20-20)/3;
        
        
        for (int i = 0 ; i<8; i++) {
            UIButton *imgbtn = [[UIButton alloc]initWithFrame:CGRectMake(20+i%4*(width+imgwidth), 20+i/4*(imgwidth+width), imgwidth, imgwidth)];
            imgbtn.backgroundColor = [UIColor clearColor];
            imgbtn.tag = i;
            imgbtn.layer.masksToBounds = YES;
            imgbtn.layer.cornerRadius = imgbtn.bounds.size.height/2;
            [imgbtn addTarget:self action:@selector(picbtnpress:) forControlEvents:UIControlEventTouchUpInside];
            [imgbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"pic%d",i+1]] forState:UIControlStateNormal];
            
            [changepicback addSubview:imgbtn];
        }
        
        UIButton *systemphoto = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 40)];
        [systemphoto setTitle:@"从相册中选取" forState:UIControlStateNormal];
        [systemphoto addTarget:self action:@selector(systembtnpress:) forControlEvents:UIControlEventTouchUpInside];
        systemphoto.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
        systemphoto.layer.cornerRadius = 5;
        systemphoto.layer.masksToBounds = YES;
        [changepicback addSubview:systemphoto];
        
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(20, 260, SCREEN_WIDTH-40, 40)];
        [cancel setTitle:@"取      消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelbtnpress:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
        cancel.layer.cornerRadius = 5;
        cancel.layer.masksToBounds = YES;
        [changepicback addSubview:cancel];
        
        [self.view addSubview:changepicback];
        
        [self showview:changepicback height:(SCREEN_HEIGHT - changepicback.frame.size.height)];
        persontable.userInteractionEnabled = NO;
        
    }
    else if(indexPath.row == 1){
        
        //修改昵称
        changenick = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 130)];
        changenick.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        
        nicknamefield = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 50)];
        nicknamefield.delegate = self;
        nicknamefield.placeholder = @"请输入新昵称";
        
        //在textfield框内添加空白
        UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 10, nicknamefield.frame.size.height)];
        leftview.backgroundColor = [UIColor clearColor];
        [nicknamefield setLeftView:leftview];
        nicknamefield.leftViewMode = UITextFieldViewModeAlways;
        
        nicknamefield.layer.borderWidth = 1;
        nicknamefield.layer.cornerRadius = 5;
        nicknamefield.layer.borderColor = [UIColor whiteColor].CGColor;
        nicknamefield.layer.masksToBounds = YES;
        
        [changenick addSubview:nicknamefield];
        
        UIButton *comfirmbtn  = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH-40, 50)];
        [comfirmbtn setTitle:@"修      改" forState:UIControlStateNormal];
        [comfirmbtn addTarget:self action:@selector(comfirmbtnpress:) forControlEvents:UIControlEventTouchUpInside];
        comfirmbtn.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
        comfirmbtn.layer.cornerRadius = 5;
        comfirmbtn.layer.masksToBounds = YES;
        [changenick addSubview:comfirmbtn];
        
        [self.view addSubview:changenick];
        
        [nicknamefield becomeFirstResponder];
        
    }
    
    else if (indexPath.row == 2){
        [self popView:sexBackView];
    }
    else if (indexPath.row == 3){
        [[SDImageCache sharedImageCache] clearDisk];
        [persontable reloadData];
    }
}

#pragma pickerviewdatasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark-pickerviewdelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"女";
    }
    return @"男";
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return 40;
}

#pragma mark - uitextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -------

-(void)useCamera
{
    // 拍照
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
    
    
}

-(void)userPhotoLibrary
{
    // 从相册中选取
    
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
    
    
    
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //这里得到的就是剪裁后的头像editedImage
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
    //
    [self uploadimg:editedImage];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==400) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
    }
    
}


- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        [self useCamera];
    } else if (buttonIndex == 1) {
        // 从相册中选取
        [self userPhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 200.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [UIColor colorWithRed:52/255.0 green:184/255.0 blue:111/255.0 alpha:1.0].CGColor;
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
    }
    return _portraitImageView;
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
