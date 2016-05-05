//
//  SRBatteryVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRBatteryVC.h"

@interface SRBatteryVC ()

@end

@implementation SRBatteryVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.lblDeviceStatusMessage.text = @"Connected";
    
    [self.srManagerObj setSrDelegate:self];
    
    [self.srManagerObj getBatteryLevel];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didGetBatteryLevel:(NSData *)data
{
    float value = [data byteAtIndex:1];
    self.lblBatteryLevelValue.text = [NSString stringWithFormat:@"%.1f v",value/10];
}

- (void)didOperationFailWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Operation failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
