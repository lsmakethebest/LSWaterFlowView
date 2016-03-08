




//
//  LSPhoto.m
//  瀑布流
//
//  Created by song on 15/10/31.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSPhoto.h"

@implementation LSPhoto
+(instancetype)photoWithDict:(NSDictionary*)dict
{
    LSPhoto *photo= [[self alloc] init];
    [photo setValuesForKeysWithDictionary:dict];
    return photo;
}
@end
