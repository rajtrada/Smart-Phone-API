//
//  SRMotionSensorVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRMotionSensorVC.h"

@interface SRMotionSensorVC ()

@end

@implementation SRMotionSensorVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.imgViewMotion.animationImages = @[[UIImage imageNamed:@"motion.png"],[UIImage imageNamed:@"motion1.png"]];
    self.imgViewMotion.animationDuration = 1.0;
    
    self.btnTurnOffMotion.hidden = TRUE;
    
    boolISMotionDetected = FALSE;
    
    self.lblDeviceStatusMessage.text = @"Connected";
    
    self.srManagerObj.srDelegate = self;

    [self.srManagerObj getMotionSensor];
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

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didGetMotionSensor:(NSData *)data
{
    int showMotion = [data byteAtIndex:1];
    if(boolISMotionDetected)
    {
        //return;
    }
    if (showMotion == 1)
    {
        boolISMotionDetected = TRUE;
        self.imgViewMotion.image = [UIImage imageNamed:@"motion.png"];
        self.btnTurnOffMotion.hidden = FALSE;
        [self.imgViewMotion startAnimating];
        self.timerMotionDetected = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(actionTurnOffMotion:) userInfo:nil repeats:NO];
    }
    else
    {
        [self.timerMotionDetected invalidate];
        [self.imgViewMotion stopAnimating];
        self.imgViewMotion.image = [UIImage imageNamed:@"nomotion.png"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Events
#pragma mark -

- (IBAction)actionTurnOffMotion:(id)sender {
    [self.imgViewMotion stopAnimating];
    self.imgViewMotion.image = [UIImage imageNamed:@"nomotion.png"];
    self.btnTurnOffMotion.hidden = TRUE;
    boolISMotionDetected = FALSE;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
