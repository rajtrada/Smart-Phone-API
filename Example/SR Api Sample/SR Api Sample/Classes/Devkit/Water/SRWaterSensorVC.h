//
//  SRWaterSensorVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface SRWaterSensorVC : UIViewController<SRCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblWaterSensorValue;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
