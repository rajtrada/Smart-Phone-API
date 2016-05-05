//
//  SRCharacteristicDetailVC.h
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>

@interface SRCharacteristicDetailVC : UIViewController<SRCentralManagerDelegate,UITextFieldDelegate>

{
    IBOutlet UIButton *btnWrite,*btnRead,*btnNotify;
    IBOutlet UITextField *txtFieldValue;
    IBOutlet UISegmentedControl *segmentControl;
    NSString *strASCII,*strHex;
    NSMutableDictionary *mutDictCharProp;
    NSData *aDataValueChar;
}
@property (nonatomic,retain)CBCharacteristic *selectedCharacteristic;
@property (nonatomic,retain)SRCentralManager *srManagerObj;

@end
