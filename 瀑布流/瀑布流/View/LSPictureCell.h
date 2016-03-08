//
//  LSPictureCell.h
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSWaterFlowViewCell.h"
#import "LSWaterFlowView.h"
@class LSPhoto;
@interface LSPictureCell : LSWaterFlowViewCell
+(instancetype)pictureCell:(LSWaterFlowView*)waterFlowView;
@property (nonatomic, strong) LSPhoto *photo;
@end
