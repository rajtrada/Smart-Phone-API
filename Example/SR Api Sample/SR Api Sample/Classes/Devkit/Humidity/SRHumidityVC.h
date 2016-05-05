//
//  SRHumidityVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRHumidityVC : UIViewController<SRCentralManagerDelegate>

@property (nonatomic,retain)SRCentralManager *srManagerObj;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidityValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;

@end
