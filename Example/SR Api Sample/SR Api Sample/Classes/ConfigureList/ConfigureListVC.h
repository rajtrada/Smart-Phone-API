//
//  ConfigureListVC.h
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface ConfigureListVC : UIViewController

{
    NSMutableArray *mutArrConfiguration,*mutArrImages;
}

@property(nonatomic,retain)SRCentralManager *srManagerObj;
@property (nonatomic,retain)NSMutableArray *mutArrDeviceInfo;


@end
