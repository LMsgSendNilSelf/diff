//
//  ViewController.m
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/2.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import "ViewController.h"
#import "DiffDataSource.h"
#import "DiffUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DiffDataSource *cb = [[DiffDataSource alloc] initWithOldDatas:@[@"a",@"c",@"e"] newDatas:@[@"b",@"c",@"a"]];
    DiffResult *r = [DiffUtil diffWithDataSource:cb];
    //todo
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
