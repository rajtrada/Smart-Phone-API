//
//  SRMotionSensorVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRMotionSensorVC : UIViewController<SRCentralManagerDelegate>

{
    BOOL boolISMotionDetected;
}
@property (nonatomic,retain)SRCentralManager *srManagerObj;

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMotion;
@property (weak, nonatomic) IBOutlet UIButton *btnTurnOffMotion;
@property (strong, nonatomic)NSTimer *timerMotionDetected;
- (IBAction)actionTurnOffMotion:(id)sender;

@end
