//
//  SRDevKitVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRDevKitVC : UIViewController<SRCentralManagerDelegate>

{
    IBOutlet UIScrollView *scrView;
    IBOutlet UIView *viewMain;
}

@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
