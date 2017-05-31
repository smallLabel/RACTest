//
//  ViewController.m
//  RACTest
//
//  Created by lijunhong on 2017/5/10.
//  Copyright © 2017年 smallLabel. All rights reserved.
//

//#import <ReactiveObjC/NSObject+RACPropertySubscribing.h>
#import "ViewController.h"
#import "Person.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController () <UITextFieldDelegate>

@property(nonatomic, retain) Person *xiaoming;

@property(nonatomic, copy) NSString *name ;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *paseword;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //目标-动作模式
//    [self.userName addTarget:self action:@selector(userNameContentChanged) forControlEvents:UIControlEventEditingChanged];
    
    //通知消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNameContentChanged) name:UITextFieldTextDidChangeNotification object:self.userName];
    
    /*
    [self.userName.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    [[self.paseword.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        
        return value.length>3;
        
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [[[self.userName.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }] filter:^BOOL(id  _Nullable value) {
        NSNumber *num = (NSNumber *)value;
        return num.intValue>3;
    }] subscribeNext:^(id  _Nullable x) {
        NSNumber *num = (NSNumber *)x;
        NSLog(@"%d",num.intValue);
    }];
    
    RACSignal *validUserNameSingle = [self.userName.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }];
    
    [[validUserNameSingle filter:^BOOL(NSNumber *  _Nullable value) {
        return value.intValue>6;
    }] subscribeNext:^(id  _Nullable x) {
        self.userName.backgroundColor = x?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    
    RAC(self.userName, backgroundColor) = [validUserNameSingle map:^id _Nullable(NSNumber *  _Nullable value) {
        return [value boolValue]?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RAC(self.paseword, backgroundColor) = [[self.paseword.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }] filter:^BOOL(NSNumber *  _Nullable value) {
        return value.integerValue>6?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    */
    
}

- (void)userNameContentChanged {
    NSLog(@"%@",self.userName.text);
}


- (void)test {
    self.xiaoming = [[Person alloc] init];
    self.xiaoming.name = @"XIAOMING";
    
    @weakify(self);
    [RACObserve(self.xiaoming, name) subscribeNext:^(id x) {
        @strongify(self);
        self.name = x;
        NSLog(@"x:%@",x);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    UITextField *textField = [[UITextField alloc] init];
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
