//
//  SRDeviceListVC.h
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>
#import "SRDejalActivityView.h"

@interface SRDeviceListVC : UITableViewController<CBCentralManagerDelegate,CBPeripheralDelegate,SRCentralManagerDelegate,UIScrollViewDelegate>

{
    NSMutableArray *mutArrPeripherals;
    int intUpdateCounter;
    SRCentralManager *srManagerObj;
    UIRefreshControl *refreshControl ;
    NSMutableDictionary  *muDictServicesAndCharacteristic;
    NSTimer *timer,*timerReload;
    NSMutableArray *mutArrFiltered;
    BOOL isSearching,boolIsConnecting;
    IBOutlet UISearchBar *searchBarDevice;
    CBPeripheral *pheripheral ;
    IBOutlet UIActivityIndicatorView *actIndView;
    UIButton *btnUpgradeAll;
    int intCurrentDeviceIndex;
    BOOL boolBtnUpgradeClicked;
    NSMutableArray *selectedIndexes;
}

@end

