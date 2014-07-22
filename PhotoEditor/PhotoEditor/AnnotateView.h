//
//  AnnotateView.h
//  PhotoEditor
//
//  Created by Karthik Saligrama on 7/21/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotateView : UIImageView

@property(nonatomic,strong)UIColor *annotateColor;

- (id)initWithColor:(UIColor *)color;

-(void)annotationDone;

@end
