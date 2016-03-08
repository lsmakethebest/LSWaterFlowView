//
//  ViewController.m
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "ViewController.h"
#import "LSWaterFlowView.h"
#import "LSPictureCell.h"
#import "LSPhoto.h"
@interface ViewController ()<LSWaterFlowViewDatasource,LSWaterFlowViewDelegate>
@property (nonatomic, strong) NSMutableArray *pictures;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LSWaterFlowView *waterFloaView=[[LSWaterFlowView alloc]init];
    waterFloaView.frame=self.view.bounds;
    waterFloaView.myDelegate=self;
    waterFloaView.dataSource=self;
    [self.view addSubview:waterFloaView];
    
}
-(NSMutableArray *)pictures
{
    if (_pictures==nil) {
        _pictures=[NSMutableArray array];
        NSString *path=[[NSBundle mainBundle]pathForResource:@"1.plist" ofType:nil];
        NSArray *arr =[NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            LSPhoto *photo=[LSPhoto photoWithDict:dict];
            [_pictures addObject:photo];
        }
    }
    return _pictures;
}
-(NSInteger)numbersOfCellsInWaterFlowView:(LSWaterFlowView *)waterFlowView
{
    return self.pictures.count;
}
-(LSWaterFlowViewCell*)waterFlowView:(LSWaterFlowView *)waterFlowView cellForIndex:(NSInteger)index
{
    LSPictureCell *cell=[LSPictureCell pictureCell:waterFlowView];
     LSPhoto *photo=self.pictures[index];
    cell.photo=photo;
    return cell;
}
-(CGFloat)waterFlowView:(LSWaterFlowView *)waterFlowView heightForIndex:(NSInteger)index
{
    CGFloat cellW=[waterFlowView cellWidth];
    LSPhoto *photo=self.pictures[index];
    CGFloat h=photo.h/photo.w*cellW;
    return h;
}
//-(void)waterFlowView:(LSWaterFlowView *)waterFlowView didSelectedAtIndex:(NSInteger)index
//{
//    NSLog(@"index====%d",index);
//}
@end
