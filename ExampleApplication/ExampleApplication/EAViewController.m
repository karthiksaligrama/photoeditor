//
//  EAViewController.m
//  ExampleApplication
//
//  Created by Karthik Saligrama on 7/21/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import "EAViewController.h"
#import "EditorViewController.h"

@interface EAViewController ()

@end

@implementation EAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Example View Controller";
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apple.png"]];
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.y = 100;
    imageFrame.origin.x = self.view.frame.size.width/2 - imageView.frame.size.width/2;
    imageView.center = self.view.center;
    imageView.frame = imageFrame;
    [self.view addSubview:imageView];
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

-(void)shareAction:(id)sender{
    [self.navigationController pushViewController:[EditorViewController createInstance:self.view] animated:YES];
}

@end
