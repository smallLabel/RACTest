//
//  SLSignInService.h
//  RACTest
//
//  Created by lijunhong on 2017/5/31.
//  Copyright © 2017年 smallLabel. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SLSignInServiceBlock) (BOOL success);

@interface SLSignInService : NSObject

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(SLSignInServiceBlock)completeBlock;

@end
