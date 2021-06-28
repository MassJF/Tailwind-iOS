//
//  CentPickerViewData.m
//  PushApp
//
//  Created by ma on 14/11/14.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "SuperPickerViewData.h"

@interface SuperPickerViewData()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SuperPickerViewData

-(id)initWithData:(NSArray *)data setSelectAtIndex:(NSInteger)index{
    self = [super init];
    if(self){
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
//        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        self.selectedIndex = index;
    }
    return self;
}

-(void)setData:(NSArray *)data selectAtIndex:(NSInteger)index{
    self.selectedIndex = index;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data];
}

-(NSString *)getObjectAtIndex:(NSInteger)index{
    return [self.dataArray objectAtIndex:index];
}

-(NSInteger)getCount{
    return [self.dataArray count];
}

@end
