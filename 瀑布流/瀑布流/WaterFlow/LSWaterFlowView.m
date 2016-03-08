


//
//  LSWaterFlowView.m
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSWaterFlowView.h"
#define LSWaterFlowViewNumbersOfColumn 3
#define LSWaterFlowViewMargin 8
#define LSWaterFlowViewCellHeight 80
@interface LSWaterFlowView ()
/**
 *存放所有cell的Frame的数组
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *存放当前显示在屏幕上的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayCells;
/**
 *存放创建过的cell,相当于缓存池
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;
@end
@implementation LSWaterFlowView

-(NSMutableArray *)cellFrames
{
    if (_cellFrames==nil) {
        _cellFrames=[NSMutableArray array];
    }
    return _cellFrames;
}
-(NSMutableDictionary *)displayCells
{
    if (_displayCells==nil) {
        _displayCells=[NSMutableDictionary dictionary];
    }
    return _displayCells;
}
-(NSMutableSet *)reusableCells
{
    if (_reusableCells==nil) {
        _reusableCells=[NSMutableSet set];
    }
    return _reusableCells;
}
-(void)reloadData
{
    //没吃重新刷新都清除所有数据
    [self.displayCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells removeAllObjects];
     [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    //总个数
    NSInteger numbersOfCell=[self.dataSource numbersOfCellsInWaterFlowView:self];
    //总列数
    NSInteger numbersOfColumn=[self numbersOfColumn];
    CGFloat marginLeft=[self marginWithType:LSWaterFlowViewMarginTypeLeft];
    CGFloat marginTop=[self marginWithType:LSWaterFlowViewMarginTypeTop];
    CGFloat marginRow=[self marginWithType:LSWaterFlowViewMarginTypeRow];
    CGFloat marginCol=[self marginWithType:LSWaterFlowViewMarginTypeColumn];
    CGFloat cellW=[self cellWidth];
    //定义一个c语言的存放每一列的最大Y值
    CGFloat columnMaxY[numbersOfColumn];
    //开始全部设置为0.0
    for (int i=0; i<numbersOfColumn; i++) {
        columnMaxY[i]=0.0;
    }
    for (int i=0; i<numbersOfCell; i++) {
       //假设第一列为最小Y
        NSInteger column=0;  // 列号为0
        CGFloat maxColumnY=columnMaxY[column];
        for (int j=1; j<numbersOfColumn; j++) {
            if (maxColumnY>columnMaxY[j]) {
                maxColumnY=columnMaxY[j];
                column=j;
            }
        }
        CGFloat cellY;
        CGFloat cellX=marginLeft+(cellW+marginCol)*column;
        CGFloat cellH=[self cellHeightAtIndex:i];
        //第一次为0，所以得加上顶部边距
        if (maxColumnY==0.0) {
            cellY=marginTop;
        }else{
            cellY=maxColumnY+marginRow;
        }

        CGRect frame=CGRectMake(cellX, cellY, cellW, cellH);
        columnMaxY[column]=CGRectGetMaxY(frame);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
        
    }
    //计算contentSize
    CGFloat contentH=columnMaxY[0];
    for (int i=1; i<numbersOfColumn; i++) {
        if (contentH<columnMaxY[i]) {
            contentH=columnMaxY[i];
        }
    }
    CGFloat marginBottom=[self  marginWithType:LSWaterFlowViewMarginTypeBottom];
    contentH+=marginBottom;
    self.contentSize=CGSizeMake(0, contentH);
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    int count=self.cellFrames.count;
    for (int i=0; i<count; i++) {
        //在屏幕上
        LSWaterFlowViewCell *cell=self.displayCells[@(i)];
        CGRect frame=[self.cellFrames[i] CGRectValue];
        if([self isOnScreenWithRect:frame]){
            if (cell==nil) {
                cell=[self.dataSource waterFlowView:self cellForIndex:i];
                cell.frame= frame;
                [self addSubview:cell];
                //存放到记录显示在屏幕上的cell字典中
                self.displayCells[@(i)]=cell;
            }
        }
        else{//不在屏幕上
            if (cell) {
                //从字典中移除同时移除scrolllview
                [self.displayCells removeObjectForKey:@(i)];
                [cell removeFromSuperview];
                //加入缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block  LSWaterFlowViewCell *reuseCell=nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(LSWaterFlowViewCell * cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reuseCell=cell;
            *stop=YES;
        }
    }];
    if (reuseCell) {
        [self.reusableCells removeObject:reuseCell];
    }
    return reuseCell;
}
//计算是否在屏幕上
-(BOOL)isOnScreenWithRect:(CGRect)rect
{
    return   (CGRectGetMaxY(rect)>self.contentOffset.y)&&(CGRectGetMinY(rect)<self.contentOffset.y+self.frame.size.height);
    
}
//计算cell宽度
-(CGFloat)cellWidth
{
    NSInteger columns=[self numbersOfColumn];
    CGFloat marginLeft=[self marginWithType:LSWaterFlowViewMarginTypeLeft];
    CGFloat marginRight=[self marginWithType:LSWaterFlowViewMarginTypeRight];
    CGFloat marginCol=[self marginWithType:LSWaterFlowViewMarginTypeColumn];
    CGFloat cellWidth=(self.frame.size.width-marginLeft-marginRight-(columns-1)*marginCol)/columns;
    return cellWidth;
}
-(CGFloat)cellHeightAtIndex:(NSInteger)index
{
    CGFloat cellHeight=LSWaterFlowViewCellHeight;
    if ([self.myDelegate respondsToSelector:@selector(waterFlowView:heightForIndex:)]) {
        cellHeight=[self.myDelegate waterFlowView:self heightForIndex:index];
    }
    return cellHeight;
}
//计算有多少列
-(NSInteger)numbersOfColumn
{
    NSInteger columns=LSWaterFlowViewNumbersOfColumn;
    if ([self.dataSource respondsToSelector:@selector(numbersOfColumnInWaterFlowView:)]) {
        columns=[self.dataSource numbersOfColumnInWaterFlowView:self];
    }
    return columns;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
[    self reloadData];
}
//根据类型计算边距
-(CGFloat)marginWithType:(LSWaterFlowViewMarginType)type
{
    
    if ([self.myDelegate respondsToSelector:@selector(waterFlowView:marginWithType:)]) {
        return [self.myDelegate waterFlowView:self marginWithType:type];
    }else{
        return LSWaterFlowViewMargin;
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
  __block  NSNumber *selectedIndex=nil;
    [self.displayCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LSWaterFlowViewCell* cell, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex=key;
            *stop=YES;
            
        }
    }];
    if (selectedIndex) {
        if ([self.myDelegate respondsToSelector:@selector(waterFlowView:didSelectedAtIndex:)]) {
            [self.myDelegate waterFlowView:self didSelectedAtIndex:selectedIndex.integerValue];
        }
    }
}
@end
