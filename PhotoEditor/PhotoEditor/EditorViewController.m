//
//  EditorViewController.m
//  PhotoEditor
//
//  Created by Karthik Saligrama on 7/21/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import "EditorViewController.h"
#import "AnnotateView.h"
#import "StickyView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EditorViewController ()<UITabBarDelegate,MFMailComposeViewControllerDelegate>{
    UIImage *screenShot;
    UITabBar *tabBar;
    UIBarButtonItem *doneButton;
    MFMailComposeViewController *emailDialog;
    UIImageView *imageView;
}

@end

@implementation EditorViewController

static EditorViewController *currentInstance = nil;

+(id)createInstance:(UIView *)previousView{
    currentInstance = [[self alloc] initPrivate];
    
    if(previousView)
        [currentInstance captureScreen:previousView];
    
    return currentInstance;
}

-(void)captureScreen:(UIView *)screen {
    UIGraphicsBeginImageContext(screen.frame.size);
	[screen.layer renderInContext:UIGraphicsGetCurrentContext()];
	screenShot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (id)initPrivate {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)init
{
    return currentInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    imageView = [[UIImageView alloc]initWithImage:screenShot];
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.y = self.view.frame.size.height/2 - imageView.frame.size.height/2;;
    imageFrame.origin.x = self.view.frame.size.width/2 - imageView.frame.size.width/2;
    imageView.center = self.view.center;
    imageView.frame = imageFrame;

    [self.view addSubview:imageView];
    
    tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:tabBar];
    
    UITabBarItem *firstTabItem = [[UITabBarItem alloc]initWithTitle:@"Draw" image:[UIImage imageNamed:@"pencil"] tag:0];
    UITabBarItem *secondTabItem = [[UITabBarItem alloc]initWithTitle:@"Message" image:[UIImage imageNamed:@"message"] tag:1];
    UITabBarItem *thirdTabItem = [[UITabBarItem alloc]initWithTitle:@"Eraser" image:[UIImage imageNamed:@"eraser"] tag:2];
    UITabBarItem *fourthTabItem = [[UITabBarItem alloc]initWithTitle:@"Undo" image:[UIImage imageNamed:@"undo"] tag:3];
    UITabBarItem *fifthTabItem = [[UITabBarItem alloc]initWithTitle:@"Email" image:[UIImage imageNamed:@"email"] tag:4];
    NSArray *itemsArray = [NSArray arrayWithObjects:firstTabItem,secondTabItem,thirdTabItem,fourthTabItem,fifthTabItem, nil];
    
    [tabBar setItems:itemsArray];
    tabBar.delegate=self;
    doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void)startDrawing{
    AnnotateView *v= [[AnnotateView alloc]initWithColor:[UIColor redColor]];
    CGRect frame = self.view.frame;
    frame.size.height -= tabBar.frame.size.height;
    v.frame=frame;
    [self.view addSubview:v];
}

-(void)sendMail{
    //Create a string with HTML formatting for the email body
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    
    //Add some text to it however you want
    [emailBody appendString:@"<p>Some email body text can go here</p>"];
    
    //Pick an image to insert
    //This example would come from the main bundle, but your source can be elsewhere
    tabBar.hidden = YES;
    [self captureScreen:self.view];
    UIImage *emailImage = screenShot;
    tabBar.hidden = NO;
    //Convert the image into data
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    
    //Create a base64 string representation of the data using NSData+Base64
    NSString *base64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //Add the encoded string to the emailBody string
    //Don't forget the "<b>" tags are required, the "<p>" tags are optional
    [emailBody appendString:[NSString stringWithFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>",base64String]];
    
    //You could repeat here with more text or images, otherwise
    //close the HTML formatting
    [emailBody appendString:@"</body></html>"];
    NSLog(@"%@",emailBody);
    
    //Create the mail composer window
    emailDialog = [[MFMailComposeViewController alloc] init];
    emailDialog.mailComposeDelegate = self;
    [emailDialog setSubject:@"My Inline Image Document"];
    [emailDialog setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:emailDialog animated:YES completion:^{
        
    }];
}

-(void) addSticky{
    StickyView *stickyView = [[StickyView alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    [self.view addSubview:stickyView];
}

-(void)erase{
    AnnotateView *v = [[AnnotateView alloc]initWithColor:[UIColor whiteColor]];
    CGRect frame = self.view.frame;
    frame.size.height -= tabBar.frame.size.height;
    v.frame=frame;
    [self.view addSubview:v];
}

-(void)undo{
    NSArray *views = [self.view subviews];
    
    if([views count]>1)
        [((UIView *)[views lastObject]) removeFromSuperview];
}

-(void)done:(id)sender{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [tabBar setUserInteractionEnabled:YES];
    [tabBar setSelectedItem:nil];
    NSArray *views = [self.view subviews];
    
    if([views count]>2)
        [((UIView *)[views lastObject]) setUserInteractionEnabled:NO];
    
    UIView *topView = (UIView *)[views lastObject];
    topView.clipsToBounds = YES;
}

#pragma mark - UITabBarDelegate Methods

-(void)tabBar:(UITabBar *)t didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            [self startDrawing];
            break;
        case 1:
            [self addSticky];
            break;
        case 2:
            [self erase];
            break;
        case 3:
            [self undo];
            break;
        case 4:
            [self sendMail];
            break;
        default:
            break;
    }
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [t setUserInteractionEnabled:NO];
}


#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        default:
            break;
    }
}
@end
