//
//  CentPickerViewData.h
//  PushApp
//
//  Created by ma on 14/11/14.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuperPickerViewData : NSObject

@property (nonatomic) NSInteger selectedIndex;

//-(void)setData:(NSArray *)data selectAtIndex:(NSInteger)index;
-(id)initWithData:(NSArray *)data setSelectAtIndex:(NSInteger)index;
-(NSString *)getObjectAtIndex:(NSInteger)index;
-(NSInteger)getCount;

@end
