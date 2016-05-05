//
//  SRAccelerometerVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRAccelerometerVC : UIViewController<SRCentralManagerDelegate>

@property (nonatomic,retain)SRCentralManager *srManagerObj;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblX;
@property (weak, nonatomic) IBOutlet UILabel *lblY;
@property (weak, nonatomic) IBOutlet UILabel *lblZ;
@property (weak, nonatomic) IBOutlet UIImageView *imgX;
@property (weak, nonatomic) IBOutlet UIImageView *imgY;
@property (weak, nonatomic) IBOutlet UIImageView *imgZ;

@end
