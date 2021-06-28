//
//  Utils.h
//  liantongbao
//
//  Created by superMa on 16/7/26.
//  Copyright © 2016年 Bai Yue Qian Xi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WINDOW [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define GET_STORYBOARD(storyboard_name_string) [UIStoryboard storyboardWithName:storyboard_name_string bundle:nil]
#define selfBounds self.view.bounds
#define selfFrame self.view.frame
#define selfSize self.view.bounds.size

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//#define MOBIL_PHONE_NUMBER_REGULAR_EXPRESSION @"(13\\d|14[57]|15[^4,\\d]|17[678]|18\\d)\\d{8}|170[059]\\d{7}"
#define MOBIL_PHONE_NUMBER_REGULAR_EXPRESSION @"((17[0-9])|(13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8}"
#define PASSWORD_REGULAR_EXPRESSION @"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z~!@#$%^&*?]{6,20}"
#define VALIDATE_CODE_REGULAR_EXPRESSION @"[0-9]{6}"
#define PERSON_ID_REGULAR_EXPRESSION @"\\d{17}[\\d|x|X]|\\d{15}"

#define AppThemeColor [UIColor colorWithRed:0xf1/255.0 green:0x45/255.0 blue:0x03/255.0 alpha:1.0]

@interface Utils : NSObject

+(NSString *)decimalNumberFormatter:(NSString *)number;
+(void)setScrollView:(UIScrollView* )scrollView MaxTopOffset:(float)maxTopOffset maxBottomOffset:(float)maxBottomOffset;
+(void)saveCookie;
+(void)setCoookie;
+(NSDictionary* )readParamsFromString:(NSString* )str;
+(CGSize)getScreenSize;
+(NSAttributedString* )attributedStringWithString:(NSString* )str withFontSize:(CGFloat)fontSize withLineSpace:(CGFloat)lineSpace;
+(CGFloat)heightForString:(NSAttributedString *)value andWidth:(float)width;
+(BOOL)regularExpressionCheckForString:(NSString* )source withPattern:(NSString* )pattern;
+(void)showAlertWithTitle:(NSString* )title withMessage:(NSString* )message withContext:(UIViewController* )viewController;
+(void)showAlertWithTitle:(NSString* )title
              withMessage:(NSString* )message
              withContext:(UIViewController* )viewController
       withCompletionBlock:(void (^)(void))completionBlock;
+(CGPoint)getCenterWithRect:(CGRect)rect;
+(CGRect)rectWithCenter:(CGPoint)center withSize:(CGSize)size;
+(CGRect)moveRect:(CGRect)rect toCenter:(CGPoint)center;
+(void)setShadowWithView:(UIView* )view offset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(float)opacity;
+(void)drawTextWithContext:(CGContextRef)context withString:(NSString* )string atCenterInRect:(CGRect)rect withAttribute:(NSDictionary* )attribute;
+(void)drawTextWithContext:(CGContextRef)context withString:(NSString* )string inRect:(CGRect)rect withAttribute:(NSDictionary* )attribute;
+(void)completeAllImageTagsWithContent:(NSMutableString* )content withPattern:(NSString* )pattern withBaseUrl:(NSString* )Url;
+(void)keyboardChangeHelper:(BOOL)showOrHide withScrollView:(UIScrollView *)scrollView withTargetView:(UIView *)target withKeyboardSize:(CGSize)keyboardSize;
+(void)addRoundRectWithContext:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius;
+(NSDictionary *)readParamsFromUrl:(NSString *)url;

@end
