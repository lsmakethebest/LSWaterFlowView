//
//  LSPhoto.h
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LSPhoto : NSObject
 @property(nonatomic,assign) CGFloat h;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *img;
+(instancetype)photoWithDict:(NSDictionary*)dict;
@end
