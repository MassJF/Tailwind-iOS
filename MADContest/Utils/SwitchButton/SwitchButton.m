//
//  SwitchButton.m
//  zgxt
//
//  Created by superMa on 15/11/21.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import "SwitchButton.h"

@interface SwitchButton()

@property (nonatomic) BOOL on;

@end

@implementation SwitchButton

-(instancetype)init{
    self = [super init];
    if(self){
        self.on = NO;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.on = NO;
    }
    return self;
}

-(BOOL)getOnOff{
    return self.on;
}

-(void)didClicked{
    [self setClicked:!self.on];
}

-(void)setClicked:(BOOL)clicked{
    self.on = clicked;
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(switchButtonDidClick:)]){
//        [self.delegate switchButtonDidClick:self.on];
//    }
//    if(self.on){
//        self.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.3f];
//    }else{
//        self.backgroundColor = [UIColor clearColor];
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
