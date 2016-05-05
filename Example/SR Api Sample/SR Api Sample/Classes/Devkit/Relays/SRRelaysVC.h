//
//  SRRelaysVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRRelaysVC : UIViewController<SRCentralManagerDelegate>

{
    BOOL boolPushButtonPressed;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;
@property (nonatomic,assign)int intBtnUpdate;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBattery;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage,*lblMaintain,*lblMomentry;
@property (weak, nonatomic) IBOutlet UIButton *btnPushButton,*btnPressButton;

- (IBAction)actionPress:(id)sender;
- (IBAction)actionPush:(id)sender;
@end
