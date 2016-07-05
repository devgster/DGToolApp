//
//  DGViewController.m
//  DGToolApp
//
//  Created by Kyungwoo Park on 06/27/2016.
//  Copyright (c) 2016 Kyungwoo Park. All rights reserved.
//

#import "DGViewController.h"
#import "Tool_App.h"

@interface DGViewController ()

@end

@implementation DGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *platformString = [UIDevice platformString];
    NSString *currentDevice = [UIDevice platformStringSimple];
    
    KKLogDebug(@"123123123 = %@ / %@",platformString,currentDevice);
    
    KKLogDebug(@"678678678 = %@ / %@ / %@ / %@",[UIDevice country],[UIDevice countryShort],[UIDevice language],[UIDevice languageShort]);
    
    [UIDevice setDebugCountry:@"US"];
    [UIDevice setDebugLanguage:@"en"];
    
    KKLogDebug(@"090909090 = %@ / %@ / %@ / %@",[UIDevice country],[UIDevice countryShort],[UIDevice language],[UIDevice languageShort]);
    
    KKLogDebug(@"NSLocalizedString = %@ ",NSLocalizedString(@"test",@""));
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
