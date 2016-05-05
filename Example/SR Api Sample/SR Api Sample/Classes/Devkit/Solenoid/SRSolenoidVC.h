//
//  SRSolenoidVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRSolenoidVC : UIViewController<SRCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnOperate;
@property (nonatomic,retain)SRCentralManager *srManagerObj;

- (IBAction)actionOperate:(id)sender;
@end
