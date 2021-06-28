//
//  AFNetworkConfig.m
//  Utils
//
//  Created by superMa on 2017/3/4.
//
//

#import "AFNetworkConfig.h"

static AFNetworkConfig *sharedAFNetWorkConfig = nil;

@implementation AFNetworkConfig

+(AFNetworkConfig *)shareAFNetWorkConfig{
    
    if(!sharedAFNetWorkConfig){
        sharedAFNetWorkConfig = [[AFNetworkConfig alloc] init];
    }
    return sharedAFNetWorkConfig;
}

@end
