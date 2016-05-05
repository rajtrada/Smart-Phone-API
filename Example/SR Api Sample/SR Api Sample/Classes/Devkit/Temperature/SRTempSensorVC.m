//
//  SRTempSensorVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRTempSensorVC.h"

@interface SRTempSensorVC ()

@end

@implementation SRTempSensorVC

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
    
    [self.srManagerObj getTemperatureSensor];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.srManagerObj.srDelegate = nil;
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didOperationFailWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Operation failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didGetTemperatureSensor:(NSData *)data
{
    NSData *aData = [data subdataWithRange:(NSRange){1,2}];
    
    
    
    
    
    signed int value = CFSwapInt16(*(int*)([aData bytes]));
    tempValue = [NSNumber numberWithInt:value];
    [self calculateTempValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Events
#pragma mark -

- (IBAction)actionUnitValueChanged:(id)sender
{
    self.lblUnit.text = [NSString stringWithFormat:self.segmentUnit.selectedSegmentIndex == 0 ? @"ºC":@"ºF"];
    
    [self calculateTempValue];
}

#pragma mark - Custom Method
#pragma mark -

-(void)calculateTempValue
{    
    if ([tempValue intValue] > 32767)
    {
        float calculatedvalue = (65536-[tempValue intValue])/100.0f;
        self.lblTemperature.text = [NSString stringWithFormat:@"%.1f",(self.segmentUnit.selectedSegmentIndex == 1) ? (((-calculatedvalue * 9.0f) / 5) + 32) :-calculatedvalue];
    }
    else
    {
        float calculatedvalue = [tempValue intValue]/100.0f;
        self.lblTemperature.text = [NSString stringWithFormat:@"%.1f",(self.segmentUnit.selectedSegmentIndex == 1) ? (((calculatedvalue * 9.0f) / 5) + 32) :calculatedvalue];
    }
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
