//
//  SRWaterSensorVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRWaterSensorVC.h"

@interface SRWaterSensorVC ()

@end

@implementation SRWaterSensorVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/alarmclock.wav",
                               [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                         error:nil];
    
    self.lblWaterSensorValue.layer.borderWidth = 1.0f;
    self.lblWaterSensorValue.layer.borderColor = [[UIColor colorWithRed:47.0f/225.0f green:180.0f/225.0f blue:227.0f/225.0f alpha:1] CGColor];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    self.lblDeviceStatusMessage.text = @"Connected";
    
    self.lblWaterSensorValue.text = @"NOT DETECTED";
    
    self.srManagerObj.srDelegate = self;
    
    [self.srManagerObj getWaterSensor];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didGetWaterSensor:(NSData *)data
{
    int waterPresence = [data byteAtIndex:1];
    
    if(waterPresence == 1){
        self.lblWaterSensorValue.text = @"DETECTED";
        self.player.volume = 0.2f;
        self.player.numberOfLoops = -1; //Infinite
        
        if([self.player prepareToPlay])
            [self.player play];
        
    }
    else
    {
        self.lblWaterSensorValue.text = @"NOT DETECTED";
        [self.player stop];
    }
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
