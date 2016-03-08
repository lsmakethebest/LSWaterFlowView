//
//  LSWaterFlowView.h
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSWaterFlowViewCell.h"
typedef enum
{
    LSWaterFlowViewMarginTypeTop,
    LSWaterFlowViewMarginTypeBottom,
    LSWaterFlowViewMarginTypeLeft,
    LSWaterFlowViewMarginTypeRight,
    LSWaterFlowViewMarginTypeRow,
    LSWaterFlowViewMarginTypeColumn
}LSWaterFlowViewMarginType;

@class LSWaterFlowView;

/**
 *数据源方法
 */
@protocol LSWaterFlowViewDatasource  <NSObject>
@optional
/**
 *多少列 默认3列
 */
-(NSInteger)numbersOfColumnInWaterFlowView:(LSWaterFlowView*)waterFlowView;
@required
/**
 *多少个
 */
-(NSInteger)numbersOfCellsInWaterFlowView:(LSWaterFlowView*)waterFlowView;
/**
 *每一组的cell
 */
-(LSWaterFlowViewCell*)waterFlowView:(LSWaterFlowView*)waterFlowView cellForIndex:(NSInteger)index;
@end

/**
 *代理方法
 */
@protocol LSWaterFlowViewDelegate  <NSObject>

@required

/**
 *每一组的高度
 */
-(CGFloat)waterFlowView:(LSWaterFlowView*)waterFlowView heightForIndex:(NSInteger)index ;

@optional
/**
 *间距
 */
-(CGFloat)waterFlowView:(LSWaterFlowView*)waterFlowView marginWithType:(LSWaterFlowViewMarginType)type;
/**
 *选中某一项
 */
-(void)waterFlowView:(LSWaterFlowView*)waterFlowView didSelectedAtIndex:(NSInteger)index;

@end

@interface LSWaterFlowView : UIScrollView

@property (nonatomic, weak) id<LSWaterFlowViewDelegate> myDelegate;
@property (nonatomic, weak) id<LSWaterFlowViewDatasource> dataSource;
-(CGFloat)cellWidth;
-(void)reloadData;
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
