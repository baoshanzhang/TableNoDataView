//
//  ViewController.m
//  TableNoDataView
//
//  Created by 张宝山 on 2019/11/26.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import "ViewController.h"
#import "RxTureController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    RxTureController *vc = [[RxTureController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
