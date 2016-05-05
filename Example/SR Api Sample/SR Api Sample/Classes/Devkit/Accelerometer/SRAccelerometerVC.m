//
//  SRAccelerometerVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRAccelerometerVC.h"

@interface SRAccelerometerVC ()

@end

@implementation SRAccelerometerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
   
    self.lblDeviceStatusMessage.text = @"Connected";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.srManagerObj.srDelegate = self;
    
    [self.srManagerObj getAccelerometer];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.srManagerObj setSrDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didOperationFailWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Operation failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didGetAccelerometer:(NSData *)data
{
    NSData *xData = [data subdataWithRange:(NSRange){1,2}];
    signed int xValue = CFSwapInt16(*(int*)([xData bytes]));
    
    NSData *yData = [data subdataWithRange:(NSRange){3,2}];
    signed int yValue = CFSwapInt16(*(int*)([yData bytes]));
    
    NSData *zData = [data subdataWithRange:(NSRange){5,2}];
    signed int zValue = CFSwapInt16(*(int*)([zData bytes]));
    
    float x,y,z ;
    x = ((xValue > 32767) ? (xValue - 65536)/1000.0f : xValue/1000.0f);
    y = ((yValue > 32767) ? (yValue - 65536)/1000.0f : yValue/1000.0f);
    z = ((zValue > 32767) ? (zValue - 65536)/1000.0f : zValue/1000.0f);
    
    
    [_lblX setText: [NSString stringWithFormat:@"%0.1f g",(x > -0.094f && x < -0.0f) ? 0.0f :x]];
    [_lblY setText: [NSString stringWithFormat:@"%0.1f g",(y > -0.094f && y < -0.0f) ? 0.0f :y]];
    [_lblZ setText: [NSString stringWithFormat:@"%0.1f g",(z > -0.094f && z < -0.0f) ? 0.0f :z]];
    
    [self.imgX setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Xbar%0.1f.png",(x > -0.094f && x < -0.0f) ? 0.0f :x]]];
    [self.imgY setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Ybar%0.1f.png",(y > -0.094f && y < -0.0f) ? 0.0f :y]]];
    [self.imgZ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Zbar%0.1f.png",(z > -0.094f && z < -0.0f) ? 0.0f :z]]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
