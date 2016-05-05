//
//  SRStatusVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRStatusVC.h"

@interface SRStatusVC ()

@end

@implementation SRStatusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.lblOperate.layer.cornerRadius = 2;
    self.lblOperate.layer.borderWidth = 1;
    self.lblOperate.layer.borderColor = [[UIColor colorWithRed:47.0f/225.0f green:180.0f/225.0f blue:227.0f/225.0f alpha:1] CGColor];
        
    self.lblDeviceStatusMessage.text = @"Connected";
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.srManagerObj.srDelegate = self;
    
    [self.srManagerObj getSwitchStatus];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.srManagerObj.srDelegate = nil;
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

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didGetSwitchStatus:(NSData *)data
{
    int tempValue = [data byteAtIndex:1];
    [_lblOperate setText:(tempValue == 1 ? @"Pressed" : @"Released")];
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
