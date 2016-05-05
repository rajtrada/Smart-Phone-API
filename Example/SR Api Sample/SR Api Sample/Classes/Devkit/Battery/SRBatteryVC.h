//
//  SRBatteryVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRBatteryVC : UIViewController<SRCentralManagerDelegate>

@property (nonatomic,retain)SRCentralManager *srManagerObj;
@property (weak, nonatomic) IBOutlet UILabel *lblBatteryLevelValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;

@end
