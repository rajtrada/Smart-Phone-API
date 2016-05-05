//
//  AboutDeviceVC.h
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface AboutDeviceVC : UIViewController<SRCentralManagerDelegate>

{
    NSMutableArray *mutArrKeys;
    IBOutlet UITableView *tblInfo;
    BOOL boolIsDFU;
    NSMutableArray *mutArrDeviceInfo;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;
@property (nonatomic,retain)NSMutableArray *mutArrInfo;

@end
