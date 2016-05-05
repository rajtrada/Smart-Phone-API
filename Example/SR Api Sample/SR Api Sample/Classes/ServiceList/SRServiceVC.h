//
//  SRServiceVC.h
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRServiceVC : UIViewController<SRCentralManagerDelegate>

{
    NSMutableDictionary *mutDictTableData;
    UIButton *aButtonLeft,*btnInfo;
    IBOutlet UIButton *btnUpgrade;
    IBOutlet UITableView *tblServices;
    IBOutlet UILabel *lblDeviceName;
    IBOutlet UILabel *lblUUID;
    IBOutlet UILabel *lblConnected;
    IBOutlet UILabel *lblSecLevel;
    BOOL boolIsDFU;
}

@property(nonatomic,retain)NSMutableDictionary *mutDictData;
@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
