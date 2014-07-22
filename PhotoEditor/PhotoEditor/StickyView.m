//
//  StickyView.m
//  PhotoEditor
//
//  Created by Karthik Saligrama on 7/21/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import "StickyView.h"
#import <QuartzCore/QuartzCore.h>
@interface StickyView(){
}

@end

@implementation StickyView

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
UITextView *textView;
UIView *headerView;

-(void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = UIColorFromRGB(0x7a5230).CGColor;
    self.layer.borderWidth=1.0f;
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
    [headerView setBackgroundColor:UIColorFromRGB(0xF3EB92)];
    [self addSubview:headerView];
    
    textView= [[UITextView alloc]initWithFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y+headerView.frame.size.height, self.frame.size.width, self.frame.size.height-headerView.frame.size.height)];
    [textView setBackgroundColor:UIColorFromRGB(0xFFF44F)];
    textView.alpha = 0.75f;
    [self addSubview:textView];
    textView.delegate = self;
    [textView becomeFirstResponder];
}

CGPoint originalPosition;
bool touchedEnd = NO;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            UITouch *touch = [touches anyObject];
            CGPoint location = [touch locationInView:self.superview]; // <--- note self.superview
            originalPosition = location;
        }];
    }];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview]; // <--- note self.superview
    
    self.center = location;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [UIView animateWithDuration:0.2f animations:^{
       self.transform = CGAffineTransformIdentity;
   } completion:^(BOOL finished) {
       UITouch *touch = [touches anyObject];
       CGPoint location = [touch locationInView:self.superview];
       CGPoint leftMostPoint,rightMostPoint,topMostPoint,bottomMostPoint;
       leftMostPoint = CGPointMake(location.x-self.frame.size.width/2, location.y);
       rightMostPoint =CGPointMake(location.x+self.frame.size.width/2, location.y);
       bottomMostPoint = CGPointMake(location.x, location.y + self.frame.size.height/2);
       topMostPoint =CGPointMake(location.x, location.y - self.frame.size.height/2);
       
       if(CGRectContainsPoint(self.superview.frame, leftMostPoint) && CGRectContainsPoint(self.superview.frame, rightMostPoint) && CGRectContainsPoint(self.superview.frame, topMostPoint) && CGRectContainsPoint(self.superview.frame, bottomMostPoint)){
          self.center = location;
       }else{
           CGRect selfFrame =self.frame;
           if(selfFrame.origin.x < 0 ){
               selfFrame.origin.x = 0;
               location.x += selfFrame.size.width/2;
           }else if(location.x+selfFrame.size.width/2 > (self.superview.frame.size.width + self.superview.frame.origin.x)){
               location.x =((self.superview.frame.size.width + self.superview.frame.origin.x)-selfFrame.size.width/2);
           }
           
           if(selfFrame.origin.y < 0){
               selfFrame.origin.y = 0;
               location.y += selfFrame.size.height/2;
           }else if(location.x+selfFrame.size.height/2 > (self.superview.frame.size.height + self.superview.frame.origin.y)){
               location.x =((self.superview.frame.size.height + self.superview.frame.origin.y)-selfFrame.size.height/2);
           }
           
           if(CGRectContainsPoint(selfFrame, location))
               self.center = location;
       }
       
   }];
}


#pragma mark - UItextViewDelegate Methods
-(void)textViewDidEndEditing:(UITextView *)textView{
    CGRect selfFrame =     self.frame;
    selfFrame.size =     [textView contentSize];
    self.frame =selfFrame;
    textView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y+headerView.frame.size.height, self.frame.size.width, selfFrame.size.height-headerView.frame.size.height);
}

@end
