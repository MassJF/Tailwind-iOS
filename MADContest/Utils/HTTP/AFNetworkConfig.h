//
//  AFNetworkConfig.h
//  Utils
//
//  Created by superMa on 2017/3/4.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkConfig : NSObject

//AFNetworking config
@property (strong, nonatomic) id AFManager;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;

+(AFNetworkConfig *)shareAFNetWorkConfig;

@end
