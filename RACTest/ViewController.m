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

#import "SLSignInService.h"

@interface ViewController () <UITextFieldDelegate>

@property(nonatomic, retain) Person *xiaoming;

@property(nonatomic, copy) NSString *name ;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *paseword;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (strong, nonatomic) SLSignInService *signInService;
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
    //用户名长度信号
    RACSignal *userNameValidSignle = [self.userName.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [self textContentValid:value];
    }];
    //密码长度信号 并进行过滤 长度大于5时有效
    RACSignal *passwordValidSignle = [[self.paseword.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [self textContentValid:value];
    }] filter:^BOOL(NSNumber *  _Nullable value) {
        return value.intValue>5;
    }];
    //组合信号
    RACSignal *combineSignle = [RACSignal combineLatest:@[userNameValidSignle, passwordValidSignle] reduce:^id _Nullable (NSNumber *userNameValid, NSNumber *passwordValid) {
        return @([userNameValid boolValue] && [passwordValid boolValue]);
    }];
    //根据文本框输入内容判断是否满足登录条件
    [combineSignle subscribeNext:^(NSNumber *  _Nullable x) {
        self.signInBtn.enabled = [x boolValue];
    }];
//    [[self.signInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"button click");
//    }];
    //点击登录按钮
    [[[[self.signInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        //按钮点击后的附加操作 不对信号做任何操作
        self.signInBtn.enabled = NO;
    }]  flattenMap:^id _Nullable(__kindof UIControl * _Nullable value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *  _Nullable x) {
        if ([x boolValue]) {
            [self performSegueWithIdentifier:@"pushToCat" sender:self];
        }
    }];
    
}

- (NSNumber *)textContentValid:(NSString *)text {
    return @(text.length);
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



- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        [self.signInService
         signInWithUsername:self.userName.text
         password:self.paseword.text
         complete:^(BOOL success){
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

- (BOOL)signIn {
    return YES;
}

- (SLSignInService *)signInService {
    if (!_signInService) {
        _signInService = [[SLSignInService alloc] init];
    }
    return _signInService;
}

@end
