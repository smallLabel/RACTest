//
//  SLSignInService.m
//  RACTest
//
//  Created by lijunhong on 2017/5/31.
//  Copyright © 2017年 smallLabel. All rights reserved.
//

#import "SLSignInService.h"

@implementation SLSignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SLSignInServiceBlock)completeBlock {
    if (username && password) {
        completeBlock(YES);
    } else {
        completeBlock(NO);
    }
}

@end
