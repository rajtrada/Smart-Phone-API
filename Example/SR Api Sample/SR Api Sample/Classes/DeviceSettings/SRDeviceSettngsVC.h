//
//  SRDeviceSettngsVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>
#import "SRDejalActivityView.h"
#import "TxPowerSettingsVC.h"
#import "SRDeviceSettingsDetailVC.h"

@interface SRDeviceSettngsVC : UITableViewController<SRCentralManagerDelegate,TxPowerDelegate,SRDeviceSettingsDetailDelegate>

{
    IBOutlet UISwitch *switchMotion,*switchHumidity;
    IBOutlet UILabel *lblTXPower,*lblAntenna,*lblNWConfiguration;
    NSNumber *aNumTxPower;
    int intNWConfiguration;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
