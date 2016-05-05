//
//  SRTempSensorVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRTempSensorVC : UIViewController<SRCentralManagerDelegate>

{
    NSNumber *tempValue;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentUnit;

@property (weak, nonatomic) IBOutlet UILabel *lblNote;

-(IBAction)actionUnitValueChanged:(id)sender;

@end
