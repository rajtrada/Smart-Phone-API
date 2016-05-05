//
//  SRMotorVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRMotorVC : UIViewController<SRCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;

-(IBAction)actionOperateMotor:(id)sender;

@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
