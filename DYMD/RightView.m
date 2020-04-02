//
//  RightView.m
//  DYMD
//
//  Created by 蒋华阳 on 14-10-3.
//  Copyright (c) 2014年 蒋华阳. All rights reserved.
//

#import "RightView.h"

@implementation RightView
@synthesize tableview;
@synthesize infos=_infos;
@synthesize controller;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)setInfos:(NSDictionary *)infos{
    _infos = infos;
    self.tableview.scrollEnabled = false;
    [self.tableview reloadData];
}
-(void)awakeFromNib{
    self.tableview.scrollEnabled = false;
    [self.tableview setBackgroundColor:[UIColor clearColor]];
    [self.tableview setBackgroundView:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.infos==nil) return 0;
    self.tableview.scrollEnabled = false;
    return [[self.infos objectForKey:@"count"] integerValue];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableview.scrollEnabled = false;
    RightViewCell *cell  = (RightViewCell*)[tableView dequeueReusableCellWithIdentifier:@"EditViewCellIdentifier"];
    if (!cell) {
        cell = (RightViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"RightViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.controller.subType=1;
    }
    [cell setBackgroundView:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    NSDictionary *dic = [_infos objectForKey:[NSString stringWithFormat:@"展项%d",[indexPath row]+1]];
    NSString *iconName = [dic objectForKey:@"icon"] ;
    if ([iconName isEqualToString:@"第一展区.png"] || [iconName isEqualToString:@"第二展区.png"] || [iconName isEqualToString:@"第三展区.png"] || [iconName isEqualToString:@"第四展区.png"]) {
        cell.userInteractionEnabled = FALSE;
    }
    UIImage *im = [UIImage imageNamed:iconName];
    [cell.im setImage:im];
    [cell.im setFrame:CGRectMake(0, 3, 164, 31)];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableview.scrollEnabled = false;
    return 35;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableview.scrollEnabled = false;
    self.controller.subType = [indexPath row]+1;
    
    RightViewCell *cell=(RightViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    //    UIImageView * imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"span.gif"]];
    //    imageView.frame=CGRectMake(0, 10, 30, 30);
    //
    //    [cell addSubview:imageView];
    //
    //    [imageView release];
    UIImageView * imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中边框-45.png"]];
    
    [cell setBackgroundView:imageView];
}
@end
@implementation RightViewCell
@synthesize im;

@end

