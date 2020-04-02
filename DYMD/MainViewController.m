//
//  MainViewController.m
//  DYMD
//
//  Created by 蒋华阳 on 14-10-1.
//  Copyright (c) 2014年 蒋华阳. All rights reserved.
//

#import "MainViewController.h"
#import "RightView.h"
#import "Message.h"
#import "RightView.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tipName,type=_type;
@synthesize dic = _dic;
@synthesize zhanting;
@synthesize subType=_subType;
@synthesize zhantingMain;
@synthesize zhanXiangTip,swtichBtn;
@synthesize playBtn;
@synthesize playBtn0;
@synthesize swtichlab1,swtichlab2;
@synthesize sliderA=_sliderA;
@synthesize addressDic;
@synthesize message;
@synthesize TCpaddress;
-(IBAction)changeZhanTing:(UIButton*)sender{
    self.type = (int)sender.tag;
    [self ZhanTingInfo];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
- (void)ZhanTingInfo{
    
    [self.swtichlab1 setHidden:YES];
    [self.swtichlab2 setHidden:YES];
    [self.swtichBtn setHidden:YES];
    [self.playBtn setHidden:YES];
    [self.playBtn0 setHidden:YES];
    [self.sliderA setHidden:YES];
    [self.powerOnBtn setHidden:YES];
    [self.powerOffBtn setHidden:YES];
    //[self.zhanting setImage:[UIImage imageNamed:[NSString stringWithFormat:@"_【展厅%d】.png",self.type]]];
    self.rightView =  (RightView*)[self.view viewWithTag:100];
    [self.rightView setInfos:[self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]]];
    //[self.zhantingMain setImage:[UIImage imageNamed:[NSString stringWithFormat:@"中间-%d.png",self.type]]];
    [self.zhanXiangTip setImage:[UIImage imageNamed:[NSString stringWithFormat:@"展项%d.png",self.subType]]];
    //[self.swtichBtn setImage:[UIImage imageNamed:@"组-11-off.png"] forState:UIControlStateNormal];
    
    NSLog(@"%@",[NSString stringWithFormat:@"展厅%d",self.type]);
    NSDictionary *dic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSLog(@"%d",self.subType-1);
    NSDictionary *infoDic =[dic objectForKey:[NSString stringWithFormat:@"展项%d",self.subType]];
    NSLog(@"%@",infoDic);
    NSArray *compArr = [infoDic objectForKey:@"computer"];
    NSArray *projArr = [infoDic objectForKey:@"projector"];
    for (int i=21; i<=24; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"computer-%d.png",i-20]] forState:UIControlStateNormal];
        if (compArr.count+20>=i) {
            [btn setHidden:NO];
        }else{
            [btn setHidden:YES];
        }
    }
    for (int i=31; i<=38; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"projector-%d.png",i-30]] forState:UIControlStateNormal];
        if (projArr.count+30>=i) {
            [btn setHidden:NO];
        }else{
            [btn setHidden:YES];
        }
    }
    
    //volume = 0;
    playFlag = 0;
    switchFlag = 0;
    diannaoType = 0;
    [self initMessage];
}
- (void)setSubType:(int)subType{
    _subType = subType;
    [self ZhanTingInfo];
}
- (void)setRightView{
    RightView *rightView = [[[NSBundle mainBundle] loadNibNamed:@"RightView" owner:self options:nil] objectAtIndex:0];
    CGRect rect = rightView.frame;
    rect.origin.x = 840;
    rect.origin.y = 158;
    [rightView setFrame:rect];
    [rightView setTag:100];
    
    [rightView setInfos:[self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]]];
    rightView.controller = self;
    [self.view addSubview:rightView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"conf.plist" ofType:nil]];
    //self.addressDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
    [self setRightView];
    _type = (int)[[self.dic objectForKey:@"currentSelect"] integerValue];
    _subType = 1;
    allSwitch = 0;
    [self ZhanTingInfo];
    
    self.message = [[Message alloc] initWithAddress:@"192.168.0.6" port:6000];
    
    //UIImageView * imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound.png"]];
    //imageView.frame=CGRectMake(610, 630, 20, 20);
    //[self.view addSubview:imageView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)touchDown:(UIButton *)sender {
    
    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 50:
            [btn setImage:[UIImage imageNamed:@"下面开关键on 变.png"] forState:UIControlStateNormal];
            break;
        case 51:
            [btn setImage:[UIImage imageNamed:@"下面开关键off 变.png"] forState:UIControlStateNormal];
        default:
            break;
    }
}

-(IBAction)swtichPress:(UIButton*)sender{
    
    //    switchFlag = (switchFlag+1)%2;
    
    NSString *command = [NSString stringWithFormat:@"/%@/power",self.TCpaddress];
    //    if (switchFlag==1) {
    //        [self.swtichBtn setImage:[UIImage imageNamed:@"组-11-on.png"] forState:UIControlStateNormal];
    //        [self.message sendMessage:command Float:1.0000];
    //    }else{
    //        [self.swtichBtn setImage:[UIImage imageNamed:@"组-11-off.png"] forState:UIControlStateNormal];
    //        [self.message sendMessage:command Float:0.0000];
    //
    //    }
    
    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 50:
            [btn setImage:[UIImage imageNamed:@"下面开关键on.png"] forState:UIControlStateNormal];
            [self.message sendMessage:command Float:1.0000];
            command = [command stringByAppendingString:@",on"];
            break;
        case 51:
            [btn setImage:[UIImage imageNamed:@"下面开关键off.png"] forState:UIControlStateNormal];
            [self.message sendMessage:command Float:0.0000];
            command = [command stringByAppendingString:@",off"];
        default:
            break;
    }
    NSLog(@"%@",command);
}
-(IBAction)playAction:(UIButton*)sender{
    //    playFlag = (playFlag+1)%2;
    /*
     NSString *command = [NSString stringWithFormat:@"/%@/arena/play",self.TCpaddress];
     NSLog(@"%@",command);
     //    if (playFlag==1) {
     //        [self.playBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
     //        [self.message sendMessage:command Float:1.0000];
     //    }else{
     //        [self.playBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
     //        [self.message sendMessage:command Float:0.0000];
     //    }
     
     switch ([sender tag]) {
     case 60:
     [self.message sendMessage:command Float:1.0000];
     break;
     case 61:
     [self.message sendMessage:command Float:0.0000];
     default:
     break;
     }*/
    
}
-(IBAction)projectPressed:(UIButton*)sender{
    
}
-(IBAction)videoPressed:(UIButton*)sender{
    
}
-(IBAction)showLeftView:(UIButton*)sender{
    //    for (int index = 1; index<=12; index++) {
    //         [[self.view viewWithTag:index] setHidden:![self.view viewWithTag:index].hidden];
    //    }
}
-(BOOL)isHideVolumeBtn{
    /*
     NSDictionary *dic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
     NSLog(@"%d",self.subType-1);
     NSDictionary *infoDic =[dic objectForKey:[NSString stringWithFormat:@"展项%d",self.subType]];
     NSLog(@"%@",infoDic);
     NSArray *compArr = [infoDic objectForKey:@"comp"];
     return [[compArr objectAtIndex:comType-21] componentsSeparatedByString:@";"].count;*/
    return true;
}
-(NSString*)getAddress{
    NSDictionary *dic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSLog(@"%d",self.subType-1);
    NSDictionary *infoDic =[dic objectForKey:[NSString stringWithFormat:@"展项%d",self.subType]];
    NSLog(@"%@",infoDic);
    if (comType>0) {
        NSArray *compArr = [infoDic objectForKey:@"computer"];
        return [[[compArr objectAtIndex:comType-21] componentsSeparatedByString:@";"] objectAtIndex:0];
    }else if(proType>0) {
        NSArray *projArr = [infoDic objectForKey:@"projector"];
        return [projArr objectAtIndex:proType-31];
        
    }else{
        return nil;
    }
    
}
-(IBAction)showRightView:(UIButton*)sender{
    self.rightView.hidden = ! self.rightView.hidden;
}
-(void)initMessage{
    //    NSString *address = [self.addressDic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    
}
//声音调节
-(void)sendVolumeCommomd{
    //  /layer1/clip1/connect
    //[self.message sendMessage:@"/layer1/audio/volume/values" Float:volume];
}
// 播放影片
-(void)sendPlayCommomd{
    //
    //[self.message sendMessage:@"/layer1/clip1/connect" Int:playFlag];
}

-(void)sendMessage:(int)type{
    
}

-(void)changeComIcon{
    for (int i=21; i<=24; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i];
        if(i==comType){
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"computer-%d-select.png",i-20]] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"computer-%d.png",i-20]] forState:UIControlStateNormal];
        }
    }
    for (int i=31; i<=38; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"projector-%d.png",i-30]] forState:UIControlStateNormal];
    }
    [self.swtichlab1 setHidden:NO];
    [self.swtichlab2 setHidden:NO];
    [self.swtichBtn setHidden:NO];
    
    [self.playBtn setHidden:YES];
    [self.playBtn0 setHidden:YES];
    [self.sliderA setHidden:YES];
    /*
     if ([self isHideVolumeBtn]>1) {
     }else{
     [self.playBtn setHidden:NO];
     [self.playBtn0 setHidden:NO];
     [self.sliderA setHidden:NO];
     }*/
    
    self.TCpaddress = [self getAddress];//@"192.168.199.193";//
    
}
-(void)changeProIcon{
    
    for (int i=31; i<=38; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i];
        if(i==proType){
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"projector-%d-select.png",i-30]] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"projector-%d.png",i-30]] forState:UIControlStateNormal];
        }
    }
    for (int i=21; i<=24; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"computer-%d.png",i-20]] forState:UIControlStateNormal];
    }
    
    [self.swtichlab1 setHidden:YES];
    [self.swtichlab2 setHidden:YES];
    [self.swtichBtn setHidden:YES];
    [self.playBtn setHidden:YES];
    [self.playBtn0 setHidden:YES];
    [self.sliderA setHidden:YES];
    self.TCpaddress = [self getAddress];
    
}

-(void)changeSize:(int)j
{
    //    UIButton * btn=(UIButton*)[self.view viewWithTag:j];
    //    CGSize size=btn.frame.size;
    //    size.width*=1.1;
    //    size.height*=1.1;
    //    [btn setFrame:CGRectMake(btn.center.x-size.width/2, btn.center.y-size.height/2, size.width, size.height)];
}

-(IBAction)compu:(UIButton*)sender{
    
    comType = (int)sender.tag;
    proType = 0;
    [self.powerOnBtn setHidden:FALSE];
    [self.powerOffBtn setHidden:FALSE];
    
    //    [self changeSize:comType];
    
    [self changeComIcon];
}
-(IBAction)pro:(UIButton*)sender{
    proType = (int)sender.tag;
    comType = 0;
    [self.powerOnBtn setHidden:FALSE];
    [self.powerOffBtn setHidden:FALSE];
    
    //    [self changeSize:proType];
    
    [self changeProIcon];
}
-(IBAction)Allswitch:(UIButton*)sender{
    //    allSwitch = (allSwitch+1)%2;
    //    NSString *command = [NSString stringWithFormat:@"/all/power"];
    //    NSLog(@"%@",command);
    //    if (allSwitch==1) {
    //        [self.message sendMessage:command Float:1.0000];
    //        [self.powerBtn setImage:[UIImage imageNamed:@"all-on.png" ]forState:UIControlStateNormal];
    //    }
    //    else{
    //        [self.message sendMessage:command Float:0.0000];
    //        [self.powerBtn setImage:[UIImage imageNamed:@"all-off.png" ]forState:UIControlStateNormal];
    //    }
    
    int i=(int)[sender tag];
    
    NSString * command=[NSString stringWithFormat:@"/all/power"];
    
    switch (i) {
        case 40:
            [self.message sendMessage:command Float:1.0000];
            command = [command stringByAppendingString:@",on"];
            break;
        case 41:
            [self.message sendMessage:command Float:0.0000];
            command = [command stringByAppendingString:@",off"];
        default:
            break;
    }
    NSLog(@"%@",command);
}
- (void)dealloc {
    [_compu1 release];
    [_compu2 release];
    [_compu3 release];
    [_compu4 release];
    [_pro1 release];
    [_pro2 release];
    [_pro3 release];
    [_pro4 release];
    [_pro5 release];
    [_pro6 release];
    [_pro7 release];
    [_pro8 release];
    [_powerBtn release];
    [_powerOnBtn release];
    [_powerOffBtn release];
    [super dealloc];
}
@end
