//
//  ViewController.m
//  TestAppSegmentObjC
//
//  Created by Maxim Shoustin on 2/19/17.
//  Copyright © 2017 Maxim Shoustin. All rights reserved.
//

#import "ViewController.h"
#import <Analytics/SEGAnalytics.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrackEventClick:(id)sender {
    
    [[SEGAnalytics sharedAnalytics] track:@"Item Purchased"
                               properties:@{
                                            @"item": @"Sword of Heracles",
                                            @"revenue": @"2.95" }];
    
        
    

}


@end
