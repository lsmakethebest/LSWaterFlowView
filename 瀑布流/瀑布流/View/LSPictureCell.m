






//
//  LSPictureCell.m
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSPictureCell.h"
#import "LSPhoto.h"
#import "UIImageView+WebCache.h"
@interface LSPictureCell ()
@property (nonatomic, weak) UIImageView *pictureView;
@property (nonatomic, weak) UILabel *numberLabel;
@end
@implementation LSPictureCell

+(instancetype)pictureCell:(LSWaterFlowView *)waterFlowView
{
    static   NSString *reuseId=@"cell";
    LSPictureCell *cell=[waterFlowView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell=[[self alloc]init];
        cell.identifier=reuseId;
    }
    return cell;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor grayColor];
        UIImageView *picutureView=[[UIImageView alloc]init];
        [self addSubview:picutureView];
        self.pictureView=picutureView;
        
        UILabel *label=[[UILabel alloc]init];
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
        self.numberLabel=label;
        
    }
    return self;
}

-(void)setPhoto:(LSPhoto *)photo
{
    _photo=photo;
    [self.pictureView setImageWithURL:[NSURL URLWithString:photo.img] placeholderImage:[UIImage imageNamed:@""]];
    self.numberLabel.text=photo.price;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pictureView.frame=self.bounds;
    
    CGFloat h=25;
    self.numberLabel.frame=CGRectMake(0, self.frame.size.height-h, self.frame.size.width, h);
    
    
}
@end
