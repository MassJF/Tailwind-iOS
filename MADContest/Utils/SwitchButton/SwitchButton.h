//
//  SwitchButton.h
//  zgxt
//
//  Created by superMa on 15/11/21.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol SwitchButtonProtocol <NSObject>
//
//-(void)switchButtonDidClick:(BOOL)onOff;
//
//@end

@interface SwitchButton : UIButton

//@property (retain, nonatomic) id<SwitchButtonProtocol>delegate;

-(void)didClicked;
-(void)setClicked:(BOOL)clicked;
-(BOOL)getOnOff;

@end
