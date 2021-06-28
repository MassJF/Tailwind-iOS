//
//  PageWidgetCell.m
//  ScrollPageView
//
//  Created by superMa on 15/10/18.
//  Copyright © 2015年 superMa. All rights reserved.
//

#import "PageWidgetCell.h"

@interface PageWidgetCell ()

@property (strong, nonatomic) UIActivityIndicatorView *iv;
@property (nonatomic) NSInteger index;
@end

@implementation PageWidgetCell

-(instancetype)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil withIndex:(NSInteger)index{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.iv.hidden = YES;
//    self.iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:self.iv];
//
//    [self.iv startAnimating];
    UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellBeenTapped)];
    [self.view addGestureRecognizer:tr];
}

-(void)cellBeenTapped{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageWidgetCellBeenTapped:)]){
        [self.delegate pageWidgetCellBeenTapped:self.index];
    }
}

-(void)viewDidLayoutSubviews{
    self.iv.center = self.view.center;
}

-(id)copyWithZone:(NSZone* )zone{
    //重写copy方法
    PageWidgetCell* page = [[[self class] allocWithZone:zone] init];
    page.view.backgroundColor = self.view.backgroundColor;
    page.view.frame = self.view.frame;
    return page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
