//
//  SRLightControlVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRLightControlVC : UIViewController<SRCentralManagerDelegate>

{
    BOOL  boolEventGenerated;
    int intOldIntensity;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceStatusMessage;
@property (weak, nonatomic) IBOutlet UISlider *sliderIntensity;
@property (weak, nonatomic) IBOutlet UILabel *lblIntensity;
@property (weak, nonatomic) IBOutlet UIButton *btnON;
@property (weak, nonatomic) IBOutlet UIButton *btnOFF;
@property (nonatomic,strong) NSTimer *timer;

-(IBAction)sliderValueChanged:(id)sender;
-(IBAction)actionOperateLight:(id)sender;

@end
