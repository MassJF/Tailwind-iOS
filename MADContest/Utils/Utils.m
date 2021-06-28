//
//  Utils.m
//  liantongbao
//
//  Created by superMa on 16/7/26.
//  Copyright © 2016年 Bai Yue Qian Xi. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSDictionary *)readParamsFromUrl:(NSString *)url{
    
    if(!url || [url length] < 1) return nil;
    
    NSArray *urlComponents = [url componentsSeparatedByString:@"?"];
    
    if(!urlComponents || [urlComponents count] == 0) return nil;
    
    NSString *paramsStr = [urlComponents lastObject];
    
    if(!paramsStr || [paramsStr length] < 1) return nil;
    
    NSArray *paramPairs = [paramsStr componentsSeparatedByString:@"&"];
    
    if(!paramPairs || [paramPairs count] == 0) return nil;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for(NSString *str in paramPairs){
        if(!str || [str length] < 1) continue;
        
        NSArray *keyValue = [str componentsSeparatedByString:@"="];
        [result setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
    }
    
    return result;
}

+(NSString *)decimalNumberFormatter:(NSString *)number{
    NSString *result = number;
    
    if([result rangeOfString:@","].length > 0 || [result rangeOfString:@"，"].length > 0)
        return result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    double dn = [number doubleValue];
    result = [formatter stringFromNumber:[NSNumber numberWithDouble:dn]];
    
    return result;
}

+(void)setScrollView:(UIScrollView* )scrollView MaxTopOffset:(float)maxTopOffset maxBottomOffset:(float)maxBottomOffset{
    CGFloat offset = scrollView.contentOffset.y;
    
    if(offset < -maxTopOffset){
        dispatch_async(dispatch_get_main_queue(), ^{
            scrollView.contentOffset = CGPointMake(0.0f, -maxTopOffset);
        });
    }
    if(offset >= scrollView.contentSize.height - scrollView.frame.size.height + maxBottomOffset){
        dispatch_async(dispatch_get_main_queue(), ^{
            scrollView.contentOffset = CGPointMake(0.0f, scrollView.contentSize.height - scrollView.frame.size.height + maxBottomOffset);
        });
    }
}

+(void)addRoundRectWithContext:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius{
    float x1 = rect.origin.x;
    float y1 = rect.origin.y;
    float x2 = x1 + rect.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1 + rect.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(context, x1, y1 + radius);
    CGContextAddArcToPoint(context, x1, y1, x1 + radius, y1, radius);
    
    CGContextAddArcToPoint(context, x2, y2, x2, y2 + radius, radius);
    CGContextAddArcToPoint(context, x3, y3, x3 - radius, y3, radius);
    CGContextAddArcToPoint(context, x4, y4, x4, y4 - radius, radius);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

+(void)keyboardChangeHelper:(BOOL)showOrHide withScrollView:(UIScrollView *)scrollView withTargetView:(UIView *)target withKeyboardSize:(CGSize)keyboardSize{
    if(showOrHide){
        UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
        
        CGRect windowFrame = window.frame;
        windowFrame.size.height -= keyboardSize.height;
        
        CGRect textFieldFrame = [target convertRect:target.bounds toView:window];
        CGFloat offset = CGRectGetMaxY(textFieldFrame) - CGRectGetMaxY(windowFrame) + 10.0f;
        
        UIEdgeInsets insets = scrollView.contentInset;
        insets.bottom = keyboardSize.height;
        [scrollView setContentInset:insets];
        
        if(offset > 0.0f){
            CGPoint contentOffset = scrollView.contentOffset;
            contentOffset.y += offset;
            [scrollView setContentOffset:contentOffset animated:YES];
        }
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            UIEdgeInsets insets = scrollView.contentInset;
            insets.bottom = 0.0f;
            [scrollView setContentInset:insets];
        }];
    }
}

+(void)saveCookie{
//    NSLog(@"=============获取cookie==============");
    //获取cookie
    /*NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *tempCookie in cookies) {
        //打印获得的cookie
        NSLog(@"getCookie: %@", tempCookie);
    }*/
    
    /*
     * 把cookie进行归档并转换为NSData类型
     * 注意：cookie不能直接转换为NSData类型，否则会引起崩溃。
     * 所以先进行归档处理，再转换为Data
     */
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if(cookies){
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        //存储归档后的cookie
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject: cookiesData forKey: @"cookie"];
    }
}

+(void)setCoookie{
//    NSLog(@"============再取出保存的cookie重新设置cookie===============");
    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    if (cookies) {
//        NSLog(@"有cookie");
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
//        NSLog(@"无cookie");
    }
    
    //打印cookie，检测是否成功设置了cookie
    /*NSArray *cookiesA = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesA) {
        NSLog(@"setCookie: %@", cookie);
    }
    NSLog(@"\n");*/
}

+(NSDictionary* )readParamsFromString:(NSString* )str{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(str){
        NSArray* array1 = [str componentsSeparatedByString:@"?"];
        
        if(array1 && [array1 count] > 1){
            NSString* paramsStr = [array1 objectAtIndex:1];
            NSArray* array2 = [paramsStr componentsSeparatedByString:@"&"];
            
            if(array2 && [array2 count] > 0){
                for(NSString* s in array2){
                    NSArray* array3 = [s componentsSeparatedByString:@"="];
                    
                    if(array3 && [array3 count] == 2){
                        [params setObject:[array3 objectAtIndex:1] forKey:[array3 objectAtIndex:0]];
                    }
                }
            }
        }
    }
    
    return params;
}

+(CGSize)getScreenSize{
    return [UIScreen mainScreen].bounds.size;
}

+(NSAttributedString* )attributedStringWithString:(NSString* )str withFontSize:(CGFloat)fontSize withLineSpace:(CGFloat)lineSpace{
    NSString* string = @" ";
    if(str){
        string = str;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length] - 1)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, [string length] - 1)];
    
    return attributedString;
}

+(CGFloat)heightForString:(NSAttributedString *)value andWidth:(float)width{
    NSRange range = NSMakeRange(0, value.length);
    
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [value attributesAtIndex:0 effectiveRange:&range];
    
    // 计算文本的大小
    CGSize sizeToFit = [value.string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                               attributes:dic        // 文字的属性
                                                  context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height;
}

//正则查找所有匹配串
+(void)completeAllImageTagsWithContent:(NSMutableString* )content withPattern:(NSString* )pattern withBaseUrl:(NSString* )Url{
    
    if(content && pattern){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        
        NSArray *matches = [regex matchesInString:content
                                          options:NSMatchingReportProgress
                                            range:NSMakeRange(0, content.length)];
        
        //倒序枚举器
        //正序会推延后续字符的下标 逻辑错误
        for(NSTextCheckingResult *result in [matches reverseObjectEnumerator]){
            NSRange matchRange = [result range];
            [content insertString:[NSString stringWithFormat:@"%@/", Url] atIndex:matchRange.location + matchRange.length];
        }
    }
}


+(BOOL)regularExpressionCheckForString:(NSString* )source withPattern:(NSString* )pattern{
    BOOL result = NO;
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (regex) {
        NSRange firstMatchRange = [regex rangeOfFirstMatchInString:source options:NSMatchingReportProgress range:NSMakeRange(0, [source length])];
        
        if(firstMatchRange.location == 0 && firstMatchRange.length == [source length]){
            result = YES;
        }
    }
    return result;
}

-(UIImage* )loadImageFromFileWithPath:(NSString* )path withName:(NSString *)imageName{
    NSString *fullPath = [[[NSHomeDirectory()
                            stringByAppendingPathComponent:@"Documents"]
                           stringByAppendingPathComponent:path]
                          stringByAppendingPathComponent:imageName];
    
    return [[UIImage alloc] initWithContentsOfFile:fullPath];
}

- (void)saveImageToFile:(UIImage *)image withPath:(NSString* )path withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[[NSHomeDirectory()
                            stringByAppendingPathComponent:@"Documents"]
                           stringByAppendingPathComponent:path]
                          stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

+(void)showAlertWithTitle:(NSString* )title
              withMessage:(NSString* )message
              withContext:(UIViewController* )viewController
       withCompletionBlock:(void (^)(void))completionBlock{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                if(completionBlock) completionBlock();
                                            }]];
    [viewController presentViewController:alert animated:YES completion:nil];
#else
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:viewController
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil, nil] show];
#endif
    
}

+(void)showAlertWithTitle:(NSString* )title withMessage:(NSString* )message withContext:(UIViewController* )viewController{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
#else
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:viewController
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil, nil] show];
#endif
    
}

+(CGRect)rectWithCenter:(CGPoint)center withSize:(CGSize)size{
    return CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
}

+(CGPoint)getCenterWithRect:(CGRect)rect{
    return CGPointMake(rect.origin.x + rect.size.width / 2,rect.origin.y + rect.size.height / 2);
}

+(CGRect)moveRect:(CGRect)rect toCenter:(CGPoint)center{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    rect.origin.x = center.x - width / 2;
    rect.origin.y = center.y - height / 2;
    return rect;
}

+(void)setShadowWithView:(UIView* )view offset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(float)opacity{
    view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = offset;//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = opacity;//阴影透明度，默认0
    view.layer.shadowRadius = radius;//阴影半径，默认3
}

+(void)drawTextWithContext:(CGContextRef)context withString:(NSString* )string atCenterInRect:(CGRect)rect withAttribute:(NSDictionary* )attribute{
    UIGraphicsPushContext(context);
    //    CGContextSetAllowsAntialiasing(context, true);
    
    CGSize size = [string boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    CGRect strRect = CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
    strRect = [Utils moveRect:strRect toCenter:[Utils getCenterWithRect:rect]];
    [string drawInRect:strRect withAttributes:attribute];
    
    UIGraphicsPopContext();
}

+(void)drawTextWithContext:(CGContextRef)context withString:(NSString* )string inRect:(CGRect)rect withAttribute:(NSDictionary* )attribute{
    UIGraphicsPushContext(context);
    //    CGContextSetAllowsAntialiasing(context, true);
    
    [string drawInRect:rect withAttributes:attribute];
    
    UIGraphicsPopContext();
}


@end
